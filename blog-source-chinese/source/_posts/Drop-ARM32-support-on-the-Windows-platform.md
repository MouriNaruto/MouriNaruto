---
title: 在 Windows 平台上移除 ARM32 支持
date: 2021-05-17 11:53:53
categories:
- [公告, Windows]
tags:
- 公告
- Windows
---

经过审慎考虑，在我为主要维护者的开源项目（譬如 NSudo）的未来版本将会移除 ARM32 
支持，主要原因如下：

- Windows ARM32 桌面版本停滞在 Redstone 2 Insider Build 15035，虽然 ARM32 版本
  还有 Windows RT 8.1 和 Windows 10 IoT Core 系列没有结束支持，然而估计绝大部分
  非考古用途人士基本已经放弃使用相关设备（Windows RT 8.x 平板）和有更好的替代品
  （树莓派上使用 IoT Core ARM32 其实不如直接迁移到 Linux 或者 Windows 10 ARM64 
  桌面版本）。
- 未来的 ARM 处理器将会砍掉 ARM32 指令集支持，其实 Apple Silicon M1 已经这么做
  了，所以在该设备上跑的 Windows 10 ARM64 桌面版应该并不支持 ARM32 应用（毕竟 
  ARM64 下的 ARM32 应用支持和 x64 下的 x86 应用支持原理类似，都是硬件直接执行而
  不是仿真）。
- 对未来采用 Rust, .NET 和 Project Reunion 编写部分实现的可能性的考量，这些设施
  在 Windows 下大概率不会重新考虑支持 ARM32 应用开发支持。
- 减小发行包的体积、加快连续集成执行速度。

毛利
