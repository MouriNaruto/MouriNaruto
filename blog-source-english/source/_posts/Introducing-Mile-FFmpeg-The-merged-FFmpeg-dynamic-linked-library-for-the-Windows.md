---
title: Introducing Mile.FFmpeg - The merged FFmpeg dynamic linked library for the Windows
date: 2022-01-26 22:03:02
categories:
- [Technologies, Windows, Windows Apps, Development, Announcement]
tags:
- Technologies
- Windows
- Windows Apps
- Development
- Announcement
---

In recent days, I have created a new project called [Mile.FFmpeg](https://github.com/ProjectMile/Mile.FFmpeg), the 
successor of [FFmpegUniversal](https://github.com/M2Team/FFmpegUniversal), provides the merged FFmpeg dynamic linked
library for the Windows.

I think you will ask me some questions when you read that. Here is the answers of the possible questions.

Read [here](https://mouri.moe/zh/2022/01/26/Introducing-Mile-FFmpeg-The-merged-FFmpeg-dynamic-linked-library-for-the-Windows/) for the Chinese version of 
this article if you are not good at English. (Translation: 如果你不擅长英文，可以点击本段话中的链接阅读中文版)

## The benefit of having a merged dynamic library

- The merged dynamic library can reduce at least 2MB binary size. If we enable some third-party modules and merge them,
  we can reduce more space.
- The merged dynamic library can keep the output binary file tree tidy, I will try to use FFmpegInteropX in my desktop 
  application with MediaPlayerElement control via XAML Islands and Media Foundation directly. My app will support 
  portable mode. Based on that, I will try to rewrite FFmpegInteropX with C++/WinRT because I can use some open source 
  infrastructures make the binary only rely on ucrtbase.dll. I will try to provide my rewrite implementation to this 
  project because I love creating or contributing to open source projects.

## Why reimplement the FFmpegUniversal

The reason for doing a new implementation because I want to make my solution support Windows desktop application, and 
simplify the build process. I try to find a way to get all symbols from *.lib and generate dll export definition 
without useless export symbols instead of build dynamic version first only for getting the dll export definition.

Also I switch to vcpkg for simplify the project, provide NuGet package and support Windows Vista RTM or later.

## Features of Mile.FFmpeg

- Based on the latest FFmpeg source code tree from vcpkg.
- Compile FFmpeg and related third-party libraries via vcpkg with aom, avcodec, avdevice, avfilter, avformat, bzip2,
  dav1d, fontconfig, freetype, iconv, ilbc, lzma, modplug, mp3lame, openh264, openjpeg, opus, snappy, soxr, speex, srt,
  swresample, swscale, theora, vorbis, vpx, webp, xml2 and zlib enabled.
- Use VC-LTL 5.x toolchain to make the binary size smaller.
- Provide NuGet package.

## How to use

You only need to search and add Mile.FFmpeg package in your NuGet client or download packages in GitHub Releases if you
don't want to use NuGet package manager.

## Afterword

I hope you will enjoy it. Thanks for reading.
