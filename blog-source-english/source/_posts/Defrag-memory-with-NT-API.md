---
title: Defrag memory with NT API
date: 2021-11-14 04:03:41
categories:
- [Technologies, Windows, Windows Research Notes, User Mode]
tags:
- Technologies
- Windows
- Windows Research Notes
- User Mode
---

The memory fragmentation is inevitable when the system is running, this can affect the system performance, so it is 
necessary to defrag the memory at the proper time.

Most of the memory defragmentation tools on the market today achieve the goal through allocating as many memory blocks
as possible from the system to squeeze as many memory blocks as possible into the swap file before releasing them. I do
not think this is an elegant approach, because it requires that your tool must be running in Native mode instead of the
WoW compatibility layer, for example, if your tool is 32-bit it can only request up to 4GB of memory from the system, 
which is not enough to achieve your goal. And since you are forcing the system to squeeze memory blocks into the swap 
file, it is not efficient and has a significant negative impact on the scheduling mechanism.

So, this article proposes a new way of memory defragmentation by calling the NT API to inform the kernel to move the 
memory blocks to the swap file automatically, so the process is very fast and has minimal impact on the scheduling 
mechanism.

Read [here](https://mourinaruto.github.io/zh/2021/11/14/Defrag-memory-with-NT-API/) for the Chinese version of 
this article if you are not good at English. (Translation: 如果你不擅长英文，可以点击本段话中的链接阅读中文版)

## Inspiration source

When I used the features in the Empty menu from RAMMap tool in Sysinternals Suite, I found we can defrag memory 
efficiently with the proper operations.

So I used IDA Pro to analyze the features related to the RAMMap tool, and summarize my conclusions and write this
article with examples.

## Operation method

You need to run your binary as administrator.

First enable the SeProfileSingleProcessPrivilege privilege for the current process, then call NtSetSystemInformation
and pass MemoryEmptyWorkingSets, MemoryFlushModifiedList and MemoryPurgeStandbyList to SystemMemoryListInformation to
perform memory defragmentation.

## Code example

The following example rely on the NT API definitions from https://github.com/Chuyu-Team/MINT created by myself.

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

## See also

{% post_link Windows-Research-Notes %}
