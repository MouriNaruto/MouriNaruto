---
title: 使 XAML Islands 托管的 UWP XAML 内容响应 Windows 明暗主题的更改
date: 2022-04-16 17:43:25
categories:
- [技术, Windows, Windows 应用, 开发, 体验]
tags:
- 技术
- Windows
- Windows 应用
- 开发
- 体验
---

在微软的 XAML Islands 的[官方文档](https://docs.microsoft.com/en-us/windows/apps/desktop/modernize/xaml-islands)中表明
由 XAML Islands 托管的 UWP XAML 内容不支持响应 Windows 明暗主题的更改且没有变通方案，即文档中 `Limitations and 
workarounds` 的 `Not supported` 描述的 `UWP XAML content in XAML Islands doesn't respond to Windows theme changes from 
dark to light or vice versa at run time. Content does respond to high contrast changes at run time.`。

然而 Windows Terminal 不仅使用了 XAML Islands 而且还能完美响应 Windows 明暗主题的更改，于是激发了我的好奇心。经过我一段
时间的研究成功解决了该问题并且总结了一些事项以供参考。

## 事项

首先，的确只能修改控件的明暗主题属性，而不能修改全局的明暗控件属性。即继承了 `Windows.UI.Xaml.Application` 的对象的 
`RequestedTheme` 属性是不支持初始化后再次修改的，而继承了 `Windows.UI.Xaml.FrameworkElement` 的对象的 `RequestedTheme` 
属性是支持运行时修改。

其次，如果直接修改继承了 `Windows.UI.Xaml.FrameworkElement` 的对象的 `RequestedTheme` 属性的值为 `Dark` 或者 `Light` 且
没有使用 Windows UI Library 2 这类再次定义了 UWP XAML 或 Windows Runtime XAML 控件风格的增强控件库，则可能会出现一些奇怪
的显示效果，譬如你的 Windows 实例从明色主题切换到暗色主题，你会发现你的基于 XAML Islands 的应用的背景色没有变成暗色主题
的背景色，而控件配色切换到了暗色主题，于是你会发现你屏幕上 XAML Islands 托管的内容是全白的。倒是如果当系统明暗主题变更
以后，如果修改继承了 `Windows.UI.Xaml.FrameworkElement` 的对象的 `RequestedTheme` 属性的值为 `Default`，则可以正常跟随
系统的明暗主题配置。

2022 年 5 月 7 日更新：经过实际测试，通过设置继承了 `Windows.UI.Xaml.FrameworkElement` 的对象的 `RequestedTheme` 属性的
值为 `Default` 来切换明暗主题需要 Windows 11 及之后版本。Windows Terminal 如果指定跟随系统主题的话，也必须得 Windows 11
及之后版本才支持动态跟随系统的明暗主题设置。

当然，如果你要问运行时阶段什么情况下需要响应 Windows 的明暗主题变换呢，我个人是推荐在托管了 XAML Islands 内容的父窗口收
到 `WM_SETTINGCHANGE` 消息后进行明暗主题的变更。虽然你也可以搞个 100 毫秒响应一次的定时器里面都设置一次相关内容，这也是
Windows Terminal 的做法，然而我感觉还是太暴力了。

## 总结

- 当 Windows 进行明暗主题变更以后会向所有窗口发送 `WM_SETTINGCHANGE` 消息，应用可以在此时进行明暗主题变更。
- 使用了 XAML Islands 的应用，在明暗主题变更的情况需要对所有的由 `Windows.UI.Xaml.Hosting.DesktopWindowXamlSource` 托管
  的控件的 `RequestedTheme` 属性（你托管的内容应该都继承了 `Windows.UI.Xaml.FrameworkElement`）进行合理的修改。
- 如果只需要跟随系统的明暗主题，那么 `RequestedTheme` 属性仅需要设置为 `Default`，如果应用明暗主题与系统明暗主题设置不
  一致，则需要在切换后设置合适的背景色，或者可以直接上 Windows UI Library 2 这类再次定义了 UWP XAML 或 Windows Runtime 
  XAML 控件风格的增强控件库。

## 示例

欢迎关注笔者的 [Mile.Xaml](https://github.com/ProjectMile/Mile.Xaml) 项目，这是一个正在开发中的面向用 C++ 编写基于 XAML
Islands 的项目使用的轻量级工具链，提供媲美传统 UWP 开发的开发体验（单 exe 项目，不是 XAML Islands 官方示例的 exe 加载器
和 dll 本体的组合，也支持 XAML 热重载）和仅对 Windows Runtime 支持的控件提供 Windows 11 现代风格。本文的内容也主要是为
了开发这个项目而孕育的。

## 结尾

总之，希望能有人因此能够得到帮助，感谢阅读。
