---
title: My opinion about someone boycotting 7-Zip
date: 2022-06-30 16:09:00
categories:
- [Opinions]
tags:
- Opinions
---

In recent days, I have known someone wants to boycotting 7-Zip. Most of people including me think that their reasons
are nonsense. I write the comment in https://www.theregister.com/AMP/2022/06/27/7zip_compression_tool and make the 
backup in this article because I think it's necessary for me to show my position.

## The full text of my comment

Hi, NanaZip author here.

Actually, I am a faithful 7-Zip user since 2011 when I got the 7-Zip 9.20 installer binary, until I created NanaZip in
late 2021. (But I am still a 7-Zip user in strictly.) It's a professional tool for many people. I often use it to 
pre-analyze the structure of executable file.

I can prove the source code of 7-Zip mainline is easy to build and 100% clean with code-level modularize.

When I read the source code of 7-Zip, I feel I am talking with an old school software developer, with the similar 
feeling with my senior. They both intend for smaller binaries. So, I can understand why the author doesn't like "/GS",
"/DYNAMICBASE" and the compiler flags which can make binary expansion. Also, they both care about old Windows 
compatibility. So, I can understand why the author don't do some modernization work.

Based on these, I created NanaZip because I want to integrate some modern things which not acceptable by 7-Zip author.
(As same as my senior, he doesn't like App Model and Windows Runtime. But I want to use App Model and Windows Runtime
XAML to modernize the user experience.)

Kenji Mouri

## Afterword

I have selected and made some patches to 7-Zip mainline from NanaZip. I hope the author can be merge it because it 
don't need to break the old Windows compatibility.

For more information, please read https://sourceforge.net/p/sevenzip/discussion/45797/thread/68fd36919f/.
