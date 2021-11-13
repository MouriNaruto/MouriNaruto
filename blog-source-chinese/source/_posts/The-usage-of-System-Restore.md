---
title: 系统还原的使用方法
date: 2021-11-14 01:32:29
categories:
- [技术, Windows, Windows 研究笔记, 系统还原]
tags:
- 技术
- Windows
- Windows 研究笔记
- 系统还原
---

从 Windows ME 开始，微软在 Windows 操作系统中添加了系统还原功能。
由于该功能相当占用空间而且并不如其他快照类工具实用，于是成为一个冷门的鸡肋功能。
这个工具出了也有二十多年了，但是知道的人不多，即使知道的人也大概率会选择禁用该功能。
但是我却不大建议禁用系统还原，毕竟在诸如系统补丁安装失败的情况下还是能派上些用场的。

为了让人们能更好的驾驭系统还原功能，我写下了这篇文章。

## 图形界面

本节教程描述以 Windows 11 为例子。

要想进入系统保护的设置页面，大致步骤为 `开始` -> `所有应用` -> `设置` -> `系统` -> `关于` -> `系统保护`，
详情可以参考下面的图片。

![开始菜单](GuiUsageStep1.png)

![系统页面](GuiUsageStep2.png)

![关于页面](GuiUsageStep3.png)

![系统保护设置页面](GuiUsageStep4.png)

读者可以在打开的系统保护设置页面中创建还原点、启用或禁用系统还原、管理磁盘空间占用和将系统恢复到某个还原点。
这个简明易懂的界面对于大部分用户来说已经够用了，然而这部分由于并不是本文的重点，于是需要读者自行去探索。

## 命令行和脚本

本节提到的命令和脚本均需读者以管理员身份运行的命令提示符下运行。

### 通过 WMI 查看系统还原点信息

> PowerShell -NoLogo -NoProfile -NonInteractive -InputFormat None -ExecutionPolicy Bypass Get-WmiObject -Class SystemRestore -Namespace Root\Default

示例结果

```
CreationTime   Description    SequenceNumber    EventType RestorePointType
------------   -----------    --------------    --------- ----------------
2021/11/9 3:20:36      由毛利优化插件系统还原点清...  46BEGIN_SYSTEM_C... 16
2021/11/11 0:47:32     Windows 模块安装程序   47BEGIN_SYSTEM_C... APPLICATION_INSTALL
2021/11/11 3:20:46     Installed VMware Workstation   48BEGIN_SYSTEM_C... APPLICATION_INSTALL
```

### 通过 vssadmin 工具查看系统还原的空间占用情况

> vssadmin List ShadowStorage

示例结果

```
vssadmin 1.1 - 卷影复制服务管理命令行工具
(C) 版权所有 2001-2013 Microsoft Corp.

卷影副本存储关联
   卷: (C:)\\?\Volume{f4e7e09e-9b7d-4a8c-883f-0798a171916a}\
   卷影副本存储卷: (C:)\\?\Volume{f4e7e09e-9b7d-4a8c-883f-0798a171916a}\
   已用卷影副本存储空间: 20.2 GB (1%)
   分配的卷影副本存储空间: 20.6 GB (1%)
   最大卷影副本存储空间: 38.1 GB (1%)
```

### 通过 vssadmin 工具清理系统还原点

- 删除特定分区 (以 C 分区为例) 中的所有还原点
  > vssadmin Delete Shadows /For=C: /All /Quiet
- 删除所有分区的所有还原点
  > vssadmin Delete Shadows /All /Quiet
- 删除特定分区 (以 C 分区为例) 中的除最近的还原点之外的所有还原点
  > vssadmin Delete Shadows /For=C: /Oldest /Quiet
- 删除所有分区中的除最近的还原点之外的所有还原点
  > vssadmin Delete Shadows /Oldest /Quiet

### 通过 vssadmin 工具调整系统还原磁盘空间占比

以下是调整系统还原磁盘空间占比的命令行操作方法和对应的说明。

