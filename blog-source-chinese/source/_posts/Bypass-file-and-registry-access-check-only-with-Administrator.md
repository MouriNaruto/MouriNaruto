---
title: 仅在管理员权限下绕过文件和注册表访问检查
date: 2021-11-14 04:25:00
categories:
- [技术, Windows, Windows 研究笔记, 用户模式]
tags:
- 技术
- Windows
- Windows 研究笔记
- 用户模式
---

我相信读者看到这个标题会很兴奋，因为本文会提供一种方式使得开发者仅在管理员权限下就能绕过文件和注册表访问检查，
以顺利地修改原本需要 SYSTEM 令牌甚至 TrustedInstaller 令牌下才能访问的内容。本文会对此进行简要的描述。

## 实现方式

使用开源的 Microsoft Detours 库对 Windows NT 内核的文件和注册表相关的系统调用进行 Inline Hook 以传入启用利用
SeBackupPrivilege 和 SeRestorePrivilege 特权的选项让开发者基本不用修改自己的实现也能充分的利用管理员权限所提供的特权。

需要进行 Inline Hook 的系统调用如下。

- NtCreateKey
- NtCreateKeyTransacted
- NtOpenKey
- NtOpenKeyTransacted
- NtOpenKeyEx
- NtOpenKeyTransactedEx
- NtCreateFile
- NtOpenFile

## 实现原理

启用 SeBackupPrivilege 和 SeRestorePrivilege 是前提条件, 
但是你也需要在创建文件或注册表句柄的时候传入对应的选项, 否则是不生效的。

首先说明一点, 那就是 Windows 内核当发现调用者上下文为 SYSTEM 令牌的时候, 据 Microsoft 文档描述是为了提升 Windows 
的性能会自动忽略掉大部分访问检查, 毕竟很多 Windows 系统关键组件运行在 SYSTEM 令牌上下文下面, 对于 Windows 
用户模式而言, SYSTEM 令牌是至高无上的, 所以访问检查没必要做, 做了也提升不了安全性反而降低了效率。所以这也是为什么除了 
SYSTEM 令牌上下文外的其他令牌都需要启用相关特权 + 创建文件和注册表句柄的 API 传入对应选项才能忽略掉相关访问检查。

我用一个最简单的例子来说明减少不需要的内核级访问检查的好处, 那就是在 Windows AppContainer 下运行的代码, 
由于会多出一个额外的内核级访问检查 (用 IDA 分析 ntoskrnl.exe, 然后用 F5 查看相关函数可以发现, 
其实就是多出了一个分支和寥寥数行实现), 大概会比在 AppContainer 外运行会损失 15% 的性能
(这也可以说明越底层的实现越需要重视性能问题)。Windows AppContainer 是 Windows 8 开始提供的用户模式沙盒, 
主要用在商店应用和浏览器的沙盒上面。

Windows 的大部分内部使用了创建文件和注册表句柄的 API 并没有传入对应的选项, 
于是就出现了普通管理员下即使开启了这两个特权有些目录照样还是无法进行增删查改。
而通过 Inline Hook 对 Windows 用户模式的系统调用层进行挂钩以智能传入相关选项, 
这也是能在非 SYSTEM 的但拥有这两个特权的令牌上下文下绕过文件和注册表访问判断的缘由。

Windows 用户模式系统调用层指的是 ntdll.dll 导出的前缀为 Nt 或 Zw 的 API, 
Windows 用户模式下的 API 最终全会调用这部分以通过软中断陷阱门或者系统调用指令进入内核模式完成最终操作。

只有当前进程令牌上下文能够启用 SeBackupPrivilege 和 SeRestorePrivilege 的时候, 才能对相关系统调用传入对应选项。
毕竟如果这两个特权没有开启的话, 传入了相关选项是会返回错误的, 这也是为什么 Windows 相关实现并没有传入的原因。

## 参考实现

以下实现示例片段摘自 NSudo 恶魔模式。依赖于笔者创建的 https://github.com/Chuyu-Team/MINT 库提供的 NT API 定义，
并且也依赖于 Microsoft Detours 库。

