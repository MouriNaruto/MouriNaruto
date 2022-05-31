---
title: 关于为 C++ 项目选择 UI 框架的建议
date: 2022-05-31 20:27:22
categories:
- [技术, C++, 开发, 体验]
tags:
- 技术
- C++
- 开发
- 体验
---

为 C++ 项目选择 UI 框架，我的建议是这样的：

- 仅支持 Windows
  - 现代用户体验：XAML Islands (Windows Runtime XAML) 和 Windows UI Library 2 的组合
  - 支持传统平台：Qt (需要自绘界面)，WTL (需要小巧体积)
- 需要跨平台支持
  - 商业应用开发：Qt (需要自绘界面)，wxWidgets (可以原生控件)
  - 嵌入式设备：LVGL
 
估计不少人看到我的上述建议会表示很疑惑和持保留意见，所以我得说明下这样建议的理由。

如果仅需要支持 Windows 的话，我推荐的 UI 框架组合都可以进行商业应用开发。

有些人可能会疑惑，既然要在 Windows 下提供现代用户体验，为什么没有建议使用 Windows UI Library 3 (Windows App SDK)，
这的确是个好问题，我以目前的 Windows App SDK 最新稳定版即 1.0.x 为例子说下自己的理由：

- 目前来看 Windows App SDK 系统不自带且不支持自包含部署方式，额外安装运行库在用户部署方面是极其容易翻车的。
- 现阶段 Windows App SDK 的功能有所缺失，譬如不支持 Mica 画刷、MediaElement 控件、Map 控件等。
- Windows App SDK 需要占用 60MB 的磁盘空间，即使之后的版本支持自包含部署，这个体积也会让人觉得用 Web 套壳都无所谓了。
- Windows App SDK 团队那群人想搞敏捷开发，希望探索不保证二进制兼容的情况。
- Windows UI Library 3 没有和 Win32 HWND 控件交互的靠谱方式，需要使用 Windows 未公开且虚函数表经常改变的接口。
  如果有兴趣可以参阅：https://imbushuo.net/blog/archives/1010/
- Windows 11 当前 Insider Preview (Build 22621 和 Build 25xxx) 并未出现使用 Windows App SDK 构建的系统级组件。

鉴于上述情况，个人目前不推荐 Windows App SDK，如果需要现代用户体验，还是选择 XAML Islands 那套比较好。虽然 XAML Islands
坑也很多，譬如 ContentDialog 无法接受输入，但是由于其暴露 XAML 内容对应的 HWND，于是自然可以和其他 Win32 HWND 控件组合。
而且 Windows Runtime XAML 系统内置，于是不需要考虑太多额外部署问题，毕竟 Windows UI Library 2 开源可把代码扒来用。

由于 XAML Islands 和 Windows App SDK 最低系统要求是 Windows 10 Version 1809，所以对于需要支持传统平台的开发者并不适合。
于是对于需要支持传统平台的开发者，我更建议使用 Qt，除非你需要写体积特别小巧的应用，那种情况还是用 WTL 比较好。

Linux 平台的话，Qt 和 wxWidgets 相对都比较靠谱，只不过 wxWidgets 使用原生控件对于需要原生控件体验的开发者更加友好。

嵌入式的话，我建议用 LVGL，作为 LVGL 的 Windows 模拟器源代码的维护者来说，LVGL 还是挺不错的。

希望上述信息能够帮到你们，感谢阅读。