> vssadmin Resize ShadowStorage /For=ForVolumeSpec /On=OnVolumeSpec /MaxSize=MaxSizeSpec

用于重新调整 ForVolumeSpec 和 OnVolumeSpec 之间的卷影副本存储关联的最大值。重新调整存储关联会导致卷影副本消失。
当某些卷影副本被删除时，卷影副本存储空间会压缩。如果将 MaxSizeSpec 指定为值 UNBOUNDED，卷影副本存储空间将没有限制。
可以以字节为单位或 ForVolumeSpec 存储卷的百分比形式指定 MaxSizeSpec。对于字节级别指定，MaxSizeSpec 必须是 320MB 或更大，
并接受以下后缀: KB、MB、GB、TB、PB 和 EB。另外 B、K、M、G、T、P 和 E 是可以接受的后缀。若要指定 MaxSizeSpec的百分比，
请使用 % 字符作为数值的后缀。如果没有提供后缀，MaxSizeSpec 单位是字节。

为了更好的让用户理解上述说明，以下是对应的命令示例。

> vssadmin Resize ShadowStorage /For=C: /On=D: /MaxSize=900MB

> vssadmin Resize ShadowStorage /For=C: /On=D: /MaxSize=UNBOUNDED

> vssadmin Resize ShadowStorage /For=C: /On=C: /MaxSize=20%

### 通过 PowerShell 操作系统还原

由于我并不经常使用 PowerShell，于是仅提供相关用法的微软文档参考。

- 创建还原点 (Checkpoint-Computer)
  请参阅 https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/checkpoint-computer。
- 恢复到特定还原点 (Restore-Computer)
  请参阅 https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/restore-computer。
- 启用特定分区的系统还原 (Enable-ComputerRestore)
  请参阅 https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/enable-computerrestore。
- 禁用特定分区的系统还原 (Disable-ComputerRestore)
  请参阅 https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/disable-computerrestore。

### 通过 mshta 调用 WMI 操作系统还原

- 创建系统还原点
  > mshta vbscript:getobject("winmgmts:\\.\root\default:Systemrestore").createrestorepoint("系统还原点",0,100)(window.close)
- 启用系统还原
  > mshta vbscript:getobject("winmgmts:\\.\root\default:Systemrestore").Enable("分区，譬如 C:，如果相对所有分区进行操作请留空")(window.close)
- 禁用系统还原
  > mshta vbscript:getobject("winmgmts:\\.\root\default:Systemrestore").Disable("分区，譬如 C:，如果相对所有分区进行操作请留空")(window.close)

### 通过 VBScript 调用 WMI 操作系统还原

- 创建系统还原点
  ```
  getobject("winmgmts:\\.\root\default:Systemrestore").createrestorepoint("系统还原点",0,100)
  ```
- 开启系统还原
  ```
  getobject("winmgmts:\\.\root\default:Systemrestore").Enable("分区，譬如 C:，如果相对所有分区进行操作请留空")
  ```
- 关闭系统还原
  ```
  getobject("winmgmts:\\.\root\default:Systemrestore").Disable("分区，譬如 C:，如果相对所有分区进行操作请留空")
  ```
- 获取还原点的序号
  ```
  Set RPSet = GetObject("winmgmts:root/default").InstancesOf ("SystemRestore")
  for each RP in RPSet
      wscript.Echo "还原点序号： " & RP.SequenceNumber & ", 还原点名称： " & RP.Description & ", 还原点类型： ", RP.RestorePointType & ", 创建时间： " & RP.CreationTime
  next
  ```
- 执行系统还原
  ```
  Set obj = GetObject("winmgmts:{impersonationLevel=impersonate}!root/default:SystemRestore")
  if obj.Restore(还原点的序号) <> 0 Then
      wscript.Echo "Restore failed"
  End If
  Set OpSysSet = GetObject("winmgmts:{(Shutdown)}//./root/cimv2").ExecQuery("select * from Win32_OperatingSystem where Primary=true")
  for each OpSys in OpSysSet
      OpSys.Reboot()
  next
  ```

