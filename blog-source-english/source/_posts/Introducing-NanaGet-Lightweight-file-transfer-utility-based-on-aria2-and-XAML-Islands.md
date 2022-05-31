---
title: Introducing NanaGet - Lightweight file transfer utility based on aria2 and XAML Islands
date: 2022-05-31 23:48:37
categories:
- [Technologies, Windows, Windows Apps, Development, Announcement]
tags:
- Technologies
- Windows
- Windows Apps
- Development
- Announcement
---

In recent days, I have created a new project called [NanaGet](https://github.com/M2Team/NanaGet), the successor of 
[Nagisa](https://github.com/M2TeamArchived/Nagisa), a lightweight file transfer utility based on aria2 and XAML Islands.

In 2017, I had created a project called Nagisa, a file transfer utility designed for Universal Windows Platform. It is
mainly developed in C++ 17, with WinRT API, Win32 API, WRL, STL, C++/CX and C++/WinRT for better efficiency and consumes
less storage space. I had made an ambitious plan, and here is the development roadmap.

- Assassin Transfer Engine (An alternative to Windows.Networking.BackgroundTransfer)
  - Support background download. 
  - Support resuming broken/dead downloads.
  - Support multi-thread multi-task download. 
  - Support HTTP 1.1 and HTTP/2 protocol for HTTP and HTTPS support.
  - Support FTP, FTPS and SFTP.
  - Support WebSocket and WebSocket Secure.
  - Support BitTorrent, Magnet and ED2K.
  - Support downloading files from multiple URIs.
- Experience
  - Support providing HASH value for downloaded files.
  - Support get download URI from QR code and texts in images.
  - Support establishing download daemons on IoT devices (like Raspberry Pi). 
  - Support pushing a download task to the other devices.

But finally Nagisa had been abandoned.

## Afterword

I hope you will enjoy it. Thanks for reading.
