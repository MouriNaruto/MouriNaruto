---
title: Windows 8 及之后版本的系统还原的新行为
date: 2021-11-02 13:20:48
categories:
- [技术, Windows, Windows 研究笔记, 系统还原]
tags:
- 技术
- Windows
- Windows 研究笔记
- 系统还原
---

从 Windows 8 开始，微软对系统还原的行为进行了变更。

## 系统还原点最小创建时间间隔

从 Windows 8 开始，系统还原点默认最小创建间隔为 24 小时。
即在创建一个新的系统还原点 24 小时以内试图再创建新的系统还原点则会被跳过。

我们可以在 `HKLM\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore` 注册表键下创建值为 N 
(单位分钟) 名为 `SystemRestorePointCreationFrequency` 的 DWORD 值来指定系统还原点的最小创建时间间隔。

## 仅监控启动卷上的文件变更

从 Windows 8 开始，系统还原仅监控启动卷上系统还原所需要捕获的文件变更。
Windows 8 之后版本在其 Windows 启动卷创建的系统还原点如果被早期版本的 Windows 检测到可能会被其删除。

我们可以在 `HKLM\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore` 注册表键下创建值为 0 
名为 `ScopeSnapshots` 的 DWORD 值以使系统还原将以早期版本 Windows 的方式在启动卷上创建快照。

如果希望继续使用新行为，则删除该注册表键即可。

## 原文勘误

当年在 https://bbs.pcbeta.com/forum.php?mod=viewthread&tid=1507617&page=1#pid40120249 
中我写的下述内容其实是有误的。


```
如果你的电脑是多系统并且其中一个是 Windows XP 的话，为了解决 NT6 系统还原点和NT5的不兼容问题；
在 Windows 8 以后，可以这样操作使系统可以在启动卷上创建和 Windows XP 风格的还原点。

在注册表 HKLM\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore 下面创建一个名为
ScopeSnapshots 的 DWORD 值。如果这个值为 0，系统还原将以早期版本的 Windows 的方式在启动卷上创建快照。
如果这个值被删除，则系统还原会按照 Windows 8 的方式创建系统还原点。
```

当时我的理解是修改了 `ScopeSnapshots` 以后，在 Windows 8 之后的 Windows 会使用 Windows XP 
或者 Windows Server 2003 的方式创建系统还原点，但实际上应该是以 Windows Vista 和 Windows 7 
及其对应的服务器版本的方式创建系统还原点。

其实在最近几年我对系统还原实现进行逆向的时候，Windows Vista 之后的系统还原实现已经完全基于卷影复制实现。
Windows 8 之后的系统还原实现也没有任何与 Windows XP 或者 Windows Server 2003 的系统还原有关的兼容逻辑。
毕竟 Windows Vista 之前的系统还原是基于微软自己写的过滤驱动实现的，而 Windows Vista 以后早已没有该过滤驱动的相关痕迹。

## 参考资料

- https://docs.microsoft.com/en-us/windows/win32/sr/calling-srsetrestorepoint?redirectedfrom=MSDN

## 相关内容

{% post_link Windows-Research-Notes %}