## 使用 C# 操作系统还原

请参阅 {% post_link Using-System-Restore-with-CSharp %}。

## 使用 C/C++ 操作系统还原

由于能阅读到本节的读者肯定是想知道更多内容，于是我会尽可能详细的描述。

### 还原点类型

| 名称                  | 值 | 意义           | 备注           |
|-----------------------|----|----------------|----------------|
| APPLICATION_INSTALL   | 0  | 程序安装       | 　             |
| APPLICATION_UNINSTALL | 1  | 程序卸载       | 　             |
| DESKTOP_SETTING       | 2  | 未知           | 微软未公开类型 |
| ACCESSIBILITY_SETTING | 3  | 未知           | 微软未公开类型 |
| OE_SETTING            | 4  | 未知           | 微软未公开类型 |
| APPLICATION_RUN       | 5  | 未知           | 微软未公开类型 |
| RESTORE               | 6  | 撤销还原       | 微软未公开类型 |
| CHECKPOINT            | 7  | 系统检查点     | 微软未公开类型 |
| WINDOWS_SHUTDOWN      | 8  | 未知           | 微软未公开类型 |
| WINDOWS_BOOT          | 9  | 未知           | 微软未公开类型 |
| DEVICE_DRIVER_INSTALL | 10 | 驱动安装       | 　             |
| FIRSTRUN              | 11 | 未知           | 微软未公开类型 |
| MODIFY_SETTINGS       | 12 | 更改设置       | 　             |
| CANCELLED_OPERATION   | 13 | 取消操作       | 　             |
| BACKUP_RECOVERY       | 14 | 备份恢复       | 微软未公开类型 |
| MANUAL_CHECKPOINT     | 16 | 手动           | 微软未公开类型 |
| WINDOWS_UPDATE        | 17 | Windows Update | 微软未公开类型 |
| CRITICAL_UPDATE       | 18 | 关键更新       | 微软未公开类型 |

### 还原点事件类型

| 名称                       | 值  | 意义                             |
|----------------------------|-----|----------------------------------|
| BEGIN_SYSTEM_CHANGE        | 100 | 开始系统更改                     |
| END_SYSTEM_CHANGE          | 101 | 结束系统更改                     |
| BEGIN_NESTED_SYSTEM_CHANGE | 102 | 开始系统更改（不创建附加还原点） |
| END_NESTED_SYSTEM_CHANGE   | 103 | 结束系统更改（不创建附加还原点） |

### 系统还原 API 返回值

| 名称                       | 意义                             |
|----------------------------|----------------------------------|
| ERROR_SUCCESS              | 操作成功完成                     |
| ERROR_BAD_ENVIRONMENT      | 不能在安全模式调用               |
| ERROR_DISK_FULL            | 磁盘已满                         |
| ERROR_INTERNAL_ERROR       | 发生内部错误                     |
| ERROR_INVALID_DATA         | 还原点序号错误                   |
| ERROR_SERVICE_DISABLED     | 系统还原已关闭                   |
| ERROR_TIMEOUT              | 操作超时                         |

### 简化版系统还原 API 定义

虽然 Windows SDK 中有系统还原 API 的头文件，但由于系统还原 API 需要进行动态加载，
且为了方便在一些没有系统还原 API 头文件的编译环境使用，于是我特意整理了大部分人需要用到的内容。

