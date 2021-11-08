﻿---
title: 使用 Win32 API 启动 Windows 商店应用
date: 2021-11-07 22:59:35
categories:
- [技术, Windows, Windows 研究笔记, 用户模式]
tags:
- 技术
- Windows
- Windows 研究笔记
- 用户模式
---

本文描述如何通过命令行和 Win32 API 启动一个商店应用。

## 获取 Windows 商店应用启动入口

首先在 PowerShell 下粘贴以下命令获取你机器里可以使用 Windows 商店应用启动入口。

```
$installedapps = get-AppxPackage
foreach ($app in $installedapps)
{
    foreach ($id in (Get-AppxPackageManifest $app).package.applications.application.id)
    {
        $app.packagefamilyname + "!" + $id
    }
}
```

在我的 Windows 11 机器中调用该脚本脚本返回的可用 Windows 商店应用启动入口如下。

```
Microsoft.XboxGameOverlay_8wekyb3d8bbwe!App
Microsoft.XboxSpeechToTextOverlay_8wekyb3d8bbwe!App
Microsoft.Xbox.TCUI_8wekyb3d8bbwe!Microsoft.Xbox.TCUI
Microsoft.XboxApp_8wekyb3d8bbwe!Microsoft.XboxApp
Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe!App
Microsoft.People_8wekyb3d8bbwe!x4c7a3b7dy2188y46d4ya362y19ac5a5805e5x
Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe!App
Microsoft.MixedReality.Portal_8wekyb3d8bbwe!App
RivetNetworks.KillerControlCenter_rh07ty8m5nkag!RivetNetworks.KillerControlCenter
RealtekSemiconductorCorp.RealtekAudioControl_dt26b99r8h8gj!App
Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe!Microsoft.MicrosoftOfficeHub
Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe!LocalBridge
Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe!OfficeHubHWA
AppUp.IntelGraphicsExperience_8j3eq9eme6ctt!App
AppUp.ThunderboltControlCenter_8j3eq9eme6ctt!App
Microsoft.XboxIdentityProvider_8wekyb3d8bbwe!Microsoft.XboxIdentityProvider
Microsoft.WebMediaExtensions_8wekyb3d8bbwe!App
Microsoft.BingWeather_8wekyb3d8bbwe!App
Microsoft.GetHelp_8wekyb3d8bbwe!App
Microsoft.WebpImageExtension_8wekyb3d8bbwe!App
Microsoft.BioEnrollment_cw5n1h2txyewy!App
Microsoft.Windows.CloudExperienceHost_cw5n1h2txyewy!App
Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy!App
Microsoft.Windows.OOBENetworkConnectionFlow_cw5n1h2txyewy!App
Microsoft.Windows.OOBENetworkCaptivePortal_cw5n1h2txyewy!App
Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy!App
Microsoft.Windows.ShellExperienceHost_cw5n1h2txyewy!App
windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel
Microsoft.Windows.Search_cw5n1h2txyewy!CortanaUI
Microsoft.Windows.Search_cw5n1h2txyewy!ShellFeedsUI
Microsoft.Windows.Search_cw5n1h2txyewy!FESearchUI
Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge
Microsoft.MicrosoftEdge_8wekyb3d8bbwe!PdfReader
Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy!App
Microsoft.SecHealthUI_8wekyb3d8bbwe!SecHealthUI
Microsoft.Windows.CallingShellApp_cw5n1h2txyewy!Microsoft.Windows.CallingShellApp
Microsoft.Windows.AssignedAccessLockApp_cw5n1h2txyewy!App
Microsoft.Windows.CapturePicker_cw5n1h2txyewy!App
Microsoft.Windows.Apprep.ChxApp_cw5n1h2txyewy!App
Microsoft.Windows.NarratorQuickStart_8wekyb3d8bbwe!App
Microsoft.Win32WebViewHost_cw5n1h2txyewy!DPI.PerMonitorAware
Microsoft.Win32WebViewHost_cw5n1h2txyewy!DPI.SystemAware
Microsoft.Win32WebViewHost_cw5n1h2txyewy!DPI.Unaware
Microsoft.Windows.ParentalControls_cw5n1h2txyewy!App
1527c705-839a-4832-9118-54d4Bd6a0c89_cw5n1h2txyewy!Microsoft.Windows.FilePicker
Windows.PrintDialog_cw5n1h2txyewy!Microsoft.Windows.PrintDialog
Windows.CBSPreview_cw5n1h2txyewy!Microsoft.Windows.CBSPreview
NcsiUwpApp_8wekyb3d8bbwe!App
Microsoft.XboxGameCallableUI_cw5n1h2txyewy!Microsoft.XboxGameCallableUI
Microsoft.Windows.XGpuEjectDialog_cw5n1h2txyewy!Microsoft.Windows.XGpuEjectDialog
Microsoft.Windows.SecureAssessmentBrowser_cw5n1h2txyewy!App
Microsoft.Windows.PinningConfirmationDialog_cw5n1h2txyewy!App
Microsoft.Windows.PeopleExperienceHost_cw5n1h2txyewy!App
Microsoft.PPIProjection_cw5n1h2txyewy!Microsoft.PPIProjection
Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe!App
Microsoft.LockApp_cw5n1h2txyewy!WindowsDefaultLockScreen
Microsoft.ECApp_8wekyb3d8bbwe!App
Microsoft.CredDialogHost_cw5n1h2txyewy!App
Microsoft.AsyncTextService_8wekyb3d8bbwe!App
Microsoft.AccountsControl_cw5n1h2txyewy!App
F46D4000-FD22-4DB4-AC8E-4E1DDDE828FE_cw5n1h2txyewy!App
E2A4F912-2574-4A75-9BB0-0D023378592B_cw5n1h2txyewy!Microsoft.Windows.AppResolverUX
c5e2524a-ea46-4f67-841f-6a9465d9d515_cw5n1h2txyewy!App
Microsoft.ZuneVideo_8wekyb3d8bbwe!Microsoft.ZuneVideo
Microsoft.ZuneMusic_8wekyb3d8bbwe!Microsoft.ZuneMusic
Microsoft.GamingApp_8wekyb3d8bbwe!Microsoft.Xbox.App
Microsoft.BingNews_8wekyb3d8bbwe!AppexNews
Microsoft.Getstarted_8wekyb3d8bbwe!App
Microsoft.DesktopAppInstaller_8wekyb3d8bbwe!App
Microsoft.DesktopAppInstaller_8wekyb3d8bbwe!PythonRedirector
Microsoft.DesktopAppInstaller_8wekyb3d8bbwe!winget
Microsoft.WindowsNotepad_8wekyb3d8bbwe!App
Microsoft.WindowsMaps_8wekyb3d8bbwe!App
MicrosoftTeams_8wekyb3d8bbwe!MicrosoftTeams
MicrosoftTeams_8wekyb3d8bbwe!msteamsupdate
Microsoft.Paint_8wekyb3d8bbwe!App
Microsoft.549981C3F5F10_8wekyb3d8bbwe!App
Microsoft.LanguageExperiencePackzh-CN_8wekyb3d8bbwe!App
40174MouriNaruto.NanaZip_gnj4mf6z9tkrc!NanaZipC
40174MouriNaruto.NanaZip_gnj4mf6z9tkrc!NanaZipG
40174MouriNaruto.NanaZip_gnj4mf6z9tkrc!NanaZip
9426MICRO-STARINTERNATION.MSICenter_kzh8wxbdkxb8p!App
Microsoft.HEIFImageExtension_8wekyb3d8bbwe!App
NVIDIACorp.NVIDIAControlPanel_56jybvy8sckqj!NVIDIACorp.NVIDIAControlPanel
Microsoft.VP9VideoExtensions_8wekyb3d8bbwe!App
MicrosoftWindows.Client.CBS_cw5n1h2txyewy!PackageMetadata
MicrosoftWindows.Client.CBS_cw5n1h2txyewy!Global.Accounts
MicrosoftWindows.Client.CBS_cw5n1h2txyewy!Global.AppListBackup
MicrosoftWindows.Client.CBS_cw5n1h2txyewy!Global.FileExplorerExtensions
MicrosoftWindows.Client.CBS_cw5n1h2txyewy!Global.HardwareConfirmator
MicrosoftWindows.Client.CBS_cw5n1h2txyewy!Global.SnapLayout
MicrosoftWindows.Client.CBS_cw5n1h2txyewy!Global.SystemTray
MicrosoftWindows.Client.CBS_cw5n1h2txyewy!Global.Taskbar
MicrosoftWindows.Client.CBS_cw5n1h2txyewy!InputApp
MicrosoftWindows.Client.CBS_cw5n1h2txyewy!Global.IrisService
MicrosoftWindows.Client.CBS_cw5n1h2txyewy!ScreenClipping
MicrosoftWindows.Client.CBS_cw5n1h2txyewy!MiniSearchUI
MicrosoftWindows.Client.CBS_cw5n1h2txyewy!CortanaUI
MicrosoftWindows.Client.CBS_cw5n1h2txyewy!FESearchUI
MicrosoftWindows.Client.CBS_cw5n1h2txyewy!Global.StartMenu
MicrosoftWindows.Client.CBS_cw5n1h2txyewy!Global.ValueBanner
MicrosoftWindows.Client.CBS_cw5n1h2txyewy!WebExperienceHost
MicrosoftWindows.Client.CBS_cw5n1h2txyewy!Global.ExperienceExtensions
MicrosoftWindows.Client.CBS_cw5n1h2txyewy!Global.WsxPackManager
Microsoft.PowerAutomateDesktop_8wekyb3d8bbwe!PAD.Console
Microsoft.RemoteDesktop_8wekyb3d8bbwe!App
Microsoft.ScreenSketch_8wekyb3d8bbwe!App
Microsoft.StorePurchaseApp_8wekyb3d8bbwe!App
Microsoft.WindowsTerminal_8wekyb3d8bbwe!App
Microsoft.WindowsCamera_8wekyb3d8bbwe!App
Microsoft.WindowsAlarms_8wekyb3d8bbwe!App
Microsoft.WindowsCalculator_8wekyb3d8bbwe!App
Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe!App
microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.mail
microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.calendar
microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.manageaccounts
Microsoft.Todos_8wekyb3d8bbwe!App
Microsoft.Windows.Photos_8wekyb3d8bbwe!App
Microsoft.Windows.Photos_8wekyb3d8bbwe!SecondaryEntry
Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe!App
Microsoft.WindowsStore_8wekyb3d8bbwe!App
MicrosoftWindows.Client.WebExperience_cw5n1h2txyewy!PackageMetadata
MicrosoftWindows.Client.WebExperience_cw5n1h2txyewy!App
Microsoft.YourPhone_8wekyb3d8bbwe!App
Microsoft.MicrosoftEdge.Stable_8wekyb3d8bbwe!App
Microsoft.OneDriveSync_8wekyb3d8bbwe!OneDrive
Microsoft.XboxGamingOverlay_8wekyb3d8bbwe!App
```

