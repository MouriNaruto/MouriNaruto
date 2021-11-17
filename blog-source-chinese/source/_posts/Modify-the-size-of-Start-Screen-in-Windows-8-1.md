---
title: 在 Windows 8.1 中修改开始屏幕的大小
date: 2021-11-03 13:40:30
categories:
- [技术, Windows, Windows 研究笔记, 用户模式]
tags:
- 技术
- Windows
- Windows 研究笔记
- 用户模式
---

当年有个叫 Start Charming 的工具可使得 Windows 8 的开始屏幕变成非全屏幕显示，我对其的实现相当感兴趣，
于是拿起熟悉的 IDA Pro, ILSpy 和 Spy++ 稍微进行了一些探索，然后发现了相关原理并在远景论坛发了个贴，
当年的远景论坛其实还是很有技术力的，于是我和一个叫 KeBugCheckEx 景友又进行了一些深入的讨论，
当时的我感觉受益匪浅，于是我打算把当时讨论的内容稍微整理一下，于是就有了这篇文章。

## 修改 Windows 8.1 中修改开始屏幕的大小的技巧

由于 Windows 8.1 的开始屏幕对应的 Win32 窗口类名为 `ImmersiveLauncher`，于是我们可以使用 FindWindow API
通过窗口类名获取窗口句柄，然后就可以使用 MoveWindow 或者 SetWindowPos 之类的 API 去修改 Windows 8.1
的开始屏幕的显示位置，于是就可以顺理成章地达成本文的目的。

```
using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.Drawing;

namespace StartScreenToStartMenu
{
    class Program
    {
        [DllImport("user32.dll")]
        public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

        [DllImport("user32.dll", EntryPoint = "MoveWindow")]
        public static extern int MoveWindow(IntPtr hwnd, int x, int y, int nWidth, int nHeight, bool bRepaint);

        static void Main(string[] args)
        {
            Rectangle rect = Screen.PrimaryScreen.Bounds;

            IntPtr childHwnd = FindWindow("ImmersiveLauncher", null);  
            if (childHwnd != IntPtr.Zero)
            {
                int Width = 1024; // 自定义开始屏幕的宽度
                int Height = 768; // 自定义开始屏幕的高度
                MoveWindow(childHwnd, 0, rect.Height - Height - 40, Width, Height, true);
                //MoveWindow(childHwnd, 0, 0, rect.Width, rect.Height, true);  // 如果想恢复原样的话把这行代码复制到上一行就OK了
            }
            else
            {
                Console.WriteLine("没有找到窗口");
            }
        }
    }
}
```

![效果图](Screenshot1.png)

## 在桌面上直接显示 Metro App 的技巧

KeBugCheckEx 表示将承载 Metro App 的窗口中的窗口类名为 `ImmersiveBackgroundWindow` 的背景窗口用 CloseWindow 
或者 DestroyWindow 之类的 API 关掉即可。当然仅是这样做的话很明显无法日常使用，如果要想开发出可以日常使用的软件，
将承载 Metro App 的窗口当作子窗口塞入到自己的窗口中去应该是一种可行的方案。

```
#include <Windows.h>

int _tmain(int argc, _TCHAR* argv[])
{
        while (true)
        {
                HWND hWnd = FindWindow(L"Windows.UI.Core.CoreWindow", NULL);
                if (hWnd != NULL)
                {
                        MoveWindow(hWnd, 0, 0, 800, 600, TRUE);
                }
                hWnd = FindWindow(L"ImmersiveBackgroundWindow", NULL);
                if (hWnd != NULL)
                {
                        CloseWindow(hWnd);
                }
                Sleep(50);
        }
        return 0;
}
```

![效果图](Screenshot2.jpg)

## 参考文献

- [自定义开始屏幕的大小](http://bbs.pcbeta.com/viewthread-1524688-1-1.html)

## 相关内容

{% post_link Windows-Research-Notes %}
