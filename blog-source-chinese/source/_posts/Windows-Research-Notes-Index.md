---
title: Windows 研究笔记 - 索引
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
直到最近因为一些契机，且在在友人 walterlv 的鼓励下，使得我下定决心这么做。

我并不会单纯的归档之前撰写的技术文章，而是会根据之前的内容以我现在的视角去对内容进行勘误和重写。
希望借此能够减少潜在的理解错误的地方，能够更好的帮助看到我这一系列文章的读者。

如果发现了本系列文章中的错误内容，或者有更好的建议，请直接在
https://github.com/MouriNaruto/MouriNaruto/issues 反馈。

注：本索引会随着本系列内容的更新而更新。

## 目录

- Windows 系统还原
  - 系统还原基本介绍
  - 通过命令行使用系统还原
  - 通过程序语言使用系统还原
  - 系统还原点存储结构分析
  - 系统还原的未文档化 Win32 API
  - {% post_link Windows-Research-Notes-New-behavior-of-System-Restore-since-Windows-8 %}
- Compact OS
  - 通过命令行使用 Compact OS
  - 通过 Win32 API 使用 Compact OS
  - Compact OS 的历史和实现原理
- App Container
  - App Container 基本介绍
  - 通过 Win32 API 使用 App Container
  - 通过第三方工具使用 App Container
  - 通过 NT API 创建 App Container 访问令牌及注意事项
  - Windows 10 及之后版本的 App Container 行为变更
- Windows 自带的 C 运行时库
  - Windows 自带的 C 运行时库的历史沿革
  - 通过 VC-LTL 使用 Windows 自带的 C 运行时库
  - 在传统 UWP 中使用 VC-LTL
  - 在 Rust 中使用 VC-LTL
- Windows Runtime
  - 通过 Windows Runtime API 实现对商店应用的升级
  - Windows 应用程序打包项目的已知问题和解决方案
  - 使用 C++/WinRT 实现一个轻量级 XAML Island 应用
  - 自定义 Windows 8.x 开始屏幕的大小
