---
title: 在早期版本的 Windows 10 中实现 Per-Monitor DPI Awareness 模式支持的注意事项
date: 2021-11-05 11:05:02
categories:
- [技术, Windows, Windows 研究笔记, 用户模式]
tags:
- 技术
- Windows
- Windows 研究笔记
- 用户模式
---

笔者于{% post_link Enable-Per-Monitor-DPI-Awareness-Mode-for-File-Explorer-in-Windows-10 %}中提到微软在 Windows 8.1 
时期引入的 Per-Monitor DPI Awareness 模式不支持非客户区缩放。如果要做完整的 Per-Monitor DPI Awareness 模式适配，
那就需要对非客户区的内容进行完整自绘，作为负责任的开发者还要实现无障碍等特性，在这些要求的束缚下，
只有头铁的人才会去实现相关支持，于是我相当能理解当时为啥 Windows 桌面应用对高 DPI 支持不好。

然而 Windows 10 从第一个版本即 Windows 10, Version 1507 开始，修改了 DPI 缩放比例是不需要注销的，于是没有完整适配
Per-Monitor DPI Awareness 模式的应用体验在这种情况下会非常糟糕，而当时的 Windows 10 也没有引入 Program DPI 特性，
于是并没有办法通过重启仅支持 System DPI Awareness 模式的应用解决在主显示器上的模糊问题。

然而 Windows 10, Version 1507 和 Windows 10, Version 1511 的用户界面中的一些对话框在修改了 DPI 
缩放比例后不仅客户区可以正确缩放，非客户区也能正确缩放，而且不需要注销，这让我非常好奇。

经过对 Windows 10 的控制台宿主的分析，我发现了两个非公开的 Windows API 可以让系统自动帮你缩放非客户区和对话框。
由于这两个 API 在 Windows 10, Version 1607 已经无法使用，所以调用之前需要做好对 Windows 版本的判断。由于从 
Windows 10, Version 1607 引入的从 Windows 10, Version 1703 开始正式支持的 Per-Monitor (V2) DPI Awareness 模式，
相对于 Windows 8.1 时期引入的 Per-Monitor DPI Awareness 模式而言支持对非客户区进行自动缩放，所以适当使用本文的技巧，
可以让你的应用在 Windows 10 全系列版本下完整支持 Per-Monitor DPI Awareness 模式。

你也许会问 Windows 8.1 的情况，虽然 Windows 8.1 下并没有找到类似的 API，但是 Windows 8.1 下修改 DPI 
缩放后需要注销才会生效，而且如果有多个 DPI 不同的显示器的用户大概率早就升级 Windows 10 及之后版本，
于是并不需要太过担心 Windows 8.1 下的问题。

## 让 Windows 自动帮你缩放对话框的技巧

在 Windows 10, Version 1507 和 Windows 10, Version 1511 的 `user32.dll"` 引入了一个叫 `EnablePerMonitorDialogScaling` 
通过序数 2577 调用的非公开 API，你只需要在调用 API 显示对话框之前调用该非公开 API 即可。

为了方便使用，我将其包装成了一个函数，你可以直接以 `EnablePerMonitorDialogScaling()` 的方式调用，代码如下：

```
#include <Windows.h>
#include <VersionHelpers.h>

INT EnablePerMonitorDialogScaling()
{
    // This hack is only for Windows 10 only.
    if (!::IsWindowsVersionOrGreater(10, 0, 0))
    {
        return -1;
    }

    // We don't need this hack if the Per Monitor Aware V2 is existed.
    OSVERSIONINFOEXW OSVersionInfoEx = { 0 };
    OSVersionInfoEx.dwOSVersionInfoSize = sizeof(OSVERSIONINFOEXW);
    OSVersionInfoEx.dwBuildNumber = 14393;
    if (::VerifyVersionInfoW(
        &OSVersionInfoEx,
        VER_BUILDNUMBER,
        ::VerSetConditionMask(0, VER_BUILDNUMBER, VER_GREATER_EQUAL)))
    {
        return -1;
    }

    HMODULE ModuleHandle = ::GetModuleHandleW(L"user32.dll");
    if (!ModuleHandle)
    {
        return -1;
    }

    typedef INT(WINAPI* ProcType)();

    ProcType ProcAddress = reinterpret_cast<ProcType>(
        ::GetProcAddress(ModuleHandle, reinterpret_cast<LPCSTR>(2577)));
    if (!ProcAddress)
    {
        return -1;
    }

    return ProcAddress();
}
```

## 让 Windows 自动帮你缩放非客户区的技巧

在 Windows 10, Version 1507 和 Windows 10, Version 1511 的 `user32.dll"` 引入了一个叫 `EnableChildWindowDpiMessage` 
的非公开 API，你只需要在调用 API 创建窗口后调用该非公开 API 即可。

为了方便使用，我将其包装成了一个函数，你可以直接以 `EnableChildWindowDpiMessage(窗口句柄)` 的方式调用，代码如下：

```
#include <Windows.h>
#include <VersionHelpers.h>

BOOL EnableChildWindowDpiMessage(
    _In_ HWND WindowHandle)
{
    // This hack is only for Windows 10 only.
    if (!::IsWindowsVersionOrGreater(10, 0, 0))
    {
        return FALSE;
    }

    // We don't need this hack if the Per Monitor Aware V2 is existed.
    OSVERSIONINFOEXW OSVersionInfoEx = { 0 };
    OSVersionInfoEx.dwOSVersionInfoSize = sizeof(OSVERSIONINFOEXW);
    OSVersionInfoEx.dwBuildNumber = 14393;
    if (::VerifyVersionInfoW(
        &OSVersionInfoEx,
        VER_BUILDNUMBER,
        ::VerSetConditionMask(0, VER_BUILDNUMBER, VER_GREATER_EQUAL)))
    {
        return FALSE;
    }

    HMODULE ModuleHandle = ::GetModuleHandleW(L"user32.dll");
    if (!ModuleHandle)
    {
        return FALSE;
    }

    typedef BOOL(WINAPI* ProcType)(HWND, BOOL);

    ProcType ProcAddress = reinterpret_cast<ProcType>(
        ::GetProcAddress(ModuleHandle, "EnableChildWindowDpiMessage"));
    if (!ProcAddress)
    {
        return FALSE;
    }

    return ProcAddress(WindowHandle, TRUE);
}
```

## 参考文献

- https://blog.walterlv.com/post/windows-high-dpi-development.html
- https://www.windowscentral.com/how-change-high-dpi-settings-classic-apps-windows-10-april-2018-update

## 相关内容

{% post_link Windows-Research-Notes %}
