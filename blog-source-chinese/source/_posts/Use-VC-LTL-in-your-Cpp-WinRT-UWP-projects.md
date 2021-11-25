---
title: 在你的 C++/WinRT UWP 项目中使用 VC-LTL
date: 2021-11-25 22:47:44
categories:
- [技术, Windows, Windows 研究笔记, 开发环境]
tags:
- 技术
- Windows
- Windows 研究笔记
- 开发环境
---

VC-LTL 是一套可以让开发者优雅的使用 Windows 内置的 C 运行时库的编译工具链，
可使你编写的二进制在 C 运行库方面仅依赖 Windows 内置的 `msvcrt.dll` 或 `ucrtbase.dll`，
以达成无需额外部署 MSVC 运行库、解决 FLS 上限问题和大大缩减二进制体积的目标。

作为 VC-LTL 的忠实用户，同时也希望让自己的 UWP 实现零额外依赖，于是试着在 UWP 项目中用了下 VC-LTL
并意外的做成了这件事，遂写一篇文章记录下来供人参考。

## 添加 VC-LTL 到你的 UWP 项目

由于现在 VC-LTL 也发布 NuGet 包，于是只需要在 Visual Studio 中项目右键的管理 NuGet 程序包中搜索 VC-LTL 安装即可。

注：VC-LTL 的版本需要选择 5.0 之后的版本。

## 魔改 UWP 项目配置

由于 UWP 项目默认不支持与 C 运行库静态链接且默认生成的应用清单会包含 VCLibs 的依赖，于是咱们需要做一些魔改。

首先我们需要在 Visual Studio 中把项目的所有配置的所有平台的编译器属性页的附加依赖项添加 `kernel32.lib`, `ole32.lib` 和
`oleaut32.lib`，之后使用 Visual Studio 之外的你用得顺手的编辑器打开我们需要魔改的 UWP 项目对应的 `.vcxproj` 配置文件，
找到 `PropertyGroup Label="Globals"` 节点添加 `<_VC_Target_Library_Platform>Desktop</_VC_Target_Library_Platform>`
以让 MSBuild C++ 编译工具链以桌面应用的方式处理以解决 UWP 项目默认不支持与 C 运行库静态链接的问题。

然后在我们需要魔改的 UWP 项目对应的 `.vcxproj` 配置文件中找到 `PropertyGroup Label="Globals"` 节点添加
`<UseCrtSDKReference>false</UseCrtSDKReference>` 和在 `Project` 节点的末尾添加以下内容以解决默认生成的应用清单会包含
VCLibs 的依赖的问题。

```
  <!-- ## BEGIN HACK - Removing Microsoft.VCLibs Packages ## -->
  <!--
    Reference: https://github.com/microsoft/terminal
               /blob/a89c3e2f8527a51b39768980627ed8f7c1ea5f0b
               /src/cascadia/CascadiaPackage/CascadiaPackage.wapproj#L125
  -->
  <!-- 
    For our builds, we're just using VC-LTL to compile the project and delete
    the package dependencies. We don't want to rely on the Microsoft.VCLibs 
    packages. Because it's very difficult for users who do not have access to 
    the store to get our dependency packages, and we want to be robust and 
    deployable everywhere.
  -->
  <!--
    This target removes the FrameworkSdkReferences from before the AppX package
    targets manifest generation happens. This is part of the generic machinery 
    that applies to every AppX. 
  -->
  <Target Name="_StripAllDependenciesFromPackageFirstManifest" BeforeTargets="_GenerateCurrentProjectAppxManifest">
    <ItemGroup>
      <FrameworkSdkReference Remove="@(FrameworkSdkReference)" />
    </ItemGroup>
  </Target>
  <!--
    This target removes the FrameworkSdkPackages from before the *desktop 
    bridge* manifest generation happens. 
  -->
  <Target Name="_StripAllDependenciesFromPackageSecondManifest" BeforeTargets="_GenerateDesktopBridgeAppxManifest" DependsOnTargets="_ResolveVCLibDependencies">
    <ItemGroup>
      <FrameworkSdkPackage Remove="@(FrameworkSdkPackage)" />
    </ItemGroup>
  </Target>
  <!-- ## END HACK - Removing Microsoft.VCLibs Packages ## -->
```

## 后记

上述方法的诞生离不开 Windows Terminal 源代码的实现，对于有志于开发现代 Windows 应用的朋友，
Windows Terminal 的源代码真的是一个取之不尽用之不竭的大宝藏，里面涉及到很多的魔改技巧，
也有开发团队对现代 Windows 应用开发工具链的无奈和吐槽。

## 参考文献

- [VC-LTL 5.x 项目地址](https://github.com/Chuyu-Team/VC-LTL5)
- [Windows Terminal 源代码仓库](https://github.com/microsoft/terminal)

## 相关内容

{% post_link Windows-Research-Notes %}
