---
title: 减小 WSL2 的内存占用
date: 2020-11-01 16:09:18
categories:
- [技术, Windows]
tags:
- 技术
- Windows
- WSL2
---

前段日子重装了自己安装 Windows 10 的台式机里面的 Linux 子系统，
顺便把子系统版本从 WSL1 迁移到了 WSL2。

WSL2 实质上是一个 Hyper-V 虚拟机，
只是里面跑的是微软为 Hyper-V 高度优化后的 Linux 内核，
于是 WSL2 冷启动速度非常迅速，
在我的台式机上不到一秒钟就能完成其冷启动全过程。

由于 WSL2 实质是个虚拟机而不是 WSL1 那种把 Linux 系统调用翻译成 Windows 系统调用的方式，
于是在 I/O 操作这种系统调用密集型操作上效率有了质的提升，
而且还支持挂载 ext4 等 Windows 本身不支持的文件系统。

然而我在用 WSL2 的一开始就因为使用 apt 安装 texlive 的时候发现内存占用爆表，
最后研究了下是 Linux 内核文件缓存占了非常多的内存而且既然是缓存那么大概率是不会释放的，
于是 Hyper-V 即使支持智能释放虚拟机空闲内存也起不了多少作用。

据说 Windows 下一个大版本，也许是 21H2，会引入 WSL2 默认最多只能使用机器的 50% 物理内存的限制。
然而下一个大版本还没有发布，而且也不确定微软是否会继续跳票，毕竟原本今年秋季就会有大更新。
所以还是得要寻找手工配置的方法，看了下微软的文档很顺利地找到了。

文档参考：https://docs.microsoft.com/en-us/windows/wsl/wsl-config#configure-global-options-with-wslconfig

于是我在用户配置目录下创建了 `.wslconfig` 文件，然后填入了以下内容保存后问题成功解决。

```
[wsl2]
memory=4GB
```

上述配置的实质的含义是配置 WSL2 对应的 Hyper-V 最多使用 4GB 内存，就这么简单。
