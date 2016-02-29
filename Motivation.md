## Why 64 bit? ##

#### Short version ####
More and faster access to large amounts of data.  The ability to utlize more memory than conventional 32 bit addressing allows.  These things come in really handy for working with large amounts of video and audio data.  When running and application in 32 bit mode, these advantages are stripped from the programmer and user.

#### Long (technical) version ####
The x86 instruction set has undergone a lot of revisions since its inception, each one striving to keep it relevant when compared to advances in other architechtures.  Because it's ancestry is so antiquated, it has traditionally been VERY starved for registers, making frequent accesses to memory the norm.

When AMD introduced x86-64, they changed a long overdue, and very needed aspect of the x86 architecture itself.  They doubled the amount (and size) of general purpose storage registers, as well as doubled the amount of 128 bit XMM registers (SIMD registers for SSE instructions).  They changed the function calling convention in C++ so less data was passed on the stack, (for the most part) removed segmented addressing, and did away with some other antiquated methods of doing things at the chip level.  The overall result was a nice restart for x86, while also maintaining backwards compatibility with the old code base that's existed for decades.

The problem is, running "old" 32 bit code still limits the program to 8 general purpose registers, 8 mmx registers, and 8 xmm registers.  It also maintains segmented addressing and support for some other legacy features.  The only way to open up the extra registers is to run the application in native 64bit mode.

The difference between 32 bit mode and 64 bit mode means that it's impossible for binaries compiled for x86 and x64 to "talk" directly to each other.  The communication channels are just too different.  The best way for Avisynth scripts to take advantage of the speed increases afforded by 64bit media compressors is to have a native 64 bit version built.

I started this version purely to occupy some of my free time, and because I was fascinated with Avisynth to begin with.  There's still optimization that can be done to the current assembly routines, and it lacks much of the plugin base.  Another downside is that the main project is still being developed for 32 bit platforms exclusively.
Avisynth 2.6 will be 32 bit, and I do not believe there are plans (at this time) to create a 64 bit branch.  It would be nice for forward compatibility, but, converting ALL that code is a monstrous effort, and if the payoff isn't worth it, then it was energy wasted.  I have some idea that Avisynth benefits from 64bit execution, but am unsure of the real speed gains.