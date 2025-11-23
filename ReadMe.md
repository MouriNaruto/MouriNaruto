Hi there,

My public name is Kenji Mouri, or 毛利 研二 in Japanese. In China, due to my
public name, my friends call me 毛利, or Mouri in English. In some cases, my
friends also call me Kuriko Mou, or 毛 栗子 in Japanese.

*MouriNaruto*, *Mouri_Naruto* and *Mouri* are my typical usernames.

I am passionate about developing highly efficient software implementations with
minimal syntax and reliance on third-party libraries, and love creating
open-source projects and sometimes making contributions for other's. I am also
a [Microsoft MVP] and a [PCBeta moderator]. Here is my [blog], [resume],
[projects], [speeches] and [documentations]. If you want to sponsor me, please
read [Become a sponsor to Kenji Mouri](Sponsor).

[Microsoft MVP]: https://mvp.microsoft.com/en-us/PublicProfile/5004706?fullName=Kenji%20Mouri
[PCBeta moderator]: https://i.pcbeta.com/home.php?mod=space&uid=3887572&do=profile
[blog]: https://mouri.moe/
[resume]: https://mouri.moe/assets/resume.pdf
[projects]: Projects.md
[speeches]: https://github.com/MouriNaruto/Presentations
[documentations]: https://github.com/MouriNaruto/MouriDocs

Also, I have provided several [paid services](PaidServices.md) from me.

## Things I currently working on

Due to many people have asked me why not update a specific project frequently.
I think I should provide you the list of things I currently working on will be
the best explanation. This list will be sorted in priority order.

Here are the things I want to have progress in 2026. The [archive] is
available if you want to read the history of this list.

[archive]: https://github.com/MouriNaruto/MouriDocs/blob/main/docs/10/ReadMe.md

#### Porting Hyper-V Enhanced Session mode over VMBus to Hyper-V Linux guests.

Status: Working In Progress

I had made a implementation at https://github.com/SherryPlatform/HvGin. But
there are some stability issues which need to fix. So, I tried to rewrite this
with C++ and create a new project at https://github.com/SherryPlatform/RelayLab.

#### NanaZip 6.x

Status: Working In Progress

Current, I have released NanaZip 6.0 Preview 1. Starting with NanaZip 6.0, the
NanaZip project is governed by multiple Benevolent Dictators For Life who make
final decisions by reaching an agreement offline.

Many things happened, but still something I need still to push.

I find it's necessary to synchronize GUI part to the latest 7-Zip mainline to
reduce the security issues.

I hope I can add the support for extracting compressed files from the .NET
Single File Application bundles, but I need to finish the decoder and encoder
interfaces definitions in the modernized 7-Zip Plugin SDK which made by me.

I also hope I can finish the littlefs parser by myself because I want to have
a lightweight readonly implementation which I can try to use that in MBR for
happiness on the retro 16-Bit x86 platform.

Also, I think we should use more algorithm implementations from Windows APIs,
which is "As Microsoft As Possible" a.k.a. AMAP strategy which mentioned by me.

AMAP strategy can help me to reduce the attack surface and the binary size.

#### Mobility

Status: Working In Progress

It's an ambitious plan. According with one of my previous professors suggestion.
I think I should write a demo like minimal Hyper-V UEFI guest with Hyper-V
hypercalls and VMBus devices support.

#### Blog website migration

Status: Working In Progress

I found I'm more suitable to write documentation style articles managed via Git.

I need to make a website generator for my documents first.

#### My first technical book

Status: Working In Progress

I decided to write a technical book about the Hyper-V guest interfaces.

I plan to write the book in English. But I need to continue to maintain and
create related open-source projects as the examples mentioned in the book.

But I think that topic is also suitable to write a science fiction isekai light
novel in Japanese.

#### Make Wayland Great Again

Status: Working In Progress

I think I need to make an immersive Wayland compositor for X11 which can help
resource-constraint devices. I think it's good to call that WayRT to play puns
of WinRT, lol.
