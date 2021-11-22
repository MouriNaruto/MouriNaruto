---
title: Windows 10 Build 1904x ISO 中存在的问题和解决方案
date: 2021-11-17 11:17:38
categories:
- [技术, Windows, Windows 研究笔记, 开发环境]
tags:
- 技术
- Windows
- Windows 研究笔记
- 开发环境
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

## 解决方案

本段以 Windows 10 Enterprise LTSC 2021 64 位官方 ISO 为例，且假定你有一台安装了 7-Zip 和 UltraISO 的 Windows 10 的计算机。

### 下载累积更新

由于 Windows 10 Enterprise LTSC 2021 的版本号为 10.0.19041.1288，从 Windows 10 更新历史记录页面可得知对应的累积更新为
KB5006670，去 Microsoft 更新目录网站可得知 KB5006670 的直链为：

- x86
  http://download.windowsupdate.com/c/msdownload/update/software/secu/2021/10/windows10.0-kb5006670-x86_6666ab09e61dc4f2f76bb3efc1a3c3631c2fb627.msu
- x64
  http://download.windowsupdate.com/c/msdownload/update/software/secu/2021/10/windows10.0-kb5006670-x64_51b78c3627885149a65b09dc92a936935017ff58.msu
- ARM64
  http://download.windowsupdate.com/c/msdownload/update/software/secu/2021/10/windows10.0-kb5006670-arm64_c91c87a424499a4051b66026ed73bb4dda7bc9d7.msu

使用浏览器或者第三方工具将文件下载并保持原来的文件名即可。

### 准备工作目录

首先我们需要创建一个工作目录，以 `C:\Win10Image` 为例；在该文件夹中放入你下载的官方 ISO 和累积更新且创建 `Mount` 和
`MountRE` 目录，效果如图。

![准备工作目录](WorkspaceImage.png)

### 提取必需文件

使用 7-Zip 从你下载的官方 ISO 中，将 ISO 中 `Source` 目录下的 `boot.wim` 和 `install.wim` 提取到工作目录，如图所示。

![提取必需文件](ExtractFiles.png)

### 命令行环境准备

以管理员身份运行命令提示符，并输入下述命令切换到工作目录。

> cd /d C:\Win10Image

命令行输出结果如下。

```
C:\Windows\system32>cd /d C:\Win10Image

C:\Win10Image>
```

### 重新生成 `boot.wim`

在准备好的命令环境中输入下述命令即可。

```
DISM /Export-Image /SourceImageFile:boot.wim /SourceIndex:1 /DestinationImageFile:boot.new.wim
DISM /Export-Image /SourceImageFile:boot.wim /SourceIndex:2 /Bootable /DestinationImageFile:boot.new.wim
del boot.wim
rename boot.new.wim boot.wim
```

命令行输出结果如下。

```
C:\Win10Image>DISM /Export-Image /SourceImageFile:boot.wim /SourceIndex:1 /DestinationImageFile:boot.new.wim

部署映像服务和管理工具
版本: 10.0.17763.1697

正在导出映像
[==========================100.0%==========================]
操作成功完成。

C:\Win10Image>DISM /Export-Image /SourceImageFile:boot.wim /SourceIndex:2 /Bootable /DestinationImageFile:boot.new.wim

部署映像服务和管理工具
版本: 10.0.17763.1697

正在导出映像
[==========================100.0%==========================]
操作成功完成。

C:\Win10Image>del boot.wim

C:\Win10Image>rename boot.new.wim boot.wim

C:\Win10Image>
```

### 挂载 `install.wim`

由于 Windows 10 Enterprise LTSC 2021 的 `install.wim` 只有一个 Index，于是在准备好的命令环境中输入下述命令即可。

> DISM /Mount-Wim /WimFile:install.wim /Index:1 /MountDir:Mount

命令行输出结果如下。

```
C:\Win10Image>DISM /Mount-Wim /WimFile:install.wim /Index:1 /MountDir:Mount

部署映像服务和管理工具
版本: 10.0.17763.1697

正在安装映像
[==========================100.0%==========================]
操作成功完成。

C:\Win10Image>
```

### 挂载 `install.wim` 内的 `winre.wim`

一般来说未经过 OOBE 阶段的 Windows RE 映像存放位置在 `Mount\Windows\System32\Recovery\Winre.wim`.

由于 Windows 10 Enterprise LTSC 2021 的 `winre.wim` 只有一个 Index，于是在准备好的命令环境中输入下述命令即可。

> DISM /Mount-Wim /WimFile:Mount\Windows\System32\Recovery\Winre.wim /Index:1 /MountDir:MountRE

命令行输出结果如下。

```
C:\Win10Image>DISM /Mount-Wim /WimFile:Mount\Windows\System32\Recovery\Winre.wim /Index:1 /MountDir:MountRE

部署映像服务和管理工具
版本: 10.0.17763.1697

正在安装映像
[==========================100.0%==========================]
操作成功完成。

C:\Win10Image>
```

### 为 `winre.wim` 集成 KB5006670

在准备好的命令环境中输入下述命令即可。

> DISM /Image:MountRE /Add-Package /PackagePath:windows10.0-kb5006670-x64_51b78c3627885149a65b09dc92a936935017ff58.msu

命令行输出结果如下。

