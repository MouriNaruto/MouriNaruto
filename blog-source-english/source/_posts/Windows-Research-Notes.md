---
title: Windows Research Notes
date: 2021-11-02 12:27:12
categories:
- [Technologies, Windows, Windows Research Notes]
tags:
- Technologies
- Windows
- Windows Research Notes
---

## Preface

Hi there, I go by Kenji Mouri.

I like to write technical articles, especially I like to post long technical posts in PCBeta Forum. Because I think 
posting in a forum where a lot of people go can make more people see it and make more people get help because of the
technical articles I write.

Around 2014 to 2016 was my productive period. Then I did not publish many technical articles because I was not inspired
to write long-form technical articles. But I did not have the courage to publish short technical articles in that time, 
because I was afraid that others said I was publishing useless posts in the forum.

As we all know, the server of PCBeta Forum was very unstable and inaccessible in the past few years. So at that time, I
had the idea of summarizing all the articles I had published in forums like PCBeta into a blog I hosted on GitHub. 
After all, forums can't exist forever, but Git repositories everyone can make backups of, and make it able to keep the
content I write.

Later, after the PCBeta Forum was back to normal, I forgot about it. Until recently, when I was encouraged to do so by
my friend walterlv, because of some opportunity.

I will not simply archive the technical articles I wrote before, but will errata and rewrite the content according to
the previous content with my current perspective. I hope this will reduce potential misunderstandings and better help 
readers who read this series of articles.

If you find any errors in this series of articles, or have better suggestions, please send your feedback directly to
https://github.com/MouriNaruto/MouriNaruto/issues.

Note: This index will be updated as the content of this series is updated.

Note: Article entries without hyperlinks in the table of contents are what I want to write about in the future.

Read [here](https://mourinaruto.github.io/zh/2021/11/02/Windows-Research-Notes/) for the Chinese version of 
this article if you are not good at English. (Translation: 如果你不擅长英文，可以点击本段话中的链接阅读中文版)

## Table of contents

- System Restore
  - {% post_link The-usage-of-System-Restore %}
  - {% post_link Using-System-Restore-via-CSharp %}
  - {% post_link Using-System-Restore-via-Cpp %}
  - {% post_link New-behavior-of-System-Restore-since-Windows-8 %}
- Compact OS
  - {% post_link The-history-and-principle-of-Compact-OS %}
  - {% post_link The-exclusion-list-of-Compact-OS %}
  - {% post_link The-usage-of-Compact-OS %}
- User Mode (Win32 API, NT API, Windows Runtime)
  - {% post_link Enable-Per-Monitor-DPI-Awareness-Mode-for-File-Explorer-in-Windows-10 %}
  - {% post_link Modify-the-size-of-Start-Screen-in-Windows-8-1 %}
  - {% post_link Notes-for-implement-Per-Monitor-DPI-Awareness-Mode-support-in-earlier-versions-of-Windows-10 %}
  - {% post_link Launch-Windows-Store-App-via-Win32-API %}
  - {% post_link Defrag-memory-with-NT-API %}
  - {% post_link Bypass-file-and-registry-access-check-only-with-Administrator %}
- Development Environment (Visual Studio, MSBuild, Cargo)
  - {% post_link Control-the-memory-usage-of-WSL-2-instance %}
  - {% post_link Use-VC-LTL-in-your-Rust-projects %}
  - {% post_link Develop-autonomous-driving-stack-with-Autoware-Auto-and-Windows-11 %}
  - {% post_link Tricks-for-parallel-compilation-with-MSVC-toolchain %}
  - {% post_link Some-noticeable-issues-in-Windows-10-Build-1904x-ISOs %}
  - {% post_link Build-Qt-6-with-VC-LTL %}
  - {% post_link Use-VC-LTL-in-your-Cpp-WinRT-UWP-projects %}

## Pending articles

- [浅谈Metro App的沙盒AppContainer](http://bbs.pcbeta.com/viewthread-1611980-1-1.html)  
- [原生集成Windows 8/8.1 自带的Windows Defender病毒库的教程](http://bbs.pcbeta.com/viewthread-1519551-1-1.html)

## Planned articles

- App Container
  - App Container 基本介绍
  - 通过 Win32 API 使用 App Container
  - 通过第三方工具使用 App Container
  - 通过 NT API 创建 App Container 访问令牌及注意事项
  - Windows 10 及之后版本的 App Container 行为变更
- Windows 用户模式 (Win32 API, NT API, Windows Runtime)
  - Windows 内置的 C 运行时库的历史沿革
  - 通过 Windows Runtime API 实现对商店应用的升级
  - Windows 应用程序打包项目的已知问题和解决方案
  - 使用 C++/WinRT 实现一个轻量级 XAML Island 应用
