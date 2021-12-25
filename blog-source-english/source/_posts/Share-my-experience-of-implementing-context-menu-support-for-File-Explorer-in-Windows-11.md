---
title: Share my experience of implementing context menu support for File Explorer in Windows 11
date: 2021-12-25 23:52:36
categories:
- [Technologies, Windows, Windows Apps, Development, Experience]
tags:
- Technologies
- Windows
- Windows Apps
- Development
- Experience
---

Hi, I'm Kenji Mouri, the creator of [NanaZip](https://github.com/M2Team/NanaZip), it may be the first third-party
open-source file archiver which implements context menu support for File Explorer in Windows 11. I want to share my 
experience in this article because many friends ask me for learning how to implement that since I have released NanaZip
1.0 Preview 1.

Many users and developers may notice that the context menus from their favourite apps won't show in the context menu in
Windows 11, which is implemented with XAML Islands. They need to click "Show more options" in the new context menu for 
accessing the context menu item they want to use via the legacy context menu.

I noticed it when Microsoft released the first insider preview of Windows 11 in late June, and I had waited for two 
months and found no third-party file archiver which implements context menu support for File Explorer in Windows 11. I
thought I need to create a file archiver to improve my user experience when I use Windows 11 in my main rig after 
October 5, 2021, because as a professional Windows desktop app developer, I need to pay attention to the latest Windows
platform. Because I am a 7-Zip enthusiast, so I forked the source code tree of 7-Zip.

## The requirements for implementing context menu support for File Explorer in Windows 11

According to [the article posted in Windows Blog](https://blogs.windows.com/blog/2021/07/19/extending-the-context-menu-and-share-dialog-in-windows-11/),
we know that we need to use IExplorerCommand to implement the context menu and make it run under the app identity.

There are two ways for getting app identity, packaging the full app into the MSIX package or use Sparse Manifests if 
you want to make your app unpackaged. So, the AppX manifest is required.

## Implement the IExplorerCommand interface

I think implement a simple context menu with the IExplorerCommand interface is easy, but due to the limitations of the 
IExplorerCommand interface, we can't implement something like preview images in the context menu.

Also, we can only show 16 items for maximum in one context menu handler, I have used the Google but I can't find any 
documents from Microsoft for describing the limitation. But I know the separator is not counted in the limitation, and
you can define multiple context menu handlers to bypass the limitation.

As we all know, the context menu in Windows 11 will cascade items from apps with more than 1 verb. So I suggest you 
make your context menu only in cascaded mode for a universal user experience when the user uses the legacy context menu
via clicking "Show more options".

## The choices when I implement the NanaZip

I had chosen packaging NanaZip into the MSIX package because I wanted to submit it to the Microsoft Store.

Due to the limitations of the context menu in Windows 11, NanaZip only have the cascaded mode and merge CRC SHA items
into the archiver items and split them with the separator.

## My suggestions for Microsoft

I hope we have a modern way to implement the drag-and-drop context menu. 

The App Model should be more polished, many Windows instances can't load the context menu from third-party packaged app
before restarting the File Explorer via Task Manager.

## Afterword

As a 7-Zip enthusiast and an open-source lover. I want everyone not only to know this is a 7-Zip derivative, but also
to make people know it's a project created by me.

I have searched for a proper name for half a month, and finally I decided to use NanaZip as the name of file archiver. 
Here are the reasons.

- All names of the user-oriented open-source projects created by myself is started with the `N` letter because my ID is
  `MouriNaruto`, some of my friends use `N-series` to call projects created by me.
- `Nana` is the romaji of `なな`, means seven in Japanese. It will make people know NanaZip is a 7-Zip derivative if 
  they know a little Japanese because this is a pun which is easy to understand.
- The return value of `strlen("NanaZip")` is 7, it's also a nice pun.

This is the first article of development stories from projects created or maintained by me. I will write more.

I hope the article can give some help for Windows desktop app developers. Thanks for reading.
