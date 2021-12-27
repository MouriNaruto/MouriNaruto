---
title: The way to submit a headless app to the Microsoft Store
date: 2021-12-27 11:44:59
categories:
- [Technologies, Windows, Windows Apps, Development, Experience]
tags:
- Technologies
- Windows
- Windows Apps
- Development
- Experience
---

When I was developing [NanaZip](https://github.com/M2Team/NanaZip), I had met the error when I upload my MSIX package
to the Microsoft Store. Here is the error message.

> Package acceptance validation error: The package file NanaZipPackage_1.0.18.0_ARM64.msix specifies a headless app.
  You don't have permission to create a headless app. Please update AppListEntry="none" in the AppxManifest file and 
  also ensure you have the waiver "HeadlessAppBypass" associated to this app. 

Set `AppListEntry="none"` for the entries of command line version of NanaZip is necessary because it's not a good user
experience when showing the entries of command line version of NanaZip to the Start menu. So, this is why the command 
line version wasn't included in NanaZip 1.0 Preview 1.

A good guy called [be5invis](https://github.com/be5invis) has created the issue for suggesting NanaZip should expose 
execution alias of command line version. I told him why I wasn't able to do that and he gave me a solution. So, The 
command line version of NanaZip has been finally added in 1.0 Preview 2.

## Solution

To request the HeadlessAppBypass waiver, send an email to `storeops@microsoft.com` with the app ID (12 character token
available from the dashboard). The waiver needs to be applied *before* uploading the package (as of December 2021).

When the progress is successful, you will receive the reply with the following words.

> Thank you for contacting us. We have enabled the HeadlessAppBypass waiver for the requested product.

## Afterword

You can read the original solution [here](https://github.com/M2Team/NanaZip/issues/4#issuecomment-929720303). It's 
[originally](https://github.com/python/cpython/blob/main/PC/store_info.txt) used in the Microsoft Store version of 
Python. I have do some revisions for accelerating the progress.

I hope the article can give some help for Windows desktop app developers. Thanks for reading.