```
#include <Windows.h>

/**
 * @brief Event Type of Restore Points.
*/
enum RESTORE_POINT_EVENT_TYPE
{
    BeginSystemChange = 100,
    EndSystemChange,
    EndNestedSystemChange = 103,
    BeginNestedSystemChange
};

/**
 * @brief Type of Restore Points.
*/
enum RESTORE_POINT_TYPE
{
    ApplicationInstall,
    ApplicationUninstall,
    DesktopSetting,
    AccessibilitySetting,
    OESetting,
    ApplicationRun,
    Restore,
    CheckPoint,
    WindowsShutdown,
    WindowsBoot,
    DeviceDriverInstall,
    FirstRun,
    ModifySettings,
    CancelledOperation,
    BackupRecovery,
    Backup,
    ManualCheckPoint,
    WindowsUpdate,
    CriticalUpdate
};

/**
 * @brief For Windows Millennium compatibility.
*/
#pragma pack(push, srrestoreptapi_include)
#pragma pack(1)

/**
 * @brief Restore point information.
*/
typedef struct _RESTOREPTINFOW
{
    // Type of Event - Begin or End.
    DWORD dwEventType;

    // Type of Restore Point - App install/uninstall.
    DWORD dwRestorePtType;

    // Sequence Number - 0 for begin.
    INT64 llSequenceNumber;

    // Description - Name of Application / Operation.
    WCHAR szDescription[256];

} RESTOREPOINTINFOW, * PRESTOREPOINTINFOW;

/**
 * @brief Status returned by System Restore.
*/
typedef struct _SMGRSTATUS
{
    // Status returned by State Manager Process.
    DWORD   nStatus;

    // Sequence Number for the restore point.
    INT64   llSequenceNumber;

} STATEMGRSTATUS, * PSTATEMGRSTATUS;

#pragma pack(pop, srrestoreptapi_include)

/**
 * @brief RPC call to set a restore point.
 * @return If the call succeeds, the return value is TRUE. If the call
 *         fails, the return value is FALSE. If pSmgrStatus nStatus field
 *         is set as follows:
 *         ERROR_SUCCESS
 *             If the call succeeded (return value will be TRUE).
 *         ERROR_TIMEOUT
 *             If the call timed out due to a wait on a mutex for setting
 *             restore points.
 *         ERROR_INVALID_DATA
 *             If the cancel restore point is called with an invalid
 *             sequence number.
 *         ERROR_INTERNAL_ERROR
 *             If there are internal failures.
 *         ERROR_BAD_ENVIRONMENT
 *             If the API is called in SafeMode.
 *         ERROR_SERVICE_DISABLED
 *             If System Restore is Disabled.
 *         ERROR_DISK_FULL
 *             If System Restore is frozen (Windows Whistler only).
 *         ERROR_ALREADY_EXISTS
 *             If this is a nested restore point.
*/

extern "C"
{
    BOOL WINAPI SRSetRestorePointW(
        _In_ PRESTOREPOINTINFOW pRestorePtSpec,
        _Out_ PSTATEMGRSTATUS   pSMgrStatus);

    DWORD WINAPI SRRemoveRestorePoint(
        _In_ DWORD dwRPNum);

    DWORD WINAPI EnableSR(
        _In_ LPCWSTR lpDrive);

    DWORD WINAPI DisableSR(
        _In_ LPCWSTR lpDrive);
}
```

其中 `SRSetRestorePointW` 用于创建和取消还原点，`SRRemoveRestorePoint` 用于删除指定的还原点，
`EnableSR` 用于启用特定分区的系统还原，`DisableSR` 用于禁用用特定分区的系统还原。

在微软文档中仅对 `SRSetRestorePointW` 和 `SRRemoveRestorePoint` 进行了文档化属于公开 API，
`EnableSR` 和`DisableSR` 仅在系统还原 API 头文件进行了定义，于是属于半文档化 API。

### 创建和取消还原点

使用 `SRSetRestorePointW` API 即可。

### 删除指定序号的还原点

使用 `SRRemoveRestorePoint` API 即可。

### 启用系统还原

使用 `EnableSR` API 即可。

### 禁用系统还原

使用 `DisableSR` API 即可。

### 遍历还原点

由于系统还原 API 并没有提供遍历还原点的功能，于是需要调用 WMI API 通过 WMI 去遍历系统还原点。

### 清理还原点

由于在 C++ 下调用 WMI API 通过 WMI 去遍历系统还原点是一件很麻烦的事情，
由于从 Windows Vista 开始系统还原基于卷影复制，于是建议直接使用卷影复制 API 去删除卷影副本。

## 相关内容

{% post_link Windows-Research-Notes %}
