---
title: Drop ARM32 support on the Windows platform
date: 2021-05-17 11:53:53
categories:
- [Notice, Windows]
tags:
- Notice
- Windows
---

For my deliberate consideration, The open source projects created or maintained
by myself will drop the ARM32 support on the Windows platform. Here are the
reasons:

- The latest version of ARM32 version for Windows desktop is Redstone 2 Insider
  Build 15035. I know Windows RT 8.1 and Windows 10 IoT Core aren't in the 
  stage of end of support, but most of daily users are drop their devices 
  (Windows RT 8.x tablets) or have a better solution (Windows 10 IoT Core users
  on Raspberry Pi devices should migrate to Linux or ARM64 version for Windows
  10 desktop).
- Future ARM processors are deprecating ARM32 ISA support, and Apple Silicon M1
  had dropped the ARM32 support at all. So we can't run ARM32 version of 
  Windows desktop applications on these devices.
- I'm considering the possibility of using Rust, .NET, and Project Reunion to
  write a part of the implementation of some projects in the future, and these
  infrastructures will not reconsider support for ARM32 support on Windows.
- Reduce the size of release package and make the continuous integration
  faster.

Kenji Mouri