## 命令行用法

如果要通过命令行启动一个 Windows 商店应用，一般的做法是使用 `explorer.exe` 传入命令行参数进行使用。

> explorer.exe "shell:AppsFolder\你要启动的 Windows 商店应用入口"

## Win32 API 用法

通过 `IApplicationActivationManager` 接口你可以在你的应用程序中优雅的启动一个 Windows 商店应用，代码示例如下。

```
#include <Windows.h>
#include <shobjidl.h>

int main()
{
	HRESULT hr = ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);
	if (SUCCEEDED(hr))
	{
		IApplicationActivationManager* pApplicationActivationManager = nullptr;
		hr = ::CoCreateInstance(
			CLSID_ApplicationActivationManager,
			nullptr,
			CLSCTX_LOCAL_SERVER,
			IID_IApplicationActivationManager,
			(LPVOID*)&pApplicationActivationManager);
		if (SUCCEEDED(hr))
		{
			// This call ensures that the app is launched as the foreground window
			hr = ::CoAllowSetForegroundWindow(
				pApplicationActivationManager, 
				nullptr);
			if (SUCCEEDED(hr))
			{
				DWORD dwProcessId = 0;
				// Launch the app
				hr = pApplicationActivationManager->ActivateApplication(
					L"你要启动的 Windows 商店应用入口",
					nullptr,
					AO_NONE,
					&dwProcessId);
			}

			pApplicationActivationManager->Release();
		}

		::CoUninitialize();
	}

    return hr;
}
```

## 参考文献

- https://docs.microsoft.com/en-us/windows/win32/api/shobjidl_core/nn-shobjidl_core-iapplicationactivationmanager

## 相关内容

{% post_link Windows-Research-Notes %}