完整实现请参阅 https://github.com/M2Team/NSudo/tree/f29331fad137c36c46066e21f2c14f23c1f6e175/Source/Native/NSudoDevilMode。

```
#include <MINT.h>
#include <stdint.h>
#include "detours.h"


namespace FunctionType
{
    enum
    {
        NtCreateKey,
        NtCreateKeyTransacted,
        NtOpenKey,
        NtOpenKeyTransacted,
        NtCreateFile,
        NtOpenFile,

        NtOpenKeyEx,
        NtOpenKeyTransactedEx,

        MaxFunctionType
    };
}

namespace
{
    HANDLE g_PrivilegedToken;

    PVOID g_OriginalAddress[FunctionType::MaxFunctionType];
    PVOID g_DetouredAddress[FunctionType::MaxFunctionType];
}


NTSTATUS NSudoDevilModeEnterPrivilegedContext(
    _Out_ PHANDLE OriginalTokenHandle)
{
    if (g_PrivilegedToken == INVALID_HANDLE_VALUE)
    {
        return STATUS_NOT_SUPPORTED;
    }

    if (!NT_SUCCESS(::NtOpenThreadToken(
        NtCurrentThread(),
        MAXIMUM_ALLOWED,
        TRUE,
        OriginalTokenHandle)))
    {
        *OriginalTokenHandle = nullptr;
    }

    return ::NtSetInformationThread(
        NtCurrentThread(),
        ThreadImpersonationToken,
        &g_PrivilegedToken,
        sizeof(HANDLE));
}

NTSTATUS NSudoDevilModeLeavePrivilegedContext(
    _Out_ HANDLE OriginalTokenHandle)
{
    NTSTATUS Status = ::NtSetInformationThread(
        NtCurrentThread(),
        ThreadImpersonationToken,
        &OriginalTokenHandle,
        sizeof(HANDLE));

    if (OriginalTokenHandle != nullptr &&
        OriginalTokenHandle != INVALID_HANDLE_VALUE)
    {
        ::NtClose(OriginalTokenHandle);
    }

    return Status;
}


NTSTATUS NTAPI OriginalNtCreateKey(
    _Out_ PHANDLE KeyHandle,
    _In_ ACCESS_MASK DesiredAccess,
    _In_ POBJECT_ATTRIBUTES ObjectAttributes,
    _Reserved_ ULONG TitleIndex,
    _In_opt_ PUNICODE_STRING Class,
    _In_ ULONG CreateOptions,
    _Out_opt_ PULONG Disposition)
{
    return reinterpret_cast<decltype(NtCreateKey)*>(
        g_OriginalAddress[FunctionType::NtCreateKey])(
            KeyHandle,
            DesiredAccess,
            ObjectAttributes,
            TitleIndex,
            Class,
            CreateOptions,
            Disposition);
}

NTSTATUS NTAPI DetouredNtCreateKey(
    _Out_ PHANDLE KeyHandle,
    _In_ ACCESS_MASK DesiredAccess,
    _In_ POBJECT_ATTRIBUTES ObjectAttributes,
    _Reserved_ ULONG TitleIndex,
    _In_opt_ PUNICODE_STRING Class,
    _In_ ULONG CreateOptions,
    _Out_opt_ PULONG Disposition)
{
    HANDLE OriginalTokenHandle = INVALID_HANDLE_VALUE;
    NTSTATUS ContextStatus = NSudoDevilModeEnterPrivilegedContext(
        &OriginalTokenHandle);
    if (NT_SUCCESS(ContextStatus))
    {
        CreateOptions |= REG_OPTION_BACKUP_RESTORE;
    }

    NTSTATUS Status = OriginalNtCreateKey(
        KeyHandle,
        DesiredAccess,
        ObjectAttributes,
        TitleIndex,
        Class,
        CreateOptions,
        Disposition);

    if (NT_SUCCESS(ContextStatus))
    {
        NSudoDevilModeLeavePrivilegedContext(OriginalTokenHandle);
    }

    return Status;
}


NTSTATUS NTAPI OriginalNtCreateKeyTransacted(
    _Out_ PHANDLE KeyHandle,
    _In_ ACCESS_MASK DesiredAccess,
    _In_ POBJECT_ATTRIBUTES ObjectAttributes,
    _Reserved_ ULONG TitleIndex,
    _In_opt_ PUNICODE_STRING Class,
    _In_ ULONG CreateOptions,
    _In_ HANDLE TransactionHandle,
    _Out_opt_ PULONG Disposition)
{
    return reinterpret_cast<decltype(NtCreateKeyTransacted)*>(
        g_OriginalAddress[FunctionType::NtCreateKeyTransacted])(
            KeyHandle,
            DesiredAccess,
            ObjectAttributes,
            TitleIndex,
            Class,
            CreateOptions,
            TransactionHandle,
            Disposition);
}

NTSTATUS NTAPI DetouredNtCreateKeyTransacted(
    _Out_ PHANDLE KeyHandle,
    _In_ ACCESS_MASK DesiredAccess,
    _In_ POBJECT_ATTRIBUTES ObjectAttributes,
    _Reserved_ ULONG TitleIndex,
    _In_opt_ PUNICODE_STRING Class,
    _In_ ULONG CreateOptions,
    _In_ HANDLE TransactionHandle,
    _Out_opt_ PULONG Disposition)
{
    HANDLE OriginalTokenHandle = INVALID_HANDLE_VALUE;
    NTSTATUS ContextStatus = NSudoDevilModeEnterPrivilegedContext(
        &OriginalTokenHandle);
    if (NT_SUCCESS(ContextStatus))
    {
        CreateOptions |= REG_OPTION_BACKUP_RESTORE;
    }

    NTSTATUS Status = OriginalNtCreateKeyTransacted(
        KeyHandle,
        DesiredAccess,
        ObjectAttributes,
        TitleIndex,
        Class,
        CreateOptions,
        TransactionHandle,
        Disposition);

    if (NT_SUCCESS(ContextStatus))
    {
        NSudoDevilModeLeavePrivilegedContext(OriginalTokenHandle);
    }

    return Status;
}


NTSTATUS NTAPI OriginalNtOpenKey(
    _Out_ PHANDLE KeyHandle,
    _In_ ACCESS_MASK DesiredAccess,
    _In_ POBJECT_ATTRIBUTES ObjectAttributes)
{
    return reinterpret_cast<decltype(NtOpenKey)*>(
        g_OriginalAddress[FunctionType::NtOpenKey])(
            KeyHandle,
            DesiredAccess,
            ObjectAttributes);
}

NTSTATUS NTAPI DetouredNtOpenKey(
    _Out_ PHANDLE KeyHandle,
    _In_ ACCESS_MASK DesiredAccess,
    _In_ POBJECT_ATTRIBUTES ObjectAttributes)
{
    ULONG Disposition = 0;

    NTSTATUS Status = DetouredNtCreateKey(
        KeyHandle,
        DesiredAccess,
        ObjectAttributes,
        0,
        nullptr,
        0,
        &Disposition);

    if (REG_CREATED_NEW_KEY == Disposition)
    {
        ::NtDeleteKey(*KeyHandle);

        ::NtClose(*KeyHandle);
        *KeyHandle = nullptr;

        Status = STATUS_OBJECT_NAME_NOT_FOUND;
    }

    return Status;
}


NTSTATUS NTAPI OriginalNtOpenKeyTransacted(
    _Out_ PHANDLE KeyHandle,
    _In_ ACCESS_MASK DesiredAccess,
    _In_ POBJECT_ATTRIBUTES ObjectAttributes,
    _In_ HANDLE TransactionHandle)
{
    return reinterpret_cast<decltype(NtOpenKeyTransacted)*>(
        g_OriginalAddress[FunctionType::NtOpenKeyTransacted])(
            KeyHandle,
            DesiredAccess,
            ObjectAttributes,
            TransactionHandle);
}

NTSTATUS NTAPI DetouredNtOpenKeyTransacted(
    _Out_ PHANDLE KeyHandle,
    _In_ ACCESS_MASK DesiredAccess,
    _In_ POBJECT_ATTRIBUTES ObjectAttributes,
    _In_ HANDLE TransactionHandle)
{
    ULONG Disposition = 0;

    NTSTATUS Status = DetouredNtCreateKeyTransacted(
        KeyHandle,
        DesiredAccess,
        ObjectAttributes,
        0,
        nullptr,
        0,
        TransactionHandle,
        &Disposition);

    if (REG_CREATED_NEW_KEY == Disposition)
    {
        ::NtDeleteKey(*KeyHandle);

        ::NtClose(*KeyHandle);
        *KeyHandle = nullptr;

        Status = STATUS_OBJECT_NAME_NOT_FOUND;
    }

    return Status;
}


NTSTATUS NTAPI OriginalNtOpenKeyEx(
    _Out_ PHANDLE KeyHandle,
    _In_ ACCESS_MASK DesiredAccess,
    _In_ POBJECT_ATTRIBUTES ObjectAttributes,
    _In_ ULONG OpenOptions)
{
    return reinterpret_cast<decltype(NtOpenKeyEx)*>(
        g_OriginalAddress[FunctionType::NtOpenKeyEx])(
            KeyHandle,
            DesiredAccess,
            ObjectAttributes,
            OpenOptions);
}

NTSTATUS NTAPI DetouredNtOpenKeyEx(
    _Out_ PHANDLE KeyHandle,
    _In_ ACCESS_MASK DesiredAccess,
    _In_ POBJECT_ATTRIBUTES ObjectAttributes,
    _In_ ULONG OpenOptions)
{
    HANDLE OriginalTokenHandle = INVALID_HANDLE_VALUE;
    NTSTATUS ContextStatus = NSudoDevilModeEnterPrivilegedContext(
        &OriginalTokenHandle);
    if (NT_SUCCESS(ContextStatus))
    {
        OpenOptions |= REG_OPTION_BACKUP_RESTORE;
    }

    NTSTATUS Status = OriginalNtOpenKeyEx(
        KeyHandle,
        DesiredAccess,
        ObjectAttributes,
        OpenOptions);

    if (NT_SUCCESS(ContextStatus))
    {
        NSudoDevilModeLeavePrivilegedContext(OriginalTokenHandle);
    }

    return Status;
}


NTSTATUS NTAPI OriginalNtOpenKeyTransactedEx(
    _Out_ PHANDLE KeyHandle,
    _In_ ACCESS_MASK DesiredAccess,
    _In_ POBJECT_ATTRIBUTES ObjectAttributes,
    _In_ ULONG OpenOptions,
    _In_ HANDLE TransactionHandle)
{
    return reinterpret_cast<decltype(NtOpenKeyTransactedEx)*>(
        g_OriginalAddress[FunctionType::NtOpenKeyTransactedEx])(
            KeyHandle,
            DesiredAccess,
            ObjectAttributes,
            OpenOptions,
            TransactionHandle);
}

NTSTATUS NTAPI DetouredNtOpenKeyTransactedEx(
    _Out_ PHANDLE KeyHandle,
    _In_ ACCESS_MASK DesiredAccess,
    _In_ POBJECT_ATTRIBUTES ObjectAttributes,
    _In_ ULONG OpenOptions,
    _In_ HANDLE TransactionHandle)
{
    HANDLE OriginalTokenHandle = INVALID_HANDLE_VALUE;
    NTSTATUS ContextStatus = NSudoDevilModeEnterPrivilegedContext(
        &OriginalTokenHandle);
    if (NT_SUCCESS(ContextStatus))
    {
        OpenOptions |= REG_OPTION_BACKUP_RESTORE;
    }

    NTSTATUS Status = OriginalNtOpenKeyTransactedEx(
        KeyHandle,
        DesiredAccess,
        ObjectAttributes,
        OpenOptions,
        TransactionHandle);

    if (NT_SUCCESS(ContextStatus))
    {
        NSudoDevilModeLeavePrivilegedContext(OriginalTokenHandle);
    }

    return Status;
}


NTSTATUS NTAPI OriginalNtCreateFile(
    _Out_ PHANDLE FileHandle,
    _In_ ACCESS_MASK DesiredAccess,
    _In_ POBJECT_ATTRIBUTES ObjectAttributes,
    _Out_ PIO_STATUS_BLOCK IoStatusBlock,
    _In_opt_ PLARGE_INTEGER AllocationSize,
    _In_ ULONG FileAttributes,
    _In_ ULONG ShareAccess,
    _In_ ULONG CreateDisposition,
    _In_ ULONG CreateOptions,
    _In_reads_bytes_opt_(EaLength) PVOID EaBuffer,
    _In_ ULONG EaLength)
{
    return reinterpret_cast<decltype(NtCreateFile)*>(
        g_OriginalAddress[FunctionType::NtCreateFile])(
            FileHandle,
            DesiredAccess,
            ObjectAttributes,
            IoStatusBlock,
            AllocationSize,
            FileAttributes,
            ShareAccess,
            CreateDisposition,
            CreateOptions,
            EaBuffer,
            EaLength);
}


NTSTATUS NTAPI DetouredNtCreateFile(
    _Out_ PHANDLE FileHandle,
    _In_ ACCESS_MASK DesiredAccess,
    _In_ POBJECT_ATTRIBUTES ObjectAttributes,
    _Out_ PIO_STATUS_BLOCK IoStatusBlock,
    _In_opt_ PLARGE_INTEGER AllocationSize,
    _In_ ULONG FileAttributes,
    _In_ ULONG ShareAccess,
    _In_ ULONG CreateDisposition,
    _In_ ULONG CreateOptions,
    _In_reads_bytes_opt_(EaLength) PVOID EaBuffer,
    _In_ ULONG EaLength)
{
    HANDLE OriginalTokenHandle = INVALID_HANDLE_VALUE;
    NTSTATUS ContextStatus = NSudoDevilModeEnterPrivilegedContext(
        &OriginalTokenHandle);
    if (NT_SUCCESS(ContextStatus))
    {
        CreateOptions |= FILE_OPEN_FOR_BACKUP_INTENT;
    }

    NTSTATUS Status = OriginalNtCreateFile(
        FileHandle,
        DesiredAccess,
        ObjectAttributes,
        IoStatusBlock,
        AllocationSize,
        FileAttributes,
        ShareAccess,
        CreateDisposition,
        CreateOptions,
        EaBuffer,
        EaLength);

    if (NT_SUCCESS(ContextStatus))
    {
        NSudoDevilModeLeavePrivilegedContext(OriginalTokenHandle);
    }

    return Status;
}


NTSTATUS NTAPI OriginalNtOpenFile(
    _Out_ PHANDLE FileHandle,
    _In_ ACCESS_MASK DesiredAccess,
    _In_ POBJECT_ATTRIBUTES ObjectAttributes,
    _Out_ PIO_STATUS_BLOCK IoStatusBlock,
    _In_ ULONG ShareAccess,
    _In_ ULONG OpenOptions)
{
    return reinterpret_cast<decltype(NtOpenFile)*>(
        g_OriginalAddress[FunctionType::NtOpenFile])(
            FileHandle,
            DesiredAccess,
            ObjectAttributes,
            IoStatusBlock,
            ShareAccess,
            OpenOptions);
}

NTSTATUS NTAPI DetouredNtOpenFile(
    _Out_ PHANDLE FileHandle,
    _In_ ACCESS_MASK DesiredAccess,
    _In_ POBJECT_ATTRIBUTES ObjectAttributes,
    _Out_ PIO_STATUS_BLOCK IoStatusBlock,
    _In_ ULONG ShareAccess,
    _In_ ULONG OpenOptions)
{
    HANDLE OriginalTokenHandle = INVALID_HANDLE_VALUE;
    NTSTATUS ContextStatus = NSudoDevilModeEnterPrivilegedContext(
        &OriginalTokenHandle);
    if (NT_SUCCESS(ContextStatus))
    {
        OpenOptions |= FILE_OPEN_FOR_BACKUP_INTENT;
    }

    NTSTATUS Status = OriginalNtOpenFile(
        FileHandle,
        DesiredAccess,
        ObjectAttributes,
        IoStatusBlock,
        ShareAccess,
        OpenOptions);

    if (NT_SUCCESS(ContextStatus))
    {
        NSudoDevilModeLeavePrivilegedContext(OriginalTokenHandle);
    }

    return Status;
}

/**
 * Initialize the NSudo Devil Mode.
 */
void NSudoDevilModeInitialize()
{
    NTSTATUS Status = STATUS_SUCCESS;
    HANDLE CurrentProcessToken = INVALID_HANDLE_VALUE;

    Status = ::NtOpenProcessToken(
        NtCurrentProcess(),
        MAXIMUM_ALLOWED,
        &CurrentProcessToken);
    if (NT_SUCCESS(Status))
    {
        SECURITY_QUALITY_OF_SERVICE SQOS;
        SQOS.Length = sizeof(SECURITY_QUALITY_OF_SERVICE);
        SQOS.ImpersonationLevel = SecurityImpersonation;
        SQOS.ContextTrackingMode = FALSE;
        SQOS.EffectiveOnly = FALSE;

        OBJECT_ATTRIBUTES OA;
        OA.Length = sizeof(OBJECT_ATTRIBUTES);
        OA.RootDirectory = nullptr;
        OA.ObjectName = nullptr;
        OA.Attributes = 0;
        OA.SecurityDescriptor = nullptr;
        OA.SecurityQualityOfService = &SQOS;

        Status = ::NtDuplicateToken(
            CurrentProcessToken,
            MAXIMUM_ALLOWED,
            &OA,
            FALSE,
            TokenImpersonation,
            &g_PrivilegedToken);

        ::NtClose(CurrentProcessToken);
    }

    if (NT_SUCCESS(Status))
    {
        uint8_t TPBlock[2 * sizeof(LUID_AND_ATTRIBUTES) + sizeof(DWORD)];
        PTOKEN_PRIVILEGES pTP = reinterpret_cast<PTOKEN_PRIVILEGES>(TPBlock);

        pTP->PrivilegeCount = 2;

        pTP->Privileges[0].Luid.LowPart = SE_BACKUP_PRIVILEGE;
        pTP->Privileges[0].Luid.HighPart = 0;
        pTP->Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;

        pTP->Privileges[1].Luid.LowPart = SE_RESTORE_PRIVILEGE;
        pTP->Privileges[1].Luid.HighPart = 0;
        pTP->Privileges[1].Attributes = SE_PRIVILEGE_ENABLED;

        Status = ::NtAdjustPrivilegesToken(
            g_PrivilegedToken,
            FALSE,
            pTP,
            sizeof(TPBlock),
            nullptr,
            nullptr);
        if (ERROR_SUCCESS != Status)
        {
            ::NtClose(g_PrivilegedToken);
            Status = STATUS_NOT_SUPPORTED;
        }
    }

    if (!NT_SUCCESS(Status))
    {
        g_PrivilegedToken = INVALID_HANDLE_VALUE;
    }

    g_OriginalAddress[FunctionType::NtCreateKey] =
        ::NtCreateKey;
    g_DetouredAddress[FunctionType::NtCreateKey] =
        ::DetouredNtCreateKey;

    g_OriginalAddress[FunctionType::NtCreateKeyTransacted] =
        ::NtCreateKeyTransacted;
    g_DetouredAddress[FunctionType::NtCreateKeyTransacted] =
        ::DetouredNtCreateKeyTransacted;

    g_OriginalAddress[FunctionType::NtOpenKey] =
        ::NtOpenKey;
    g_DetouredAddress[FunctionType::NtOpenKey] =
        ::DetouredNtOpenKey;

    g_OriginalAddress[FunctionType::NtOpenKeyTransacted] =
        ::NtOpenKeyTransacted;
    g_DetouredAddress[FunctionType::NtOpenKeyTransacted] =
        ::DetouredNtOpenKeyTransacted;

    g_OriginalAddress[FunctionType::NtCreateFile] =
        ::NtCreateFile;
    g_DetouredAddress[FunctionType::NtCreateFile] =
        ::DetouredNtCreateFile;

    g_OriginalAddress[FunctionType::NtOpenFile] =
        ::NtOpenFile;
    g_DetouredAddress[FunctionType::NtOpenFile] =
        ::DetouredNtOpenFile;

    UNICODE_STRING NtdllName;
    ::RtlInitUnicodeString(
        &NtdllName,
        const_cast<PWSTR>(L"ntdll.dll"));
    PVOID NtdllModuleHandle = nullptr;
    ::LdrGetDllHandleEx(
        0,
        nullptr,
        nullptr,
        &NtdllName,
        &NtdllModuleHandle);
    if (NtdllModuleHandle)
    {
        ANSI_STRING FunctionName;

        ::RtlInitAnsiString(
            &FunctionName,
            const_cast<PSTR>("NtOpenKeyEx"));
        ::LdrGetProcedureAddress(
            NtdllModuleHandle,
            &FunctionName,
            0,
            &g_OriginalAddress[FunctionType::NtOpenKeyEx]);
        g_DetouredAddress[FunctionType::NtOpenKeyEx] =
            ::DetouredNtOpenKeyEx;

        ::RtlInitAnsiString(
            &FunctionName,
            const_cast<PSTR>("NtOpenKeyTransactedEx"));
        ::LdrGetProcedureAddress(
            NtdllModuleHandle,
            &FunctionName,
            0,
            &g_OriginalAddress[FunctionType::NtOpenKeyTransactedEx]);
        g_DetouredAddress[FunctionType::NtOpenKeyTransactedEx] =
            ::DetouredNtOpenKeyTransactedEx;

    }
}

/**
 * Uninitialize the NSudo Devil Mode.
 */
void NSudoDevilModeUninitialize()
{
    if (g_PrivilegedToken != INVALID_HANDLE_VALUE)
    {
        ::NtClose(g_PrivilegedToken);
    }
}

BOOL APIENTRY DllMain(
    HMODULE Module,
    DWORD  Reason,
    LPVOID Reserved)
{
    UNREFERENCED_PARAMETER(Module);
    UNREFERENCED_PARAMETER(Reserved);

    if (DLL_PROCESS_ATTACH == Reason || DLL_PROCESS_DETACH == Reason)
    {
        if (DLL_PROCESS_ATTACH == Reason)
        {
            NSudoDevilModeInitialize();
        }

        DetourTransactionBegin();
        DetourUpdateThread(NtCurrentThread());

        for (size_t i = 0; i < FunctionType::MaxFunctionType; ++i)
        {
            if (g_OriginalAddress[i])
            {
                if (DLL_PROCESS_ATTACH == Reason)
                {
                    DetourAttach(
                        &g_OriginalAddress[i],
                        g_DetouredAddress[i]);
                }
                else if (DLL_PROCESS_DETACH == Reason)
                {
                    DetourDetach(
                        &g_OriginalAddress[i],
                        g_DetouredAddress[i]);
                }
            }
        }

        DetourTransactionCommit();

        if (DLL_PROCESS_DETACH == Reason)
        {
            NSudoDevilModeUninitialize();
        }
    }

    return TRUE;
}
```

## 参考资料

- [NSudo 恶魔模式 - 一个面向希望无视文件和注册表访问检查的开发者的解决方案](https://bbs.pediy.com/thread-257345.htm)

## 相关内容

{% post_link Windows-Research-Notes %}
