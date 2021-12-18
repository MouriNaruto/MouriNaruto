---
title: 使用 VC-LTL 构建 Qt 6
date: 2021-11-23 18:43:04
categories:
- [技术, Windows, Windows 研究笔记, 开发环境]
tags:
- 技术
- Windows
- Windows 研究笔记
- 开发环境
---

上个礼拜和友人 [wangwenx190](https://github.com/wangwenx190) 请教如何在使用 VC-LTL 工具链的情况下编译 Qt 6 源代码，
然后进行了数个小时的讨论，虽然有很大的进展，但是 Qt 6 的 configure.bat 的 --debug-and-release 模式不能用，我由于不怎么用
CMake 于是束手无策，几天后友人给 VC-LTL 捣鼓了个 PR 解决了这个问题，遂笔者将相关做法整理成本文。

如果你不擅长中文，可以[点此](https://mourinaruto.github.io/en/2021/11/23/Build-Qt-6-with-VC-LTL/)阅读英文版。
(翻译: If you are not good at Chinese, you can click on the link in this paragraph to read the English version.)

本文假设你已经配置好了编译 Qt 6 源代码的基本环境，毕竟本文主要目的是介绍如何在编译 Qt 6 源代码的时候使用 VC-LTL 
来使你编译的 Qt 6 的二进制在 C 运行库方面仅依赖 Windows 内置的 `msvcrt.dll` 或 `ucrtbase.dll` 以达成无需额外部署
MSVC 运行库的目标。

首先你需要去 https://github.com/Chuyu-Team/VC-LTL5/releases 下载最新版本的 VC-LTL 二进制包 (譬如撰写本文的时候最新版本
VC-LTL 的二进制包文件名为 `VC-LTL-5.0.3-Beta1-Binary.7z`) 并解压到最好路径只有英文字符的目录 (本文的例子是 
`C:\Tools\VC-LTL`) ，并执行解压目录内的 `Install.cmd` 将 VC-LTL 的工具链目录注册入系统。

然后根据 [wangwenx190 给 VC-LTL 捣鼓的 PR](https://github.com/Chuyu-Team/VC-LTL5/pull/14) 对 VC-LTL 工具链目录的 
`config/config.cmake` 进行相应修改，即查找该文件中的第 19 行，如果发现下述内容后直接去掉并保存即可。

```
if(${SupportLTL} STREQUAL "true")
	if(NOT CMAKE_BUILD_TYPE)
		message(WARNING "VC-LTL not load, because CMAKE_BUILD_TYPE is not defined!!!")
		set(SupportLTL "false")
	endif()
endif()
```

接着将 VC-LTL 工具链目录的 `VC-LTL helper for cmake.cmake` 文件拷贝到 Qt 源代码目录的 `qtbase/cmake/` 子目录下并重命名为
`VC-LTL.cmake`，并在 `qtbase/cmake/QtBuild.cmake` 的末尾添加下述内容并保存。

```
set(WindowsTargetPlatformMinVersion 10.0.10240.0 CACHE STRING "" FORCE)
set(CleanImport "true" CACHE STRING "" FORCE)

include(VC-LTL)

if(MSVC)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>" CACHE STRING "" FORCE)
endif()
```

然后你就可以按照 Qt 6 官方的编译教程去编译使用了 VC-LTL 工具链的 Qt 6 二进制了，顺便附上我的 Qt 6 编译命令。

```
"C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64
set PATH=%~dp0qtbase\bin;%PATH%
mkdir output\x64
cd output\x64
call ..\..\configure.bat -prefix "C:\Workspace\Qt\6.2.1\msvc2019_64" -debug-and-release -platform win32-msvc -opensource -confirm-license -shared -nomake examples -nomake tests -no-openssl -no-opengl -plugin-sql-sqlite -qt-zlib -qt-libpng -qt-libjpeg -mp -skip qt3d -skip qt5compat -skip qtcharts -skip qtcoap -skip qtconnectivity -skip qtdatavis3d -skip qtdeclarative -skip qtdoc -skip qtlocation -skip qtlottie -skip qtmqtt -skip qtmultimedia -skip qtnetworkauth -skip qtopcua -skip qtquick3d -skip qtquicktimeline -skip qtremoteobjects -skip qtscxml -skip qtsensors -skip qtserialbus -skip qtserialport -skip qtshadertools -skip qtvirtualkeyboard -skip qtwebchannel -skip qtwebengine -skip qtwebsockets -skip qtwebview
ninja
ninja install
```

希望大家把玩 Qt 6 的时候能够顺利一些，感谢阅读。

## 2021 年 12 月 2 日勘误记录

由于在 `qtbase/cmake/QtBuild.cmake` 的末尾添加下述内容并不能使 Qt6 完全静态链接到 MSVC 运行时。

```
include(VC-LTL)

set(CompilerFlags
	CMAKE_CXX_FLAGS
	CMAKE_CXX_FLAGS_DEBUG
	CMAKE_CXX_FLAGS_RELEASE
	CMAKE_CXX_FLAGS_MINSIZEREL
	CMAKE_CXX_FLAGS_RELWITHDEBINFO
	CMAKE_C_FLAGS
	CMAKE_C_FLAGS_DEBUG
	CMAKE_C_FLAGS_RELEASE
	CMAKE_C_FLAGS_MINSIZEREL
	CMAKE_C_FLAGS_RELWITHDEBINFO)
foreach(CompilerFlag ${CompilerFlags})
	string(REPLACE "/MD" "/MT" ${CompilerFlag} "${${CompilerFlag}}")
    string(REPLACE "/MDd" "/MTd" ${CompilerFlag} "${${CompilerFlag}}")
endforeach()
```

在友人 wangwenx190 的帮助下，把该部分修改为下述内容问题解决。因为在决定是否静态链接到 MSVC 
运行时的时候，需要以 CACHE 和 FORCE 方式设置 CMake 提供的选项达到预期目的。

```
include(VC-LTL)

if(MSVC)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>" CACHE STRING "" FORCE)
endif()
```

由于 Qt 6 在 Windows 平台最低支持版本是 Windows 10, Version 1809，于是可以设置 VC-LTL 工具链的运行库功能级别为
`10.0.10240.0` 以获取更加精巧的体积，于是该部分继续修改为下述内容。

```
set(WindowsTargetPlatformMinVersion 10.0.10240.0 CACHE STRING "" FORCE)
set(CleanImport "true" CACHE STRING "" FORCE)

include(VC-LTL)

if(MSVC)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>" CACHE STRING "" FORCE)
endif()
```

## 相关内容

{% post_link Windows-Research-Notes %}
