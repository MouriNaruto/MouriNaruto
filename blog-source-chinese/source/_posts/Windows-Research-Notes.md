---
title: Windows 研究笔记
date: 2021-11-02 12:27:12
categories:
- [技术, Windows, Windows 研究笔记]
tags:
- 技术
- Windows
- Windows 研究笔记
---

## 前言

大家好，我是毛利。

我很喜欢撰写技术文章，尤其喜欢去远景论坛发表长篇技术贴，
因为我觉得在很多人去的论坛发表文章可以让更多的人看到，使更多的人因为我写的技术文章得到帮助。

大概在 2014 到 2016 年，是我的高产期。
后来我不怎么发布技术文章了，比较那时的我没有灵感写长篇技术文章。
但那时的自己又没有勇气发布短篇技术文章，因为担心其他人说我在论坛水贴。

众所周知，前几年远景论坛的服务器非常不稳定，动不动就无法访问。
于是那时的我萌生了把自己在远景等论坛发表的文章都归纳到自己在 GitHub 托管的博客里面。
毕竟论坛不可能永远存在，但是 Git 仓库每个人都能做备份，能让我写的内容流传下去。

后来远景论坛恢复正常后，我忘记了这件事。
直到最近因为一些契机，且在友人 walterlv 的鼓励下，使得我下定决心这么做。

我并不会单纯的归档之前撰写的技术文章，而是会根据之前的内容以我现在的视角去对内容进行勘误和重写。
希望借此能够减少潜在的理解错误的地方，能够更好的帮助看到我这一系列文章的读者。

如果发现了本系列文章中的错误内容，或者有更好的建议，请直接在
https://github.com/MouriNaruto/MouriNaruto/issues 反馈。

注：本索引会随着本系列内容的更新而更新。

注：目录中无超链接的文章条目即我未来想写的内容。

## 目录

- Windows 系统还原
  - {% post_link New-behavior-of-System-Restore-since-Windows-8 %}
  - 系统还原基本介绍
  - 通过命令行使用系统还原
  - 通过程序语言使用系统还原
  - 系统还原点存储结构分析
  - 系统还原的未文档化 Win32 API
  - 使用 Win32 API 创建系统还原点的注意事项
  - 使用 Win32 API 清空系统还原点的注意事项
- Compact OS
  - {% post_link The-history-and-principle-of-Compact-OS %}
  - {% post_link The-exclusion-list-of-Compact-OS %}
  - {% post_link The-usage-of-Compact-OS %}
- App Container
  - App Container 基本介绍
  - 通过 Win32 API 使用 App Container
  - 通过第三方工具使用 App Container
  - 通过 NT API 创建 App Container 访问令牌及注意事项
  - Windows 10 及之后版本的 App Container 行为变更
- Windows 内置的 C 运行时库
  - {% post_link Use-VC-LTL-in-your-Rust-projects %}
  - Windows 内置的 C 运行时库的历史沿革
  - 通过 VC-LTL 使用 Windows 内置的 C 运行时库
  - 在传统 UWP 中使用 VC-LTL
- Windows 用户模式 (Win32 API, NT API)
  - {% post_link Enable-Per-Monitor-DPI-Awareness-Mode-for-File-Explorer-in-Windows-10 %}
  - {% post_link Modify-the-size-of-Start-Screen-in-Windows-8-1 %}
  - {% post_link Notes-for-implement-Per-Monitor-DPI-Awareness-Mode-support-in-earlier-versions-of-Windows-10 %}
  - {% post_link Launch-Windows-Store-App-via-Win32-API %}
  - 充分利用管理员权限的技巧
- Windows Runtime
  - 通过 Windows Runtime API 实现对商店应用的升级
  - Windows 应用程序打包项目的已知问题和解决方案
  - 使用 C++/WinRT 实现一个轻量级 XAML Island 应用
- Windows Subsystem for Linux
  - {% post_link Control-the-memory-usage-of-WSL-2-instance %}
  - 在 Windows 11 使用 Autoware.Auto 框架进行自动驾驶开发

## 内容收录状态

- 已完整勘误、重写并收录的文章
  - [开启Win10的文件资源管理器的每显示器DPI缩放（Per-Monitor DPI Aware）支持](https://www.52pojie.cn/thread-506556-1-1.html)
  - [自定义开始屏幕的大小](http://bbs.pcbeta.com/viewthread-1524688-1-1.html)
  - [实现每显示器高DPI识别(Per-Monitor DPI Aware)的注意事项](https://www.52pojie.cn/thread-512713-1-1.html)
  - [浅谈Windows 10 Build 9879的磁盘清理的System Compression](http://bbs.pcbeta.com/viewthread-1567726-1-1.html)
  - [浅谈Windows10的CompactOS特性](https://www.52pojie.cn/thread-528806-1-1.html)
- 未完整勘误、重写并收录的文章
  - [Windows系统还原新探（Windows系统还原的较深入研究）](https://bbs.pcbeta.com/viewthread-1507617-1-1.html)
- 待勘误、重写并收录的文章
  - [浅谈Metro App的沙盒AppContainer](http://bbs.pcbeta.com/viewthread-1611980-1-1.html)
  - [反汇编Windows系统还原代码的成果](http://bbs.pcbeta.com/viewthread-1535789-1-1.html)
  - [原生集成Windows 8/8.1 自带的Windows Defender病毒库的教程](http://bbs.pcbeta.com/viewthread-1519551-1-1.html)
  - [NSudo 恶魔模式 - 一个面向希望无视文件和注册表访问检查的开发者的解决方案](https://bbs.pediy.com/thread-257345.htm)
