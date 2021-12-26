---
title: Set Windows Application Packaging project with multiple referenced projects to a common output folder
date: 2021-12-26 23:24:59
categories:
- [Technologies, Windows, Windows Apps, Development, Experience]
tags:
- Technologies
- Windows
- Windows Apps
- Development
- Experience
---

When I was developing [NanaZip](https://github.com/M2Team/NanaZip), I found if my Windows Application Packaging project
with multiple referenced projects, it will output to the separate folder with the names of the referenced projects. 

It's really annoying me, and I had try to find a solution.

First, I found [the same issue I have in Stack Overflow](https://stackoverflow.com/questions/62853610), and I tried to 
use the way in the answer for solving the issue, but it doesn't work if we want to reference some Windows Runtime 
components.

But I know the Windows Terminal is the project with multiple referenced projects and it will output to a common folder.
So, I had taken a good look at the source code of Windows Terminal and found the way to solve the issue. 

## Solution

Add the following to the end of the `Project` node to resolve the issue.

```
  <!-- ## BEGIN HACK - Put all output files to the AppX root folder ## -->
  <!--
    Reference: https://github.com/microsoft/terminal
               /blob/a89c3e2f8527a51b39768980627ed8f7c1ea5f0b
               /src/cascadia/CascadiaPackage/CascadiaPackage.wapproj#L73
  -->
  <!-- 
    For our builds, we want to put all output files to the AppX root folder for
    simplifying the implementation.
  -->
  <Target Name="MileProjectStompSourceProjectForWapProject" BeforeTargets="_ConvertItems">
    <ItemGroup>
      <!--
        Stomp all "SourceProject" values for all incoming dependencies to 
        flatten the package. 
      -->
      <_TemporaryFilteredWapProjOutput Include="@(_FilteredNonWapProjProjectOutput)" />
      <_FilteredNonWapProjProjectOutput Remove="@(_TemporaryFilteredWapProjOutput)" />
      <_FilteredNonWapProjProjectOutput Include="@(_TemporaryFilteredWapProjOutput)">
        <!--
        Blank the SourceProject here to vend all files into the root of the
        package.
      -->
        <SourceProject>
        </SourceProject>
      </_FilteredNonWapProjProjectOutput>
    </ItemGroup>
  </Target>
  <!-- ## END HACK - Put all output files to the AppX root folder ## -->
```

## Afterword

It's a really disgusting issue for developers. But the Microsoft won't fix that. The discussion can be found 
[here](https://developercommunity.visualstudio.com/t/1110232).

> As you can imagine there is a reason that we do this and the primary concern is duplicate filenames as well as some
  issues with uploading to the store. As of now there is no override that we provide that will allow you to achieve 
  this although there are some hacks you could do to make it possible but it is not advised.​ (By Scoban [MSFT])

The development team of Windows Terminal has made some hacking to MSBuild Windows Application Packaging project targets
for achieving the goal. I am proud I can find it and solve the issue when I am developing NanaZip.

I hope the article can give some help for Windows desktop app developers. Thanks for reading.
