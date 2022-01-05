---
title: Use VC-LTL in your Rust projects
date: 2021-11-04 21:02:19
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

Read [here](https://mouri.moe/zh/2021/11/04/Use-VC-LTL-in-your-Rust-projects/) for the Chinese version of 
this article if you are not good at English. (Translation: 如果你不擅长英文，可以点击本段话中的链接阅读中文版)

Since I have contributed the implementation of Rust language support to the VC-LTL 5.x source code repository recently,
see [here](https://github.com/Chuyu-Team/VC-LTL5/pull/11) for details.

So readers of this article can simply add the following to `[dependencies]` in the `Cargo.toml` file.

```
vc-ltl = "5.0.3-Beta1"
```

## For VC-LTL 4.x users

For VC-LTL 4.x users, please read https://github.com/Chuyu-Team/vc-ltl-samples/tree/master/RustDemo.

Since VC-LTL 5.x has been released, readers are strongly encouraged to upgrade to VC-LTL 5.x.

## References

- [Project website of VC-LTL 5.x](https://github.com/Chuyu-Team/VC-LTL5)
- [Specifying dependencies from crates.io](https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html#specifying-dependencies-from-cratesio)

## See also

{% post_link Windows-Research-Notes %}
