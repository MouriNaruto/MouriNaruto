---
title: 当 VMware Workstation 与 Hyper-V 共存时的注意事项
date: 2022-02-07 19:45:33
categories:
- [技术, Windows, Windows 应用, 开发, 体验]
tags:
- 技术
- Windows
- Windows 应用
- 开发
- 体验
---

众所周知，VMware Workstation 在之前的很长一段时间内都不支持和 Hyper-V 共存，但因为越来越多的 Windows 组件需要在开启 
Hyper-V 之后才能使用，VMware 终于在 VMware Workstation 15.5.5 开始支持和 Hyper-V 共存。

虽然的确添加了支持，但是也有一些限制，归纳这些问题是我写这篇文章的动机。

## Windows 11 上 VMware Workstation 无法与 Hyper-V 共存

这是 VMware Workstation 的 [已知问题](https://communities.vmware.com/t5/VMware-Workstation-Pro/Workstation-16-1-2-Pro-under-Windows-11-host-Windows-guest-in-VM/m-p/2889337)，
在 16.2.2 中得到了修复。

P.S. 我等这个 Bug 的修复等待了小半年……

## VMware Workstation 嵌套虚拟化支持

想多了，不支持，在这种情况下弄嵌套虚拟化的话，还是用 Hyper-V 吧。

## Windows 10 Version 20H1/20H2/21H1/21H2 虚拟机一步一卡

这个应该是 VMware Workstation 的 NVME 协议模拟在开启 Hyper-V 后触发的 Bug，毕竟事件查看器报了一堆“发出了对设备 
\Device\RaidPort1 的重置”的警告。

解决方法也不难，那就是把虚拟机的磁盘类型从 NVME 更换成 SATA 或者 SCSI。

相关问题我已经进行[反馈](https://communities.vmware.com/t5/VMware-Workstation-Pro/Huge-performance-drop-after-upgrading-to-VMware-Workstation-Pro/m-p/2888831),等待 VMware 进行修复。
