---
title: Modernize Win32 Message Box with Task Dialog
date: 2021-12-31 21:56:37
categories:
- [Technologies, Windows, Windows Apps, Development, Experience]
tags:
- Technologies
- Windows
- Windows Apps
- Development
- Experience
---

When I was developing [NanaZip](https://github.com/M2Team/NanaZip), I plan to modernize the implementation of Self
Extracting Executables. Because Self Extracting Executables need to support older version of Windows, I plan to use 
[Task Dialog](https://docs.microsoft.com/en-us/windows/win32/controls/task-dialogs?WT.mc_id=WDIT-MVP-5004706) to 
achieve the goal.

But I also think that I can use the same way from [YY-Thunks](https://github.com/Chuyu-Team/YY-Thunks), to make a 
wrapper for modernizing Win32 Message Box with Task Dialog for the existing Win32 apps without huge source code
modification.

YY-Thunks uses the MSVC specific features to hack the specified IAT item of the target binary for redirecting to the 
needed fallback implementation. I think it's an elegant way to modernize the existing projects.

I just made a simple implementation and provide in this article and hope it can be some help for developers.

## Implementation

```
#include <CommCtrl.h>
#pragma comment(lib,"comctl32.lib")

EXTERN_C int WINAPI ModernMessageBoxW(
    _In_opt_ HWND hWnd,
    _In_opt_ LPCWSTR lpText,
    _In_opt_ LPCWSTR lpCaption,
    _In_ UINT uType)
{
    if (uType != (uType & (MB_ICONMASK | MB_TYPEMASK)))
    {
        return ::MessageBoxW(hWnd, lpText, lpCaption, uType);
    }

    TASKDIALOGCONFIG TaskDialogConfig = { 0 };

    TaskDialogConfig.cbSize = sizeof(TASKDIALOGCONFIG);
    TaskDialogConfig.hwndParent = hWnd;
    TaskDialogConfig.dwFlags = TDF_ALLOW_DIALOG_CANCELLATION;
    TaskDialogConfig.pszWindowTitle = lpCaption;
    TaskDialogConfig.pszMainInstruction = lpText;

    switch (uType & MB_TYPEMASK)
    {
    case MB_OK:
        TaskDialogConfig.dwCommonButtons =
            TDCBF_OK_BUTTON;
        break;
    case MB_OKCANCEL:
        TaskDialogConfig.dwCommonButtons =
            TDCBF_OK_BUTTON | TDCBF_CANCEL_BUTTON;
        break;
    case MB_YESNOCANCEL:
        TaskDialogConfig.dwCommonButtons =
            TDCBF_YES_BUTTON | TDCBF_NO_BUTTON | TDCBF_CANCEL_BUTTON;
        break;
    case MB_YESNO:
        TaskDialogConfig.dwCommonButtons =
            TDCBF_YES_BUTTON | TDCBF_NO_BUTTON;
        break;
    case MB_RETRYCANCEL:
        TaskDialogConfig.dwCommonButtons =
            TDCBF_RETRY_BUTTON | TDCBF_CANCEL_BUTTON;
        break;
    default:
        return ::MessageBoxW(hWnd, lpText, lpCaption, uType);
    }

    switch (uType & MB_ICONMASK)
    {
    case MB_ICONHAND:
        TaskDialogConfig.pszMainIcon = TD_ERROR_ICON;
        break;
    case MB_ICONQUESTION:
        TaskDialogConfig.dwFlags |= TDF_USE_HICON_MAIN;
        TaskDialogConfig.hMainIcon = ::LoadIconW(nullptr, IDI_QUESTION);
        break;
    case MB_ICONEXCLAMATION:
        TaskDialogConfig.pszMainIcon = TD_WARNING_ICON;
        break;
    case MB_ICONASTERISK:
        TaskDialogConfig.pszMainIcon = TD_INFORMATION_ICON;
        break;
    default:
        break;
    }

    int ButtonID = 0;

    HRESULT hr = ::TaskDialogIndirect(
        &TaskDialogConfig,
        &ButtonID,
        nullptr,
        nullptr);

    if (ButtonID == 0)
    {
        ::SetLastError(hr);
    }

    return ButtonID;
}

#if defined(_M_IX86)
#pragma warning(suppress:4483)
extern "C" __declspec(selectany) void const* const __identifier("_imp__MessageBoxW@16") = reinterpret_cast<void const*>(::ModernMessageBoxW);
#else
extern "C" __declspec(selectany) void const* const __imp_MessageBoxW = reinterpret_cast<void const*>(::ModernMessageBoxW);
#endif
```
