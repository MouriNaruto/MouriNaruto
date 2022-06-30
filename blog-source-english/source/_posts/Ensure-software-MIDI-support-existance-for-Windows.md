---
title: Ensure software MIDI support existance for Windows
date: 2022-06-30 16:42:46
categories:
- [Technologies, Windows, Windows Apps, Development, Experience]
tags:
- Technologies
- Windows
- Windows Apps
- Development
- Experience
---

When I am using Hyper-V Gen2 VM, I found I can't play MIDI.

I did some investigation and found the solution.

Windows 10 Version 1903 and later have fixed that issue. So, it's not necessary to use this.

## Solution

Save the following content to a `.reg` file and double click it to import.

```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Drivers32]
"aux"="wdmaud.drv"
"midi"="wdmaud.drv"
"mixer"="wdmaud.drv"
"wave"="wdmaud.drv"

[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Drivers32]
"aux"="wdmaud.drv"
"midi"="wdmaud.drv"
"mixer"="wdmaud.drv"
"wave"="wdmaud.drv"

```
