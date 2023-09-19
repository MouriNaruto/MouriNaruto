Hi there,

You can call me Kenji Mouri (毛利 研二) or Mouri (毛利) in most cases. You also
can call me Kuriko Mou (毛 栗子) when I'm in [VTuber] or [Otokonoko] mode.

[VTuber]: https://en.wikipedia.org/wiki/VTuber
[Otokonoko]: https://en.wikipedia.org/wiki/Otokonoko

*MouriNaruto*, *Mouri_Naruto* and *Mouri* are my typical usernames.

I am interested in writing the most compact implementations by using the least
syntaxes and third-party libraries, and love creating open-source projects and
sometimes making contributions for other's. I am also a [Microsoft MVP] and a
[PCBeta moderator]. Here is my [blog], [resume], [projects], [speeches] and 
[documentations]. If you want to sponsor me, please read
[Become a sponsor to Kenji Mouri](Sponsor).

[Microsoft MVP]: https://mvp.microsoft.com/en-us/PublicProfile/5004706?fullName=Kenji%20Mouri
[PCBeta moderator]: https://i.pcbeta.com/home.php?mod=space&uid=3887572&do=profile
[blog]: https://mouri.moe/
[resume]: https://mouri.moe/assets/resume/resume_english.pdf
[projects]: Projects.md
[speeches]: https://github.com/MouriNaruto/Presentations
[documentations]: https://github.com/MouriNaruto/MouriDocs

## Things I currently working on

Due to many people have asked me why not update a specific project frequently.
I think I should provide you the list of things I currently working on will be
the best explanation. This list will be sorted in priority order.

Here are the things I want to have progress in September 2023.

#### Porting Hyper-V Enhanced Session mode over VMBus to Hyper-V Linux guests.

Status: Working In Progress

I have written a validation demo for Windows 8 guests before I write the Linux
kernel module. Here is the demonstration video:
https://twitter.com/MouriNaruto/status/1700922160905359757

Note: Hyper-V Enhanced Session mode over VMBus transport originally needs
Windows 8.1 or later in the guest.

#### Split the LZMA SDK as a separate module in NanaZip. 

Status: Canceled

It's not realistic due to strong coupling between LZMA SDK and other parts in
the 7-Zip mainline source code. But we can split the 7z.dll part as a separate
module because 7-Zip maintains good ABI compatibility for that.

So, I have a better plan for achieve the original goal: Create NanaZip.Core
project for making me track the modifications from upstreams better in the
future.

#### Implement the new Windows backend for LVGL.

Status: Not Started

#### Synchronize the LZMA SDK and 7-Zip implementations to 23.01 in NanaZip.

Status: Partially Finished

This task will be finished if the Self Extracting Executable implementations
have been migrated to NanaZip.Core project successfully. Because NanaZip.Core
project is based on 7-Zip 23.01 at the beginning.

#### Implement the optimized parser version of RaySoul.

Status: Not Started

#### Create NanaZip.Core project for rewriting the core implementation.

Status: Partially Finished

The development work on NanaZip.Core.dll has been completed successfully. In
the next version of NanaZip will use this implementation.

The next step is migrating the Self Extracting Executable implementations to
NanaZip.Core project.
