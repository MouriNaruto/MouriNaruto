---
title: 使用 MSVC 工具链进行并行编译的技巧
date: 2021-11-14 00:37:29
categories:
- [技术, Windows, Windows 研究笔记, 开发环境]
tags:
- 技术
- Windows
- Windows 研究笔记
- 开发环境
---

昨天和 vczh 在群内聊了下 MSVC 并行编译的事情，我本为验证他的说法，结果发现自己的配置缺少部分内容而无法充分并行编译。
虽然在自己的工具链已经做了相关补充，但为了让包括自己在内的更多人能有一个靠谱的参考，于是写下本文。

MSVC 工具链一般情况下使用 MSBuild 工具来生成解决方案和项目，为 MSBuild 开启并行则可以同时生成多个项目，
为 MSVC 编译器开启并行则可以同时生成多个编译单元。

## 为 C/C++ 编译器开启并行

为 C/C++ 编译器开启并行支持，使得 MSBuild 在编译单个目标的时候也能尽可能并行。开启方式有以下几种：

- 在你想要修改的目标的编译器命令行选项中加入 `/MP` 参数。
  可参阅：https://docs.microsoft.com/en-us/cpp/build/reference/mp-build-with-multiple-processes?WT.mc_id=WDIT-MVP-5004706
- 在 Visual Studio 项目属性你想要修改的目标的 `C/C++` 的 `常规` 页中启用 `多处理器编译` 项。
  ![启用方式](EnableParallelForCompiler.png)
- 打开 vcxproj 文件，在你想要修改的目标的 `ClCompile` 节点中加入 `MultiProcessorCompilation`
  并把值设为 `true` 后并保存。
  示例：https://github.com/ProjectMile/Mile.Cpp/blob/efcd4ec99eede1698d5d6fc05347cc1598987ad8/Mile.Cpp/Mile.Project/Mile.Project.props#L119

## 为 MSBuild 开启并行

由于直接用 MSBuild 命令行编译自己的解决方案只能生成单个目标（一般来说是 x86 Debug 目标）下的全部项目，
而 Windows 下的项目一般需要支持多个目标（一般来说是 Debug 和 Release 配置下的 x86, x64, arm64 目标），
于是需要写一个 prop 配置文件来实现一次性编译自己想要的全部目标，prop 文件参考如下。

```
<Project 
  DefaultTargets="Restore;Build"
  xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <PropertyGroup>
    <SolutionPath>$(MSBuildThisFileDirectory)*.sln</SolutionPath>
  </PropertyGroup>
  <ItemGroup>
    <ProjectReference Include="$(SolutionPath)">
      <AdditionalProperties>Configuration=Debug;Platform=x86</AdditionalProperties>   
    </ProjectReference>
    <ProjectReference Include="$(SolutionPath)">
      <AdditionalProperties>Configuration=Release;Platform=x86</AdditionalProperties>   
    </ProjectReference>
    <ProjectReference Include="$(SolutionPath)">
      <AdditionalProperties>Configuration=Debug;Platform=x64</AdditionalProperties>   
    </ProjectReference>
    <ProjectReference Include="$(SolutionPath)">
      <AdditionalProperties>Configuration=Release;Platform=x64</AdditionalProperties>   
    </ProjectReference>
    <ProjectReference Include="$(SolutionPath)">
      <AdditionalProperties>Configuration=Debug;Platform=ARM64</AdditionalProperties>   
    </ProjectReference>
    <ProjectReference Include="$(SolutionPath)">
      <AdditionalProperties>Configuration=Release;Platform=ARM64</AdditionalProperties>   
    </ProjectReference>
  </ItemGroup>
  <Target Name="Restore" >
    <MSBuild
      Projects="@(ProjectReference)"
      Targets="Restore"
      StopOnFirstFailure="True"
      Properties="PreferredToolArchitecture=x64" />
  </Target>
  <Target Name="Build" >
    <MSBuild
      Projects="@(ProjectReference)"
      Targets="Build"
      BuildInParallel="True"
      StopOnFirstFailure="True"
      Properties="PreferredToolArchitecture=x64" />
  </Target>
  <Target Name="Rebuild" >
    <MSBuild
      Projects="@(ProjectReference)"
      Targets="Rebuild"
      BuildInParallel="True"
      StopOnFirstFailure="True"
      Properties="PreferredToolArchitecture=x64" />
  </Target>
</Project>
```

然后使用 MSBuild 命令行加上 `-m` 参数编译你写好的 prop 配置文件就可以使 MSBuild 真正的并行起来了。

## 相关内容

{% post_link Windows-Research-Notes %}
