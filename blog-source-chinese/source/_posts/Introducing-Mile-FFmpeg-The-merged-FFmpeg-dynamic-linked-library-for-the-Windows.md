---
title: 宣布 Mile.FFmpeg - 在 Windows 下使用的 FFmpeg 合并版动态链接库
date: 2022-01-26 22:03:02
categories:
- [技术, Windows, Windows 应用, 开发, 宣布]
tags:
- 技术
- Windows
- Windows 应用
- 开发
- 宣布
---

最近，我创建了一个叫 [Mile.FFmpeg](https://github.com/ProjectMile/Mile.FFmpeg) 的新项目，是
[FFmpegUniversal](https://github.com/M2Team/FFmpegUniversal) 的后继者，是一个在 Windows 下使用的
FFmpeg 合并版动态链接库。

我相信在阅读到这里的时候会问我一些问题，下述是可能的问题及其回答。

如果你不擅长中文，可以[点此](https://mouri.moe/en/2022/01/26/Introducing-Mile-FFmpeg-The-merged-FFmpeg-dynamic-linked-library-for-the-Windows/)阅读英文版。
(翻译: If you are not good at Chinese, you can click on the link in this paragraph to read the English version.)

## 合并版动态链接库的优势

- 合并后的动态库可以减少至少 2MB 的二进制大小。如果我们启用一些第三方模块并将其合并，我们可以减少更多的空间
- 合并后的动态库可以保持输出二进制文件树的整洁，我将尝试在我的桌面应用程序中使用 FFmpegInteropX，通过 XAML Islands 和
  Media Foundation 直接使用 MediaPlayerElement。我的应用程序将支持便携式模式。基于此，我将尝试用 C++/WinRT 重写 
  FFmpegInteropX，因为我可以使用一些开源的基础设施，使二进制文件只依赖于 ucrtbase.dll。
  我将尝试为这个项目提供我的重写实现，因为我喜欢创造或贡献给开源项目

## 为什么重制 FFmpegUniversal

之所以要做一个新的实现，是因为我想让我的解决方案支持 Windows 桌面应用程序，并且简化构建过程。我试图找到一种从 *.lib 
中获取所有的符号并生成 dll 导出定义而不是仅仅为了得到dll导出定义而先构建动态版本的方法。

同时我改用 vcpkg 来简化项目，提供 NuGet 包并支持 Windows Vista RTM 或更高版本。

## Mile.FFmpeg 功能

- 基于 vcpkg 提供的 FFmpeg 最新稳定版的代码树
- 使用 vcpkg 编译 FFmpeg 并开启以下第三方库：aom, avcodec, avdevice, avfilter, avformat, bzip2,
  dav1d, fontconfig, freetype, iconv, ilbc, lzma, modplug, mp3lame, openh264, openjpeg, opus, snappy, soxr, speex, srt,
  swresample, swscale, theora, vorbis, vpx, webp, xml2 and zlib
- 使用 VC-LTL 5.x 工具链缩减二进制的体积
- 提供 NuGet 包

## 如何使用

你只需要在你的 NuGet 客户端搜索 Mile.FFmpeg 包即可，如果你不想使用 NuGet 包管理器则可去 GitHub Releases 下载。

## 后记

我希望你能够使用愉快，感谢阅读。
