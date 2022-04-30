---
title: 分享一个通过句柄值关闭关闭特定窗口的简单命令行工具实现
date: 2022-04-30 23:10:12
categories:
- [技术, Windows, Windows 应用, 开发, 体验]
tags:
- 技术
- Windows
- Windows 应用
- 开发
- 体验
---

在过去的一个月，我在研究 Windows 11 系统自带的已经通过 XAML Islands 现代化后的应用的自定义标题栏的实现。为了更加清晰的
了解其实现原理，于是需要关掉待研究应用的一些子窗口。然而暂时没有发现现成的工具，于是自己随便写了一个并分享出来，希望能
够帮助到一部分读者。

## 实现

```
#include <windows.h>
#include <stdio.h>

#pragma comment(lib, "User32.lib")

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow){
    HWND hWnd;

    if(!sscanf(lpCmdLine, "%i", (int*)&hWnd)){
        MessageBox(NULL, "Invalid argument", "Close Window", MB_OK | MB_ICONERROR);
        return 1;
    }

    PostMessage(hWnd, WM_CLOSE, 0, 0);
}
```

将上面这段代码保存成 `close.c`，在 Visual Studio 命令提示符下转到 `close.c` 的目录后执行 `cl close.c` 即可获得二进制。

## 用法

通过 Spy++ 获取窗口句柄值，然后命令提示符下执行 `close 窗口句柄值` 即可。

当然窗口句柄值如果是 16 进制的话，需要拥有 0x 前缀。

## 结尾

总之，希望能有人因此能够得到帮助，感谢阅读。
