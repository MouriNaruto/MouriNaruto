---
title: Compact OS 的使用方法
date: 2021-11-07 00:13:00
categories:
- [技术, Windows, Windows 研究笔记, Compact OS]
tags:
- 技术
- Windows
- Windows 研究笔记
- Compact OS
---

本文归纳并总结 Compact OS 的用法，本文适用于对 Compact OS 感兴趣的用户和开发者。

## 支持的算法

| 算法      | 速度 | 效果（数据摘自Dism++设置对话框） | 备注                                  |
|-----------|------|----------------------------------|---------------------------------------|
| XPRESS4K  | 最快 | 大约节省33%的已用空间            | 默认压缩选项，与WIMBoot使用相同的算法 |
| XPRESS8K  |      | 大约节省36%的已用空间            |                                       |
| XPRESS16K |      | 大约节省38%的已用空间            |                                       |
| LZX       | 最慢 | 大约节省44%的已用空间            | 效果最好，与WIM最大压缩使用相同的算法 |

## 命令行用法

- 使用 DISM 工具以 Compact OS 模式释放系统映像 (需要管理员权限)
  > DISM /Apply-Image /ImageFile:"WIM或ESD映像路径" /Index:"映像号" /ApplyDir:"展开位置，例如D:\" /compact
- 使用 compact 工具查询当前 Windows 映像实例的 Compact OS 状态 (需要管理员权限)
  > compact /CompactOs:query
- 使用 compact 工具启用当前 Windows 映像实例的 Compact OS 模式 (需要管理员权限)
  > compact /CompactOs:always
- 使用 compact 工具禁用当前 Windows 映像实例的 Compact OS 模式 (需要管理员权限)
  > compact /CompactOs:never
- 使用 compact 工具以默认压缩算法对单个文件进行 Compact OS 模式压缩
  > compact /c /exe "文件路径"
- 使用 compact 工具以其他可用算法对单个文件进行 Compact OS 模式压缩
  > compact /c /exe:"算法名" "文件路径"
- 使用 compact 工具对单个以 Compact OS 模式压缩的文件解压缩
  > compact /u /exe "文件路径"

## Win32 API 用法

虽然从 Windows 10 开始微软为开发者提供了文件名为 `Wofutil.dll` 的库用提供了对 WIMBoot 和 Compact OS 操作的简易包装。
但是笔者却不建议开发者使用该库，首先相对于本文接下来要介绍的基于 `DeviceIoControl` 的用法而言在用法上并没有明显简化。
而且 Compact OS 特性其实也是可以通过 Windows ADK 提供的 `wofadk.sys` 在 Windows 7 及之后的 Windows 操作系统中使用，而 
`Wofutil.dll` 这个库只有 Windows 10 及之后的 Windows 版本才开始提供，如果你要写一个支持 Windows 旧版本的操作 Compact OS
的应用，你依然还得有 `DeviceIoControl` API。

基于 `DeviceIoControl` API 用法其实并不复杂，Windows Overlay Filter 驱动在用户模式下提供了以下 I/O 控制码。

- FSCTL_SET_EXTERNAL_BACKING 为特定文件添加 WIMBoot 或 Compact OS 属性
- FSCTL_GET_EXTERNAL_BACKING 获取特定文件的 WIMBoot 或 Compact OS 属性
- FSCTL_DELETE_EXTERNAL_BACKING 移除特定文件的 WIMBoot 或 Compact OS 属性

由于千言万语不如提供一个示例，于是我写了个简单的 C++ 示例以供参考。

