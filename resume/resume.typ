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
  h(1fr); text("Last Updated in " + date, fill: color.gray)
}

= Kenji Mouri

Kenji.Mouri\@outlook.com |
#link("https://github.com/MouriNaruto")[github.com/MouriNaruto] |
#link("https://mouri.moe")[mouri.moe]

== Introduction
#separator()

- Hi, I am Kenji Mouri. My legal name is Qi Lu which is used only when
  in-person. MouriNaruto, Mouri_Naruto and Mouri are my typical usernames.
- I am passionate about developing highly efficient software implementations
  with minimal syntax and reliance on third-party libraries.
- I have created and maintained several open-source projects written
  predominately in C and C++ since 2014.
- I am also a proud Microsoft MVP in the Developer Technologies and Windows
  Development award categories.
- My goal for my next role is systems-level software development and
  maintenance.

== Professional Experience
#separator()

*#link("https://live.qq.com")[Qi'e TV, Tencent]*
(C++ Software Development Engineer)
#h(1fr) Dec 2020 -- Present \
- Lead the development of the QieLive 2.x Series from conception to release,
  adapted for Windows 7 Service Pack 1 or later.
- Built customized FFmpeg, MSBuild, and Qt6 toolchains for QieLive.

== Open Source Experience
#separator()

*#link("https://github.com/M2Team")[M2-Team]* (Owner)
#h(1fr) Jun 2015 -- Present \
- #link("https://github.com/M2Team/NanaZip")[NanaZip] - File archiver intended
  for the modern Windows experience
- #link("https://github.com/M2Team/NanaBox")[NanaBox] - A third-party
  lightweight out-of-box-experience oriented Hyper-V client
- #link("https://github.com/M2Team/NanaGet")[NanaGet] - Lightweight file
  transfer utility based on aria2 and XAML Islands
- #link("https://github.com/M2Team/NanaRun")[NanaRun] - Application runtime
  environment customization utility for Windows

*#link("https://github.com/ProjectMile")[
Mouri Internal Library Essentials (Project Mile)]* (Owner)
#h(1fr) Nov 2020 -- Present \
- #link("https://github.com/ProjectMile/Mile.Xaml")[Mile.Xaml] - Lightweight
  XAML Islands toolchain with modern Windows controls styles
- #link("https://github.com/ProjectMile/Mile.HyperV")[Mile.HyperV] - A
  lightweight library for Hyper-V guest interfaces
- #link("https://github.com/ProjectMile/Mile.Cirno")[Mile.Cirno] - Work in
  progress 9p client for Windows based on
  #link("https://github.com/dokan-dev/dokany")[Dokany]
- #link("https://github.com/ProjectMile/Mile.Uefi")[Mile.Uefi] - UEFI
  Application SDK for Visual Studio
- #link("https://github.com/ProjectMile/Mile.Aria2")[Mile.Aria2] - Customized
  version of aria2 specialize for MSVC toolchain

*#link("https://github.com/lvgl")[LVGL]* (Maintainer)
#h(1fr) Jan 2021 -- Present \
- Maintain implementation of
  #link("https://github.com/lvgl/lv_port_pc_visual_studio")[
  LVGL port for Visual Studio (lv_port_pc_visual_studio)].
- Maintain the implementation of
  #link("https://github.com/lvgl/lv_drivers/pull/117")[
  New native Windows driver (win32drv)] and
  #link("https://github.com/lvgl/lvgl/pull/2701")[
  Windows file system driver (lv_fs_win32)].

*Selected Technical Documents* (Author)
- #link("https://github.com/MouriNaruto/MouriDocs/tree/main/docs/1")[
  MD1: Notes for using GPU-PV on Hyper-V/NanaBox]
- #link("https://github.com/MouriNaruto/MouriDocs/tree/main/docs/4")[
  MD4: Notes for using Host Compute System API]
- #link("https://github.com/MouriNaruto/MouriDocs/tree/main/docs/21")[
  MD21: Talk about booting Windows 7 Service Pack 1 on Hyper-V Generation 2
  Virtual Machines]

== Honors
#separator()

*#link("https://mvp.microsoft.com/en-us/PublicProfile/5004706?fullName=Kenji Mouri")[
Microsoft MVP]* (Developer Technologies, Windows Development)
#h(1fr) Feb 2022 -- Present \

== Education
#separator()

*Changshu Institute of Technology*, China
#h(1fr) Sep 2016 -- Jul 2020 \
- Bachelors of Engineering, Automotive Service Engineering
- Lead the development of hardware abstraction layer and user experience layer
  from an autonomous driving vehicle project in the college's IoT lab.
  Summarized in my
  #link("https://mouri.moe/assets/Research%20of%20human-computer%20interaction%20system%20for%20autonomous%20driving.pdf")[
  graduation design] which wins the third prize of school-level outstanding
  graduation design award.

== Skills
#separator()

- Languages: English - fluent (CET6), Chinese - native speaker
- I am not limited to any specific programming language, I am highly proficient
  in C, C++, and C\#. I am highly experienced in Windows development using
  Visual Studio, and comfortable in other tooling for Windows and Linux.
- I have focused on Windows Development with Win32 API, COM (ATL and WTL) and
  WinRT (C++/WinRT) since 2014, which I started to participate in the Chuyu
  Team's next generation third-party Windows servicing tool,
  #link("https://github.com/Chuyu-Team/Dism-Multi-language/releases/tag/v10.1.1002.2")[
  DISM++].
- I am highly skilled in systems-level development with Visual Studio under
  Windows. I have developed a Hyper-V guest SDK and a UEFI application SDK,
  demonstrating my experience in systems-level Windows development.

#lastupdated("June 6, 2025")
