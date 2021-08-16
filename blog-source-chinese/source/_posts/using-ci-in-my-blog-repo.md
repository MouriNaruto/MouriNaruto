---
title: 在我的博客仓库使用连续集成
date: 2020-12-06 20:50:35
categories:
- [技术, 部署]
tags:
- 部署
- CI
- AppVeyor
---

众所周知，我的这个基于 hexo 的博客是托管在一个 GitHub 仓库之中。

由于每次更新博客都需要自己通过命令行进行手动生成，所以我打算在我的博客仓库引入连续集成以实现自动构建。

一开始，我想参照我的友人落樱的博客仓库的做法，然而他用的连续集成服务我之前并没有注册过。

为了究极的偷懒，于是我去网上搜寻如何使用 AppVeyor 连续集成服务自动构建基于 hexo 的博客的文章。

首先，读者可以通过下述我也参阅过的文章去了解如何使用 AppVeyor 连续集成服务自动构建基于 hexo 的博客。

- [Github Hexo AppVeyor个人博客搭建和持续集成](https://www.jianshu.com/p/58cca2054d80)
- [【Hexo搭建个人博客】（十一）使用Appveyor持续集成博客（备份Hexo博客源文件）](https://blog.csdn.net/Mculover666/article/details/94837390)

毕竟，我也想偷懒，那么我也不会写其他人都会写到的内容。

当然，我也知道，如果不写点与众不同的内容，那么也对不起浪费了宝贵时间更新博客的自己。

于是，我说点我遇到的我看到的文章没有谈到的事情吧。

首先，是 AppVeyor CI 预装的 Node.js 版本过旧的问题，导致我的博客包无法正确编译。

当然，在踩过了一些坑后，解决方案也很简单，可以参阅下述内容就能轻松的解决。

- [Node 12.0 support · Issue #2921 · appveyor/ci](https://github.com/appveyor/ci/issues/2921)
- [fs-admin/appveyor.yml at master · atom/fs-admin](https://github.com/atom/fs-admin/blob/master/appveyor.yml)

其次，我为了更方便的管理我的个人事务，我的博客仓库从 https://github.com/MouriNaruto/MouriNaruto.github.io
迁移到了 https://github.com/MouriNaruto/MouriNaruto/tree/master/blog-source。

毕竟 GitHub 前段日子出了个新特性，在个人的账户下放一个和个人 ID 同名的仓库可以在 GitHub 上显示特定的内容。

我觉得，既然可以这么做，那么我就把和个人介绍有关的全部内容放在这个仓库好了，这也是我这么做的理由。