```
#include <Windows.h>

#include <iostream>
#include <string>

std::wstring GetMessageByID(DWORD MessageID)
{
	std::wstring MessageString;
	LPWSTR pBuffer = nullptr;

	if (FormatMessageW(
		FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
		nullptr,
		MessageID,
		MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
		reinterpret_cast<LPTSTR>(&pBuffer),
		0,
		nullptr))
	{
		MessageString = std::wstring(pBuffer, wcslen(pBuffer));

		LocalFree(pBuffer);
	}

	return MessageString;
}

int main()
{
	// 设置stl库的全局语言为系统当前语言以避免乱码
	std::locale::global(std::locale(""));

	std::wcout << L"请输入文件路径：";

	std::wstring FileName;
	std::wcin >> FileName;

	// 打开文件并获取文件句柄（使用选项参考系统自带Compact命令行工具实现）
	HANDLE hFile = CreateFileW(
		FileName.c_str(),
		FILE_LIST_DIRECTORY | FILE_READ_ATTRIBUTES,
		FILE_SHARE_READ | FILE_SHARE_DELETE,
		nullptr,
		OPEN_EXISTING,
		FILE_FLAG_BACKUP_SEMANTICS | FILE_FLAG_SEQUENTIAL_SCAN,
		nullptr);
	if (INVALID_HANDLE_VALUE != hFile)
	{
		// 定义一个结构体把两个结构体合并起来以方便使用并定义变量
		struct
		{
			WOF_EXTERNAL_INFO WofInfo;
			FILE_PROVIDER_EXTERNAL_INFO FileProviderInfo;
		} WofCompactInfo = { 0 };

		// 发送IO操作码以调用过滤驱动获取压缩状态
		if (DeviceIoControl(
			hFile,
			FSCTL_GET_EXTERNAL_BACKING,
			nullptr,
			0,
			&WofCompactInfo,
			sizeof(WofCompactInfo),
			nullptr,
			nullptr))
		{
			std::wcout << L"压缩算法：";

			switch (WofCompactInfo.FileProviderInfo.Algorithm)
			{
			case FILE_PROVIDER_COMPRESSION_XPRESS4K:
				std::wcout << L"XPRESS4K";
				break;
			case FILE_PROVIDER_COMPRESSION_LZX:
				std::wcout << L"LZX";
				break;
			case FILE_PROVIDER_COMPRESSION_XPRESS8K:
				std::wcout << L"XPRESS8K";
				break;
			case FILE_PROVIDER_COMPRESSION_XPRESS16K:
				std::wcout << L"XPRESS16K";
				break;
			default:
				std::wcout << L"未知";
				break;
			}

			std::wcout << std::endl;

			wchar_t Option = L'\0';
			std::wcout << L"请问是否解压缩（y/n）：";
			std::wcin >> Option;
			if (Option == L'y')
			{
				// 发送IO操作码以调用过滤驱动执行解压缩操作
				if (DeviceIoControl(
					hFile,
					FSCTL_DELETE_EXTERNAL_BACKING,
					nullptr,
					0,
					nullptr,
					0,
					nullptr,
					nullptr))
				{
					std::wcout << L"文件解压缩成功" << std::endl;
				}
				else
				{
					std::wcout << L"DeviceIoControl FSCTL_DELETE_EXTERNAL_BACKING 调用出错，文件压缩失败" << std::endl;
				}
			}

		}
		else
		{
			std::wcout << L"DeviceIoControl FSCTL_GET_EXTERNAL_BACKING 调用出错，文件可能未经CompactOS压缩或系统不是Windows 10且没有安装WofAdk驱动" << std::endl;

			wchar_t Option = L'\0';
			std::wcout << L"请问是否使用LZX压缩算法压缩（y/n）：";
			std::wcin >> Option;
			if (Option == L'y')
			{
				// 指定过滤驱动版本，现阶段只有该选项
				WofCompactInfo.WofInfo.Version = WOF_CURRENT_VERSION;

				// 指定Provider版本，必须使用该选项
				WofCompactInfo.WofInfo.Provider = WOF_PROVIDER_FILE;

				// 指定Provider版本，现阶段只有该选项
				WofCompactInfo.FileProviderInfo.Version = FILE_PROVIDER_CURRENT_VERSION;

				// 指定选项，必须填0
				WofCompactInfo.FileProviderInfo.Flags = 0;

				// 指定压缩时使用的算法，选项如下
				// FILE_PROVIDER_COMPRESSION_XPRESS4K
				// FILE_PROVIDER_COMPRESSION_LZX
				// FILE_PROVIDER_COMPRESSION_XPRESS8K
				// FILE_PROVIDER_COMPRESSION_XPRESS16K
				WofCompactInfo.FileProviderInfo.Algorithm = FILE_PROVIDER_COMPRESSION_XPRESS4K;

				// 发送IO操作码以调用过滤驱动执行压缩操作
				if (DeviceIoControl(
					hFile,
					FSCTL_SET_EXTERNAL_BACKING,
					&WofCompactInfo,
					sizeof(WofCompactInfo),
					nullptr,
					0,
					nullptr,
					nullptr))
				{
					// 发送IO操作码以调用过滤驱动获取压缩状态
					if (DeviceIoControl(
						hFile,
						FSCTL_GET_EXTERNAL_BACKING,
						nullptr,
						0,
						&WofCompactInfo,
						sizeof(WofCompactInfo),
						nullptr,
						nullptr))
					{
						std::wcout << L"文件压缩成功，压缩算法：";

						switch (WofCompactInfo.FileProviderInfo.Algorithm)
						{
						case FILE_PROVIDER_COMPRESSION_XPRESS4K:
							std::wcout << L"XPRESS4K";
							break;
						case FILE_PROVIDER_COMPRESSION_LZX:
							std::wcout << L"LZX";
							break;
						case FILE_PROVIDER_COMPRESSION_XPRESS8K:
							std::wcout << L"XPRESS8K";
							break;
						case FILE_PROVIDER_COMPRESSION_XPRESS16K:
							std::wcout << L"XPRESS16K";
							break;
						default:
							std::wcout << L"未知";
							break;
						}

						std::wcout << std::endl;
					}
					else
					{
						std::wcout << L"DeviceIoControl FSCTL_GET_EXTERNAL_BACKING 调用出错" << std::endl;
					}
				}
				else
				{
					std::wcout << L"DeviceIoControl FSCTL_SET_EXTERNAL_BACKING 调用出错，文件压缩失败" << std::endl;
				}
			}
		}

		CloseHandle(hFile);
	}
	else
	{
		std::wcout << L"CreateFileW 调用出错：" << GetMessageByID(GetLastError());
	}

	return 0;
}
```

