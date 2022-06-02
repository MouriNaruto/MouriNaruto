---
title: 使用 GitHub 仓库托管符号服务器
date: 2022-02-06 22:11:22
categories:
- [技术, Windows, Windows 应用, 开发, 体验]
tags:
- 技术
- Windows
- Windows 应用
- 开发
- 体验
---

按照 Windows 调试符号服务器搭建的相关文档，在 GitHub 上做了个模板。

模板地址：https://github.com/ProjectMile/Mile.LocalSymbolStoreTemplate

## 笔者本意

做这个模板本来是因为初雨技术群的猫总提到了可以自己搭建符号服务器，于是个人觉得也许可以白嫖一下 GitHub。
这样就能给自己的开源项目搞一个公共符号服务器，在每次发布新版本的时候就可以不用附带调试符号了。

## 实际情况

不可行，因为以下原因：

- 如果使用 GitHub LFS 存储服务，价格挺贵的，每 50GB 需要每月支付 5 美元
- 如果不使用 GitHub LFS 存储服务，单个文件无法超过 100MB 而且 Git 仓库不擅长处理大型文件
- 使用 Gitee 或者 GitLab 也有类似的问题

## 适用人群

- 搭建本地符号服务器的朋友
- 在自建带 Web 前端的 Git 服务器上搭建符号服务器的朋友
- 单个符号文件不超过 100MB 或者能够负担 GitHub LFS 存储服务价格的朋友

## 结尾

总之，希望能有人因此能够得到帮助，感谢阅读。

## 参考文献

- [Using SymStore - Win32 apps | Microsoft Docs](https://docs.microsoft.com/en-us/windows/win32/debug/using-symstore?WT.mc_id=WDIT-MVP-5004706)
