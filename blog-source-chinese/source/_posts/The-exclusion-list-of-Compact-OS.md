---
title: Compact OS 的文件和目录排除列表
date: 2021-11-06 23:40:06
categories:
- [技术, Windows, Windows 研究笔记, Compact OS]
tags:
- 技术
- Windows
- Windows 研究笔记
- Compact OS
---

虽然 Compact OS 是一个相当好用的功能，典型情况下可以让你的系统分区节省出 30% 的空间。
但是并不是所有文件都能采用 Compact OS 进行压缩，于是需要排除掉不能使用 Compact OS 压缩的文件。

我从 Windows 10 中提取出了 Compact OS 默认的排除列表，希望能帮助需要开发基于 Compact OS 的第三方应用的朋友。

由于 Windows 下使用 Compact OS 的途径主要是 DISM 和 compact 工具，于是本文贴出这两个工具使用的排除列表

## DISM 工具使用的排除列表

DISM 通过 Windows Imaging Library (wimgapi.dll) 来实现在映像展开过程中对文件进行 Compact OS 压缩，
其采用的排除列表和 WIMBoot 一致，排除列表保存在 `WimBootCompress.ini` 中，一般情况下内容如下。

DISM 用的这套排除列表比较精细，但是自己实现起来比较麻烦。

```
; This is the inbox configuration file used for deploying or capture a
; WIMBoot system. Please do not remove this file because WIMCaptureImage 
; and WIMApplyImage will fail if WIM_FLAG_WIM_BOOT flag is specified.

[CompressionExclusionList]
ntoskrnl.exe

[PrepopulateList]
bootstat.dat
*winload.*
*winresume.*
wof.sys
\Windows\System32\Config\SYSTEM
\Windows\System32\PlatformManifest\*

[ExclusionList]
\$bootdrive$
\$dwnlvldrive$
\$lsdrive$
\$installdrive$
\$Recycle.Bin\*
\bootsect.bak
\hiberfil.sys
\pagefile.sys
\ProgramData\Microsoft\Windows\SQM
\System Volume Information
\Users\*\AppData\Local\GDIPFONTCACHEV1.DAT
\Users\*\NTUSER.DAT*.TM.blf
\Users\*\NTUSER.DAT*.regtrans-ms
\Users\*\NTUSER.DAT*.log*
\Windows\AppCompat\Programs\Amcache.hve*.TM.blf
\Windows\AppCompat\Programs\Amcache.hve*.regtrans-ms
\Windows\AppCompat\Programs\Amcache.hve*.log*
\Windows\CSC
\Windows\Debug\*
\Windows\Logs\*
\Windows\Panther\*.etl
\Windows\Panther\*.log
\Windows\Panther\FastCleanup
\Windows\Panther\img
\Windows\Panther\Licenses
\Windows\Panther\MigLog*.xml
\Windows\Panther\Resources
\Windows\Panther\Rollback
\Windows\Panther\Setup*
\Windows\Panther\UnattendGC
\Windows\Panther\upgradematrix
\Windows\Prefetch\*
\Windows\ServiceProfiles\LocalService\NTUSER.DAT*.TM.blf
\Windows\ServiceProfiles\LocalService\NTUSER.DAT*.regtrans-ms
\Windows\ServiceProfiles\LocalService\NTUSER.DAT*.log*
\Windows\ServiceProfiles\NetworkService\NTUSER.DAT*.TM.blf
\Windows\ServiceProfiles\NetworkService\NTUSER.DAT*.regtrans-ms
\Windows\ServiceProfiles\NetworkService\NTUSER.DAT*.log*
\Windows\System32\config\RegBack\*
\Windows\System32\config\*.TM.blf
\Windows\System32\config\*.regtrans-ms
\Windows\System32\config\*.log*
\Windows\System32\SMI\Store\Machine\SCHEMA.DAT*.TM.blf
\Windows\System32\SMI\Store\Machine\SCHEMA.DAT*.regtrans-ms
\Windows\System32\SMI\Store\Machine\SCHEMA.DAT*.log*
\Windows\System32\sysprep\Panther
\Windows\System32\winevt\Logs\*
\Windows\System32\winevt\TraceFormat\*
\Windows\Temp\*
\Windows\TSSysprep.log
\Windows\winsxs\poqexec.log
\Windows\winsxs\ManifestCache\*
\Windows\servicing\Sessions\*_*.xml
\Windows\servicing\Sessions\Sessions.back.xml

[PinningFolderList]
\Windows\System32\config
\Windows\System32\DriverStore
\Windows\WinSxS

[CompressionFolderList]
\Windows\System32\WinEvt\Logs
\Windows\Installer
```

## compact 工具使用的排除列表

系统自带的 compact 工具直接使用 `DeviceIoControl` API 进行 Compact OS 压缩，比 DISM 更加底层。
于是其排除列表是内置的，通过 IDA Pro 工具从 compact 工具提取出来的列表如下。

当然 compact 工具的做法比较暴力，只要判断路径中有列表中的关键字就跳过，但是自己实现起来比较简单。

```
// 文件排除列表
wchar_t *FileExclusionList[] = 
{
	L"\\aow.wim",
	L"\\boot\\bcd",
	L"\\boot\\bcd.log",
	L"\\boot\\bootstat.dat",
	L"\\config\\drivers",
	L"\\config\\drivers.log",
	L"\\config\\system",
	L"\\config\\system.log",
	L"\\windows\\bootstat.dat",
	L"\\winload.efi",
	L"\\winload.efi.mui",
	L"\\winload.exe",
	L"\\winload.exe.mui",
	L"\\winresume.efi",
	L"\\winresume.efi.mui",
	L"\\winresume.exe",
	L"\\winresume.exe.mui"
};

// 目录排除列表
wchar_t *DirectoryExclusionList[] = 
{
	L"\\Backup\\",
	L"\\ManifestCache\\",
	L"\\Manifests\\"
};
```

## 相关内容

{% post_link Windows-Research-Notes %}
