---
title: Build Qt 6 with VC-LTL
date: 2021-11-23 18:43:04
categories:
- [Technologies, Windows, Windows Research Notes, Development Environment]
tags:
- Technologies
- Windows
- Windows Research Notes
- Development Environment
---

Last week I talked with my friend [wangwenx190](https://github.com/wangwenx190) for some advice on compiling Qt 6 
source code with the VC-LTL toolchain. After several hours of discussions, I made a lot of progress, but the 
--debug-and-release mode of Qt 6's configure.bat didn't work, and I was stuck because I don't use CMake very often.
A few days later, my friend gave VC-LTL a PR to resolve the issue, so I summarized the approach in this article.

Read [here](https://mouri.moe/zh/2021/11/23/Build-Qt-6-with-VC-LTL/) for the Chinese version of 
this article if you are not good at English. (Translation: 如果你不擅长英文，可以点击本段话中的链接阅读中文版)

This article assumes that you have already configured a basic environment for compiling Qt 6 source code, because the
main purpose of this article is to describe how to compile Qt 6 source code with VC-LTL to make your compiled Qt 6
binaries only rely on the Windows built-in `msvcrt.dll` or `ucrtbase.dll` as the C runtime library for achieving the 
goal of deploying without additional MSVC runtime library.

First you need to download the latest version of VC-LTL binary package from 
https://github.com/Chuyu-Team/VC-LTL5/releases ( the latest version of VC-LTL is named `VC-LTL-5.0.3-Beta1-Binary.7z`
at the time of writing this article for example) and Unzip the package to a directory with only English characters 
( `C:\Tools\VC-LTL` in this example) and run `Install.cmd` in the extracted directory to register the directory of 
VC-LTL's toolchain to the system.

Then modify `config/config.cmake` in the VC-LTL toolchain directory according to 
[wangwenx190's PR for VC-LTL](https://github.com/Chuyu-Team/VC-LTL5/pull/14), i.e. find line 19 in that file. If you
find the following, just remove them and save the file.

```
if(${SupportLTL} STREQUAL "true")
	if(NOT CMAKE_BUILD_TYPE)
		message(WARNING "VC-LTL not load, because CMAKE_BUILD_TYPE is not defined!!!")
		set(SupportLTL "false")
	endif()
endif()
```

Then copy the `VC-LTL helper for cmake.cmake` file from the VC-LTL toolchain directory to the `qtbase/cmake/` 
subdirectory of the Qt source code directory and rename it to `VC-LTL.cmake`, and add the following to the end of 
`qtbase/cmake/QtBuild.cmake` and save the below content.

```
set(WindowsTargetPlatformMinVersion 10.0.10240.0 CACHE STRING "" FORCE)
set(CleanImport "true" CACHE STRING "" FORCE)

include(VC-LTL)

if(MSVC)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>" CACHE STRING "" FORCE)
endif()
```

Then you can follow the official Qt 6 build tutorial to build the Qt 6 binaries with the VC-LTL toolchain, with my Qt
6 build commands listed by the way.

```
"C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64
set PATH=%~dp0qtbase\bin;%PATH%
mkdir output\x64
cd output\x64
call ..\..\configure.bat -prefix "C:\Workspace\Qt\6.2.1\msvc2019_64" -debug-and-release -platform win32-msvc -opensource -confirm-license -shared -nomake examples -nomake tests -no-openssl -no-opengl -plugin-sql-sqlite -qt-zlib -qt-libpng -qt-libjpeg -mp -skip qt3d -skip qt5compat -skip qtcharts -skip qtcoap -skip qtconnectivity -skip qtdatavis3d -skip qtdeclarative -skip qtdoc -skip qtlocation -skip qtlottie -skip qtmqtt -skip qtmultimedia -skip qtnetworkauth -skip qtopcua -skip qtquick3d -skip qtquicktimeline -skip qtremoteobjects -skip qtscxml -skip qtsensors -skip qtserialbus -skip qtserialport -skip qtshadertools -skip qtvirtualkeyboard -skip qtwebchannel -skip qtwebengine -skip qtwebsockets -skip qtwebview
ninja
ninja install
```

I hope everyone has a smooth experience with Qt 6, thanks for reading.

## See also

{% post_link Windows-Research-Notes %}
