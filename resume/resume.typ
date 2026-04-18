#show heading: set text()

#show link: underline

#set text(
  size:10pt,
)

#set page(
  margin: (x: 0.9cm, y: 1.3cm),
)

#set par(justify: true)

#let separator() = { v(-3pt); line(length: 100%); v(-5pt) }

#let lastupdated(date) = {
  h(1fr); text("Last Updated: " + date, fill: color.gray)
}

= Kenji Mouri

Kenji.Mouri\@outlook.com |
#link("https://github.com/MouriNaruto")[github.com/MouriNaruto] |
#link("https://mouri.moe")[mouri.moe] |
Legal name: Qi Lu

== Introduction
#separator()

- Also known online as MouriNaruto, Mouri_Naruto, or simply Mouri.
- Passionate about building efficient software with concise implementations and
  minimal third-party dependencies.
- Creator and maintainer of multiple open-source projects since 2014.
- Microsoft MVP in the Developer Technologies and Windows Development
  categories.
- Interested in systems software development, runtime/toolchain engineering, and
  long-term maintenance work.

== Professional Experience
#separator()

*#link("https://live.qq.com")[Qi'e TV, Tencent]*
(C++ Software Development Engineer)
#h(1fr) Dec 2020 -- Present \
- Revived and delivered the QieLive 2.x series from scratch, based solely on a
  white paper provided by others, with support for Windows 7 Service Pack 1 or
  later.
- Built customized FFmpeg, MSBuild, and Qt 6 toolchains for the QieLive build
  and release pipeline.

== Open Source Experience
#separator()

*#link("https://github.com/M2Team")[M2-Team]* (Founder and Owner)
#h(1fr) Jun 2015 -- Present \
Founded and maintained multiple Windows-focused open-source projects, including:
- #link("https://github.com/M2Team/NanaZip")[NanaZip] - File archiver intended
  for the modern Windows experience
- #link("https://github.com/M2Team/NanaBox")[NanaBox] - A third-party
  lightweight out-of-box-experience oriented Hyper-V client
- #link("https://github.com/M2Team/NanaRun")[NanaRun] - Application runtime
  environment customization utility for Windows

*#link("https://github.com/ProjectMile")[
Mouri Internal Library Essentials (Project Mile)]* (Founder and Owner)
#h(1fr) Nov 2020 -- Present \
Founded and maintained a collection of open-source infrastructure libraries and
tools, including:
- #link("https://github.com/ProjectMile/Mile.Xaml")[Mile.Xaml] - Lightweight
  XAML Islands toolchain with modern Windows controls styles
- #link("https://github.com/ProjectMile/Mile.HyperV")[Mile.HyperV] - A
  lightweight library for Hyper-V guest interfaces
- #link("https://github.com/ProjectMile/Mile.Cirno")[Mile.Cirno] - Work in
  progress 9p client for Windows based on
  #link("https://github.com/dokan-dev/dokany")[Dokany]
- #link("https://github.com/ProjectMile/Mile.Uefi")[Mile.Uefi] - UEFI
  Application SDK for Visual Studio

*#link("https://github.com/lvgl")[LVGL]* (Maintainer)
#h(1fr) Jan 2021 -- Present \
- Maintain #link("https://github.com/lvgl/lv_port_pc_visual_studio")[
  the Visual Studio port of LVGL (lv_port_pc_visual_studio)].
- Maintain #link("https://github.com/lvgl/lv_drivers/pull/117")[
  the native Windows driver (win32drv)] and
  #link("https://github.com/lvgl/lvgl/pull/2701")[
  the Windows file system driver (lv_fs_win32)].

*Selected Technical Writing* (Author)
- #link("https://github.com/MouriNaruto/MouriDocs/tree/main/docs/1")[
  MD1: Notes for using GPU-PV on Hyper-V/NanaBox]
- #link("https://github.com/MouriNaruto/MouriDocs/tree/main/docs/4")[
  MD4: Notes for using Host Compute System API]
- #link("https://github.com/MouriNaruto/MouriDocs/blob/main/docs/9")[
  MD9: Hyper-V Enhanced Session over VMBus for pre-Windows 8.1 and Linux guests]
- #link("https://github.com/MouriNaruto/MouriDocs/tree/main/docs/21")[
  MD21: Talk about booting Windows 7 Service Pack 1 on Hyper-V Generation 2
  Virtual Machines]

== Awards & Honors
#separator()

*#link("https://mvp.microsoft.com/en-us/PublicProfile/5004706?fullName=Kenji Mouri")[
Microsoft MVP]* (Developer Technologies, Windows Development)
#h(1fr) Feb 2022 -- Present \

== Education
#separator()

*Changshu Institute of Technology*, China
#h(1fr) Sep 2016 -- Jul 2020 \
- Bachelor of Engineering in Automotive Service Engineering
- Graduation Project: #link("https://mouri.moe/assets/bachelor-graduation-project.pdf")[
  Research on a Human-Computer Interaction System for Autonomous Driving] -
  Third Prize, University Outstanding Graduation Project Award. 

== Skills
#separator()

- Human Languages: Chinese (native), English (fluent), Japanese (learning)
- Programming Languages: C, C++, C\#, etc.
- Stacks and Tools: Win32 API, COM (ATL and WTL), WinRT (C++/WinRT), Hyper-V
  (Host Compute System API, Host Networking Service API, Guest Interfaces), UEFI
  (EDK II MdePkg definitions only), Linux (customized kernel and rootfs for
  Hyper-V Generation 2 Virtual Machines), Visual Studio, MSBuild, CMake, Git,
  etc.
- Active in Windows development since 2014, including helping build the Chuyu
  Team's next generation third-party Windows servicing tool,
  #link("https://github.com/Chuyu-Team/Dism-Multi-language/releases/tag/v10.1.1002.2")[
  DISM++].

#lastupdated("April 18, 2026")
