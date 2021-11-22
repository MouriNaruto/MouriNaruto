---
title: 在你的 Rust 项目中使用 VC-LTL
date: 2021-11-04 21:02:19
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

由于笔者前段日子已在 VC-LTL 5.x 的源代码仓库中贡献了 Rust 语言支持的实现，
详情可参见 https://github.com/Chuyu-Team/VC-LTL5/pull/11。

于是看到本文的读者只需要在 `Cargo.toml` 文件内 `[dependencies]` 中加入以下内容即可达成目的。

```
vc-ltl = "5.0.3-Beta1"
```

## VC-LTL 4.x 用户

对于还在使用 VC-LTL 4.x 的用户，请参阅 https://github.com/Chuyu-Team/vc-ltl-samples/tree/master/RustDemo。

当然由于 VC-LTL 5.x 已经发布，于是强烈建议读者能够升级到 VC-LTL 5.x。

## 参考文献

- [VC-LTL 5.x 项目地址](https://github.com/Chuyu-Team/VC-LTL5)
- [Specifying dependencies from crates.io](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html#specifying-dependencies-from-cratesio)

## 相关内容

{% post_link Windows-Research-Notes %}
