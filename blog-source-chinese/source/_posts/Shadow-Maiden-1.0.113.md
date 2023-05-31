---
title: 暗影女仆 (Shadow Maiden) 1.0 (Build 113)
date: 2022-06-01 00:00:00
categories:
- [Windows, Windows 应用, 宣布]
tags:
- Windows
- Windows 应用
- 宣布
---

由于为爱发电是不可持续的，我希望能找到一种方法来保持我对维护开源项目的热情。因此，我很自豪地介绍我的基于 Patreon
和爱发电的赞助服务，我认为这是实现这个目标的一个好方法。

- Patreon：https://www.patreon.com/MouriNaruto
- 爱发电：https://afdian.net/a/MouriNaruto

***

在我的 Patreon 和爱发电页面，有三个级别可以选择：

**忠实的支持者**

这个选项适合于只想支持我的人。我很高兴能从你那里喝到一杯好咖啡。你可以给我发信息，我会回复的! 谢谢你这样做!

**独家项目可供选择**

我将提供几个只对赞助者开放的项目给你。在目前阶段，我开始提供暗影女仆 (Shadow Maiden)，它是一个 Windows
下的轻量级系统优化工具。这是我第一个遵循该模式的项目。

**可提供定制项目**

重要提示：我知道这个级别真的很贵，我设置这个级别是因为我很忙，我需要设置一个高于我月薪的价格，
这样可以让我毫无顾虑地帮助你。如果你真的想选择这个级别，请在赞助前立即通过电子邮件联系我。

如果你选择这个，我可以为你定制和开发专属项目。如果你是一家公司，我真诚地希望我们能在未来建立起长期的合作关系。

***

我很高兴地宣布暗影女仆 (Shadow Maiden) 1.0 (Build 113) 的发布，现在可以下载了。这是我的第一个项目的第二个版本，
它遵循赞助软件的模式。

暗影女仆 (Shadow Maiden) 是一个用于 Windows 的系统优化工具。我希望将来能把它发展成一个用于 Windows
的系统优化、修改和部署框架。

下面是暗影女仆 (Shadow Maiden) 当前版本的发布说明：

- 在命令行帮助中增加功能文档。
- 改进几个实现。

这里是暗影女仆 (Shadow Maiden) 当前版本的命令行帮助：

```
格式: ShadowMaiden [ 功能 ] [ 参数 ]


可用功能:

  DefragMemory
      内存碎片整理，通过把物理内存中的大部分内存交换到页面文件实现

  EnableMicrosoftUpdate
      启用 Windows Update 中 "更新 Windows 时提供其他 Microsoft 产品的更新" 的
      选项

  LaunchAppX [应用用户模型 ID] [参数]
      启动一个 AppX

  ManageCompactOS [参数]
      CompactOS 管理
      /Query - 查询 CompactOS 状态
      /Enable - 启用 CompactOS
      /Disable - 禁用 CompactOS

  PurgeChromiumCache [参数]
      基于 Chromium 的应用程序的 Web 缓存清理，包括 Chrome、基于 Chromium 的
      Edge 和基于 Electron 的应用程序等
      /Scan - 扫描
      /Purge -  清理

  PurgeCorruptedAppXPackages [参数]
      损坏的 AppX 包清理
      /Scan - 扫描
      /Purge -  清理

  PurgeDeliveryOptimizationCache [参数]
      传递优化缓存清理
      /Scan - 扫描
      /Purge -  清理

  PurgeGeckoCache [参数]
      基于 Gecko 的应用程序的 Web 缓存清理，包括 Firefox、Waterfox 和 Pale Moon
      等
      /Scan - 扫描
      /Purge -  清理

  PurgeNuGetCache [参数]
      NuGet 缓存安全清理
      /Scan - 扫描
      /Purge -  清理

  PurgePackageCache [参数]
      Package Cache 目录安全清理
      /Scan - 扫描
      /Purge -  清理

  PurgeSystemRestorePoint [参数]
      系统还原点清理
      /Scan - 扫描
      /Purge -  清理

  PurgeTridentCache [参数]
      基于 Trident 的应用程序的 Web 缓存清理，包括 Internet Explorer、传统版本
      的 Edge、基于 MSHTML 的应用程序和基于 Edge WebView 的应用程序等
      /Scan - 扫描
      /Purge -  清理

  PurgeVisualStudioCodeCache [参数]
      Visual Studio Code 缓存清理
      /Scan - 扫描
      /Purge -  清理

  PurgeVisualStudioInstallerCache [参数]
      Visual Studio Installer 缓存安全清理
      /Scan - 扫描
      /Purge -  清理

  PurgeWindowsEventLog [参数]
      Windows 事件日志清理
      /Scan - 扫描
      /Purge -  清理

  PurgeWindowsSetup [参数]
      Windows 安装清理，包括以前的 Windows 安装文件、临时 Windows 安装文件、
      Windows 升级舍弃的文件、 Windows ESD 安装文件和 Windows 升级日志文件
      /Scan - 扫描
      /Purge -  清理

  UpdateAppXPackages [可选参数]
      Windows 商店应用一键升级
      /Loop - 循环执行，直到无应用包需要升级再停止


```

## 下载

- https://afdian.net/p/722c41baffc111edbcbe5254001e7c00
- https://www.patreon.com/posts/shadow-maiden-1-81515848