## 移植到旧版 Windows

你并没听错，Compact OS 功能是可以移植到旧版 Windows 的，因为 Windows ADK 下提供了 `wofadk.sys` 以让用户可以在旧版
Windows 操作以 WIMBoot 和 Compact OS 模式压缩过的文件。

鉴于 DISM++ 和无忧启动论坛里的不少工具已经实现该特性且在旧版本 Windows 使用 Compact OS 也存在潜在的系统稳定性风险，
于是以负责任的角度，本文不提供将 Compact OS 移植到旧版 Windows 的方法，但是会提一些旧版 Windows 使用 Compact OS 
的潜在的问题。

首先 `wofadk.sys` 最低支持的 Windows 版本为 Windows 7，所以你并不能在 Windows 7 之前的 Windows 版本譬如 Windows Vista
中使用 Compact OS。

其次 `wofadk.sys` 的实现存在问题，据 DISM++ 作者描述会在 Windows 7 和 Windows 8 下返回从 Windows 8.1 Update 1 
才开始引入的结构体的内容，于是导致在 Windows 7 和 Windows 8 下启用 Compact OS 后系统会莫名其妙的出现蓝屏情况，
于是将 Compact OS 移植到 Windows 8.1 Update 1 开始的 Windows 8.1 版本是稳妥之选。

在旧版 Windows 下由于其他可能不支持 Compact OS 的应用可能并不会以正确的方式处理，于是在旧版本 Windows 下使用
Compact OS 还需要排除更多的文件。

## 参考文献

- [浅谈Windows10的CompactOS特性](https://www.52pojie.cn/thread-528806-1-1.html)
- [Compact OS](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/compact-os)
- [compact.exe](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/compact)
- [Wofapi.h](https://docs.microsoft.com/en-us/windows/win32/api/wofapi)
- [FSCTL_SET_EXTERNAL_BACKING](https://docs.microsoft.com/en-us/windows-hardware/drivers/ifs/fsctl-set-external-backing)
- [FSCTL_GET_EXTERNAL_BACKING](https://docs.microsoft.com/en-us/windows-hardware/drivers/ifs/fsctl-get-external-backing)
- [FSCTL_DELETE_EXTERNAL_BACKING](https://docs.microsoft.com/en-us/windows-hardware/drivers/ifs/fsctl-delete-external-backing)

## 相关内容

- {% post_link The-history-and-principle-of-Compact-OS %}
- {% post_link The-exclusion-list-of-Compact-OS %}
- {% post_link Windows-Research-Notes %}
