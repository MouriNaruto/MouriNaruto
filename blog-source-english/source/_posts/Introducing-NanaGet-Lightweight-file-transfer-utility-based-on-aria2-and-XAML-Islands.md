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

## Development History

In 2017, I had created a project called Nagisa, a file transfer utility designed for Universal Windows Platform. It is
mainly developed in C++ 17, with WinRT API, Win32 API, WRL, STL, C++/CX and C++/WinRT for better efficiency and consumes
less storage space. I had made an ambitious plan, and here is the development roadmap:

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

But finally Nagisa had been abandoned because I had met a lot of challenges for implementing a file transfer engine 
with socket broker background tasks in Universal Windows Platform. But Nagisa is still meaningful because I won't 
create a merged PR for OpenSSL to adding Universal Windows Platform targeting support without implementing Nagisa.

P.S. Here is my merged PR for OpenSSL: https://github.com/openssl/openssl/pull/8917.

Several years later, around late 2021, I want to create a remake version of Nagisa. Because I found my current file
transfer tool, Free Download Manager, which does not support 125% DPI scaling properly. Also I want to validate my 
XAML Islands toolchain, Mile.Xaml, which will be used for the development of NanaZip 2.x. I have changed my mind 
after taking lessons for developing Nagisa. Here is my changes:

- Switch to XAML Islands because it's more flexible for developing a file transfer tool.
- Use Aria2 for transfer engine instead of developing homemade transfer engine.

Because Microsoft unpublished Nagisa from Microsoft Store for software quality reasons and I also want to unify the
product line from M2-Team. (There are some connections between Nana and my real name. Kenji Mouri is only my pseudonym
and Japanese name.) So, the remake version of Nagisa has a new name called NanaGet.

The development progress is really smooth.

## Solved Challenges

Because I have selected aria2 as the transfer engine and JSON-RPC as the communication way. For solving the conflict 
issues for the TCP port used for aria2 JSON-RPC. I had made an implementation for getting an unused TCP port and hope
it can make some help for readers.

```
#include <Windows.h>

#include <WinSock2.h>
#include <WS2tcpip.h>
#include <iphlpapi.h>
#pragma comment(lib, "ws2_32.lib")

#include <cstdint>

std::uint16_t PickUnusedTcpPort()
{
    std::uint16_t Result = 0;

    WSADATA WSAData;
    int Status = ::WSAStartup(
        MAKEWORD(2, 2),
        &WSAData);
    if (ERROR_SUCCESS == Status)
    {
        SOCKET ListenSocket = ::socket(
            AF_INET,
            SOCK_STREAM,
            IPPROTO_TCP);
        if (INVALID_SOCKET != ListenSocket)
        {
            sockaddr_in Service;
            Service.sin_family = AF_INET;
            Service.sin_addr.s_addr = INADDR_ANY;
            Service.sin_port = ::htons(0);
            Status = ::bind(
                ListenSocket,
                reinterpret_cast<LPSOCKADDR>(&Service),
                sizeof(Service));
            if (ERROR_SUCCESS == Status)
            {
                int NameLength = sizeof(Service);
                Status = ::getsockname(
                    ListenSocket,
                    reinterpret_cast<LPSOCKADDR>(&Service),
                    &NameLength);
                if (ERROR_SUCCESS == Status)
                {
                    Result = ::ntohs(Service.sin_port);
                }
            }
            ::closesocket(ListenSocket);
        }

        ::WSACleanup();
    }

    return Result;
}
```

Because I have selected XAML Islands for implementing the UI. I have also met some issues. I will write a new article
for talking about that if I really solved them.

## Future Plans

- Improve the Mile.Xaml implementations for providing more modern control styles and keeping smaller binary size.
- Continue to fixing bugs and adding features for NanaGet itself.
- Try to build my aria2 binary instead of using offical one for providing x64 and arm64 native support for aria2 part.
- Try to make my homemade transfer engine for do some researches.

## Afterword

I hope you will enjoy it. Thanks for reading.
