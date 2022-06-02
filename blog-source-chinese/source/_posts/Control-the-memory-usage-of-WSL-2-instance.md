---
title: 控制 WSL 2 实例的内存占用
date: 2021-11-02 14:32:10
categories:
- [技术, Windows, Windows 研究笔记, 开发环境]
tags:
- 技术
- Windows
- Windows 研究笔记
- 开发环境
---

前段日子重装了我的台式机里面的 Linux 子系统，顺便把子系统版本从 WSL1 迁移到了 WSL2。

WSL2 实质上是一个 Hyper-V 虚拟机，只是里面跑的是微软为 Hyper-V 高度优化后的 Linux 内核，
于是 WSL2 冷启动速度非常迅速，在我的台式机上不到一秒钟就能完成其冷启动全过程。

由于 WSL2 实质是个虚拟机而不是 WSL1 那种把 Linux 系统调用翻译成 Windows 系统调用的方式，
于是在 I/O 操作这种系统调用密集型操作上效率有了质的提升，
而且还支持挂载 ext4 等 Windows 本身不支持的文件系统。

然而我在用 WSL2 的一开始就因为使用 apt 安装 texlive 的时候发现内存占用爆表，
最后研究了下是 Linux 内核文件缓存占了非常多的内存而且既然是缓存那么大概率是不会释放的，
于是 Hyper-V 即使支持智能释放虚拟机空闲内存也起不了多少作用。

## 解决方案

在用户配置目录下创建了 `.wslconfig` 文件，然后填入了以下内容保存后问题成功解决。

```
[wsl2]
memory=4GB
```

## 默认行为

- Windows 10 Build 20175 及之后版本
  - 最大占用 Windows 可使用的总内存的 50% 或 8GB (以较小者为准)
- Windows 10 Build 20175 之前版本
  - 最大占用 Windows 可使用的总内存的 80%

## 参考资料

- [Global configuration options with .wslconfig](https://docs.microsoft.com/en-us/windows/wsl/wsl-config#global-configuration-options-with-wslconfig?WT.mc_id=WDIT-MVP-5004706)

## 相关内容

{% post_link Windows-Research-Notes %}
