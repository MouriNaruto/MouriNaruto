---
title: Programming steps for launching an app with TrustedInstaller access token
date: 2022-03-28 23:24:22
categories:
- [Technologies, Windows, Windows Apps, Development, Experience]
tags:
- Technologies
- Windows
- Windows Apps
- Development
- Experience
---

Hi, I'm Kenji Mouri, the creator of [NSudo](https://github.com/M2Team/NSudo), it's one of the popular ways used for
launching an app with TrustedInstaller access token.

I wonder to share you programming steps that how to launch an app with TrustedInstaller access token.

0. Make sure your app which using to launch an app with TrustedInstaller access token is running as Administrator.
1. Enable the SeDebugPrivilege for the access token of the current process context.
2. Open and duplicate the access token of current session winlogon.exe process or session 0 smss.exe process.
3. Enable all privileges in the duplicated access token which was acquired from step 2, then impersonate with it.
4. Start TrustedInstaller service, open and duplicate the access token.
5. Set the session id to the current session id for the access token which was acquired from step 4.
6. Create process you want with the access token which was proceed with step 5.

I hope the article can give some help for Windows desktop app developers. Thanks for reading.
