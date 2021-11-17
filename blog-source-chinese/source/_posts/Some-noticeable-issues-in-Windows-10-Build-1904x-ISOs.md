---
title: Windows 10 Build 1904x ISO 中一些明显的问题
date: 2021-11-17 11:17:38
categories:
- [技术, Windows, Windows 研究笔记, 开发环境配置]
tags:
- 技术
- Windows
- Windows 研究笔记
- 开发环境配置
---

在 Windows 10 Build 19041 的官方 ISO 正式发布以后，我在远景写了一篇帖子来叙述微软在进行系统打包时出现的纰漏。
然而直到最新的 Windows 10, Version 21H2 即 Windows 10 Build 19044 该纰漏一直存在，看起来微软无暇关注 Windows 10 了，
毕竟 Windows 11 发布而其官方版本 ISO 并不存在这样的纰漏。

为了能够让更多的人注意到相关纰漏，于是我将相关内容梳理到本文以供参考。

## 问题列表

- `{ISO 根目录}\source\boot.wim` 在集成累积更新后并没有重新生成 WIM 镜像，于是在该镜像中存在旧版文件的残留，
  大概会导致 200MB 的体积增加。Windows 10 Enterprise LTSC 2021 官方 ISO 的 `boot.wim` 文件体积高达 700MB。
- `{ISO 根目录}\source\install.wim` 虽然在集成累积更新后重新生成了 WIM 镜像，但是其中的 Windows RE 映像即 `winre.wim`
  只集成了组件堆栈补丁没有集成累积更新，于是 Windows RE 的版本依然是 19041.1。

## 潜在影响

- 因为 `boot.wim` 体积增加，在内存捉襟见肘的某些 32 位计算机很可能无法正常引导到安装程序。
- 因为 `winre.wim` 没有集成累积更新，用户可能依旧遭遇着一些已经修复的恢复环境下的问题。
- 强迫症患者和完美主义者会对此表示很不爽。

## 参考文献

- [Windows 10 Version 2004 MSDN ISO 已知问题汇总](https://bbs.pcbeta.com/viewthread-1858942-1-1.html)

## 相关内容

{% post_link Windows-Research-Notes %}
