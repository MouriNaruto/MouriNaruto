---
title: 使用 NT API 整理内存碎片
date: 2021-11-14 04:03:41
categories:
- [技术, Windows, Windows 研究笔记, 用户模式]
tags:
- 技术
- Windows
- Windows 研究笔记
- 用户模式
---

在系统运行过程中，内存中不可避免地会产生一些内存碎片，这会影响系统的执行效率，因此适时整理内存碎片是有必要的。

现在市面上大部分的内存碎片整理工具通过尽可能让系统分配内存块把尽可能多的内存块挤入交换文件然后再释放以达成目的。
我感觉这个方法不够优雅，毕竟这要求你的内存碎片整理工具一定运行在 Native 模式而不是 WoW 兼容层中，譬如如果你的工具是
32 位的话最多只能向系统请求 4GB 的内存，无法达到你的目的。而且由于是被迫让系统把内存块挤入交换文件，于是运行效率不高，
而且也给系统调度机制带来了很大的影响。

于是本文提出一种新的内存碎片整理方式，通过调用 NT API 通知内核主动将内存块移动到交换文件，于是整理速度非常快，
而且对系统调度机制的影响也最小。

如果你不擅长中文，可以[点此](https://mouri.moe/en/2021/11/14/Defrag-memory-with-NT-API/)阅读英文版。
(翻译: If you are not good at Chinese, you can click on the link in this paragraph to read the English version.)

## 灵感来源

当我使用 Sysinternals Suite 的 RAMMap 工具的 Empty 菜单的功能的时候，发现通过适当的顺序操作可以高效地整理内存碎片。

于是用 IDA Pro 分析了下 RAMMap 工具的相关功能，并对自己的发现进行总结，编写示例和本文。

## 操作方法

需要以管理员身份运行你的二进制。

首先启用当前进程的 SeProfileSingleProcessPrivilege 特权，然后调用 NtSetSystemInformation，分别向 
SystemMemoryListInformation 传入 MemoryEmptyWorkingSets, MemoryFlushModifiedList 和 MemoryPurgeStandbyList 
即可完成内存碎片整理。

## 代码示例

以下示例依赖于笔者创建的 https://github.com/Chuyu-Team/MINT 库提供的 NT API 定义。

```
#include <MINT.h>

namespace
{
    static HRESULT DefragMemory()
    {
        using NtSetSystemInformationType = decltype(::NtSetSystemInformation)*;
        using RtlNtStatusToDosErrorType = decltype(::RtlNtStatusToDosError)*;

        NtSetSystemInformationType pNtSetSystemInformation = nullptr;
        RtlNtStatusToDosErrorType pRtlNtStatusToDosError = nullptr;

        HMODULE ModuleHandle = ::GetModuleHandleW(L"ntdll.dll");
        if (!ModuleHandle)
        {
            return E_NOINTERFACE;
        }

        pNtSetSystemInformation = reinterpret_cast<NtSetSystemInformationType>(
            ::GetProcAddress(ModuleHandle, "NtSetSystemInformation"));
        if (!pNtSetSystemInformation)
        {
            return E_NOINTERFACE;
        }

        pRtlNtStatusToDosError = reinterpret_cast<RtlNtStatusToDosErrorType>(
            ::GetProcAddress(ModuleHandle, "RtlNtStatusToDosError"));
        if (!pRtlNtStatusToDosError)
        {
            return E_NOINTERFACE;
        }

        // Working Sets -> Modified Page List -> Standby List

        SYSTEM_MEMORY_LIST_COMMAND CommandList[] =
        {
            SYSTEM_MEMORY_LIST_COMMAND::MemoryEmptyWorkingSets,
            SYSTEM_MEMORY_LIST_COMMAND::MemoryFlushModifiedList,
            SYSTEM_MEMORY_LIST_COMMAND::MemoryPurgeStandbyList
        };

        NTSTATUS Status = STATUS_SUCCESS;

        for (size_t i = 0; i < sizeof(CommandList) / sizeof(*CommandList); ++i)
        {
            Status = pNtSetSystemInformation(
                SystemMemoryListInformation,
                &CommandList[i],
                sizeof(SYSTEM_MEMORY_LIST_COMMAND));
            if (!NT_SUCCESS(Status))
            {
                break;
            }
        }

        return Mile::HResult::FromWin32(pRtlNtStatusToDosError(Status));
    }
}

EXTERN_C HRESULT WINAPI MoDefragMemory(
    _In_ PNSUDO_CONTEXT Context)
{
    Mile::HResult hr = S_OK;
    HANDLE CurrentProcessToken = INVALID_HANDLE_VALUE;

    if (::OpenProcessToken(
        ::GetCurrentProcess(),
        MAXIMUM_ALLOWED,
        &CurrentProcessToken))
    {
        LUID_AND_ATTRIBUTES RawPrivilege;
        RawPrivilege.Attributes = SE_PRIVILEGE_ENABLED;
        if (::LookupPrivilegeValueW(
            nullptr,
            SE_PROF_SINGLE_PROCESS_NAME,
            &RawPrivilege.Luid))
        {
            hr = Mile::AdjustTokenPrivilegesSimple(
                CurrentProcessToken,
                &RawPrivilege,
                1);
            if (hr.IsSucceeded())
            {
                hr = ::DefragMemory();
            }
        }

        ::CloseHandle(CurrentProcessToken);
    }

    return hr;
}

```

## 相关内容

{% post_link Windows-Research-Notes %}