```
C:\Win10Image>DISM /Image:MountRE /Add-Package /PackagePath:windows10.0-kb5006670-x64_51b78c3627885149a65b09dc92a936935017ff58.msu

部署映像服务和管理工具
版本: 10.0.17763.1697

映像版本: 10.0.19041.1

Processing 1 of 1 - Adding package C:\Win10Image\windows10.0-kb5006670-x64_51b78c3627885149a65b09dc92a936935017ff58.msu
[==========================100.0%==========================]
操作成功完成。

C:\Win10Image>
```

### 保存结果并重新生成 `winre.wim`

在准备好的命令环境中输入下述命令即可。

```
DISM /Unmount-Image /MountDir:MountRE /Commit
DISM /Export-Image /SourceImageFile:Mount\Windows\System32\Recovery\Winre.wim /SourceIndex:1 /Bootable /DestinationImageFile:Mount\Windows\System32\Recovery\Winre.new.wim
del Mount\Windows\System32\Recovery\Winre.wim
rename Mount\Windows\System32\Recovery\Winre.new.wim Winre.wim
```

命令行输出结果如下。

```
C:\Win10Image>DISM /Unmount-Image /MountDir:MountRE /Commit

部署映像服务和管理工具
版本: 10.0.17763.1697

正在保存映像
[==========================100.0%==========================]
正在卸载映像
[==========================100.0%==========================]
操作成功完成。

C:\Win10Image>DISM /Export-Image /SourceImageFile:Mount\Windows\System32\Recovery\Winre.wim /SourceIndex:1 /Bootable /DestinationImageFile:Mount\Windows\System32\Recovery\Winre.new.wim

部署映像服务和管理工具
版本: 10.0.17763.1697

正在导出映像
[==========================100.0%==========================]
操作成功完成。

C:\Win10Image>del Mount\Windows\System32\Recovery\Winre.wim

C:\Win10Image>rename Mount\Windows\System32\Recovery\Winre.new.wim Winre.wim

C:\Win10Image>
```

### 保存结果并重新生成 `install.wim`

在准备好的命令环境中输入下述命令即可。

```
DISM /Unmount-Image /MountDir:Mount /Commit
DISM /Export-Image /SourceImageFile:install.wim /SourceIndex:1 /DestinationImageFile:install.new.wim
del install.wim
rename install.new.wim install.wim
```

命令行输出结果如下。

```
C:\Win10Image>DISM /Unmount-Image /MountDir:Mount /Commit

部署映像服务和管理工具
版本: 10.0.17763.1697

正在保存映像
[==========================100.0%==========================]
正在卸载映像
[==========================100.0%==========================]
操作成功完成。

C:\Win10Image>DISM /Export-Image /SourceImageFile:install.wim /SourceIndex:1 /DestinationImageFile:install.new.wim

部署映像服务和管理工具
版本: 10.0.17763.1697

正在导出映像
[==========================100.0%==========================]
操作成功完成。

C:\Win10Image>del install.wim

C:\Win10Image>rename install.new.wim install.wim

C:\Win10Image>
```

### 生成修改后的 ISO

使用 UltraISO 或类似工具将原 ISO 的 `Source` 目录下 `boot.wim` 和 `install.wim` 替换并另存为你想要保存的文件即可。

![替换对应文件](ReplaceFiles.png)

## 示例映像

### zh-cn_windows_10_enterprise_ltsc_2021_x64_dvd_033b7312_mouri_repacked.iso

- SHA256: 62193E23BCC2D66A60807965B8CEB7C01887E7336A5C10B2D436432B2FE9C4BE
- 直链
  - 链接：https://d.legna.cn/MouriRepackedOS/LTSC2021/zh-cn_windows_10_enterprise_ltsc_2021_x64_dvd_033b7312_mouri_repacked.iso
  - 直链服务器由 Legna 赞助
- 百度网盘
  - 链接：https://pan.baidu.com/s/1eo8KOAe9p1Uoca5tRsB6Kg
  - 提取码：p2qe
- 临时网盘 (由 subaobao_ok 提供)
  - 链接：https://pan.adycloud.com/s/mZeun
  - 密码：bbs.pcbeta.com
- 天翼云盘 (由 subaobao_ok 提供)
  - 链接：https://cloud.189.cn/t/eq2mQnV3qIfa 
  - 访问码:9tov

### zh-cn_windows_10_enterprise_ltsc_2021_x86_dvd_30600d9c_mouri_repacked.iso

- SHA256: 239278A14ED0975AE99199352CDC1F54615D19A7DC8B7D753645A44B57A388EE
- 直链
  - 链接：https://d.legna.cn/MouriRepackedOS/LTSC2021/zh-cn_windows_10_enterprise_ltsc_2021_x86_dvd_30600d9c_mouri_repacked.iso
  - 直链服务器由 Legna 赞助
- 百度网盘
  - 链接：https://pan.baidu.com/s/1eo8KOAe9p1Uoca5tRsB6Kg
  - 提取码：p2qe

## 参考文献

- [Windows 10 Version 2004 MSDN ISO 已知问题汇总](https://bbs.pcbeta.com/viewthread-1858942-1-1.html)
- [Windows 10 更新历史记录](https://support.microsoft.com/zh-cn/topic/1b6aac92-bf01-42b5-b158-f80c6d93eb11)
- [Microsoft 更新目录](https://www.catalog.update.microsoft.com/)
- [【毛利重打包版（x86 和 x64）】Windows 10 Enterprise LTSC 2021【含天翼云分流】](https://bbs.pcbeta.com/viewthread-1912202-1-1.html)

## 相关内容

{% post_link Windows-Research-Notes %}
