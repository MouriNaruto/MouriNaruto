---
title: 通过 C++ 使用系统还原
date: 2021-11-14 03:36:16
categories:
- [技术, Windows, Windows 研究笔记, 系统还原]
tags:
- 技术
- Windows
- Windows 研究笔记
- 系统还原
---

本文用来总结如何通过 C++ 使用系统还原。由于阅读本文的读者肯定是想知道更多内容，于是我会尽可能做出精练的描述。

## 还原点类型

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

## 还原点事件类型

| 名称                       | 值  | 意义                             |
|----------------------------|-----|----------------------------------|
| BEGIN_SYSTEM_CHANGE        | 100 | 开始系统更改                     |
| END_SYSTEM_CHANGE          | 101 | 结束系统更改                     |
| BEGIN_NESTED_SYSTEM_CHANGE | 102 | 开始系统更改（不创建附加还原点） |
| END_NESTED_SYSTEM_CHANGE   | 103 | 结束系统更改（不创建附加还原点） |

## 系统还原 API 返回值

| 名称                       | 意义                             |
|----------------------------|----------------------------------|
| ERROR_SUCCESS              | 操作成功完成                     |
| ERROR_BAD_ENVIRONMENT      | 不能在安全模式调用               |
| ERROR_DISK_FULL            | 磁盘已满                         |
| ERROR_INTERNAL_ERROR       | 发生内部错误                     |
| ERROR_INVALID_DATA         | 还原点序号错误                   |
| ERROR_SERVICE_DISABLED     | 系统还原已关闭                   |
| ERROR_TIMEOUT              | 操作超时                         |

## 简化版系统还原 API 定义

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

## 创建和取消还原点

使用 `SRSetRestorePointW` API 即可。

## 删除指定序号的还原点

使用 `SRRemoveRestorePoint` API 即可。

## 启用系统还原

使用 `EnableSR` API 即可。

## 禁用系统还原

使用 `DisableSR` API 即可。

## 遍历还原点

由于系统还原 API 并没有提供遍历还原点的功能，于是需要调用 WMI API 通过 WMI 去遍历系统还原点。

## 清理还原点

由于在 C++ 下调用 WMI API 通过 WMI 去遍历系统还原点是一件很麻烦的事情，
由于从 Windows Vista 开始系统还原基于卷影复制，于是建议直接使用卷影复制 API 去删除卷影副本。

## 相关内容

- {% post_link The-usage-of-System-Restore %}
- {% post_link Windows-Research-Notes %}
