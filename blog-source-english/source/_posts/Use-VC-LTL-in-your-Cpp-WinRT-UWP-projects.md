---
title: Use VC-LTL in your C++/WinRT UWP projects
date: 2021-11-25 22:47:44
categories:
- [Technologies, Windows, Windows Research Notes, Development Environment]
tags:
- Technologies
- Windows
- Windows Research Notes
- Development Environment
---

VC-LTL is a build toolchain that allows developers to use the Windows built-in C runtime libraries elegantly. It allows
you to write binaries that only rely on the Windows built-in `msvcrt.dll` or `ucrtbase.dll` for the C runtime library. 
This allows you to achieve the goal of avoiding the deployment of additional MSVC libraries, solving the FLS cap issue 
and reducing the size of the binary significantly.

As an enthusiastic user of VC-LTL and want to ensure that my UWP has no additional dependencies, I have attempted to 
use VC-LTL in my UWP project and surprisingly made it work, so I decided to write an article about it for reference.

Read [here](https://mouri.moe/zh/2021/11/25/Use-VC-LTL-in-your-Cpp-WinRT-UWP-projects/) for the Chinese version of 
this article if you are not good at English. (Translation: 如果你不擅长英文，可以点击本段话中的链接阅读中文版)

## Add VC-LTL to your UWP projects

Since VC-LTL is also released as NuGet package, you just need to install it by searching for VC-LTL in the Manage NuGet
packages in the right click of the project in Visual Studio.

Note: You need to choose 5.0 or later for VC-LTL package.

## Hacking the UWP project configuration

Since UWP projects do not support linking to C runtime by default and the generated application manifest contains 
VCLibs dependencies by default, so we need to do some hacking.

First we need to add `kernel32.lib`, `ole32.lib` and `oleaut32.lib` as additional dependencies in the compiler property
pages for all configurations of all platforms in Visual Studio, Then open the `.vcxproj` configuration file for the UWP
project we need to hack with an editor other than Visual Studio that you are comfortable with, find the 
`PropertyGroup Label="Globals"` node and add `<_VC_Target_Library_Platform> Desktop</_VC_Target_Library_Platform>` to 
allow the MSBuild C++ build toolchain to be handled as a desktop application to resolve the issue of not supporting 
linking to the C runtime library for UWP projects by default.

Then find the `PropertyGroup Label="Globals"` node in the `.vcxproj` configuration file for the UWP project we need to 
hack and add `<UseCrtSDKReference>false</UseCrtSDKReference>` and add the following to the end of the `Project` node to
resolve the issue of generated application manifest contains VCLibs dependencies by default.

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

## Afterword

For developers who want to develop modern Windows applications, the source code of Windows Terminal is really an 
inexhaustible treasure, which involves a lot of magic tricks plus the frustrations from the development team about the
toolchain for developing modern Windows applications.

## References

- [Project website of VC-LTL 5.x](https://github.com/Chuyu-Team/VC-LTL5)
- [Source code repository of Windows Terminal](https://github.com/microsoft/terminal)

## See also

{% post_link Windows-Research-Notes %}
