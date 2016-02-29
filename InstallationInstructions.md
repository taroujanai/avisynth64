## Avisynth 64 Installation Instructions ##

  1. Be running a copy of 64 bit Windows
  1. Have the 32 bit version of Avisynth installed to begin with, it's installer will setup all the system paths and registry entries
  1. Run the installtion script (provided by Turbojet of the Doom9 forums) included in the archive **as administrator**
    * This DLL will not interact or interfere with any of the functionality of your 32 bit Avisynth installation
    * Avisynth 32-bit is located in C:\<Windows Root>\SysWOW64, this version installs to (as backwards as it may seem) C:\<Windows Root>\System32
  1. If this does not work for you, Copy included DevIL.dll and avisynth.dll into your C:\Windows\System32 directory
    * Again, it's backwards, but all 64bit binaries are located in System32
  1. This DLL will only work with 64 bit programs, and 64 bit codecs
    * Virtual Dub has a 64 bit version that will load avs files using this binary [download it here](http://virtualdub.sourceforge.net/).  Be sure to get the 64bit version, second section down
    * 64 bit vfw codecs are required, a good place to go is [ffdshow-tryouts.](http://sourceforge.net/projects/ffdshow-tryout/)  Once again, be sure to download a build that was COMPILED FOR x64
  1. All of the built in Avisynth functions should be working properly, as of now, you're limited to these and my ports UNLESS:
  1. Write, modify, and compile your own 64bit versions of existing Avisynth filters, most are open source anyhow, you're only limited by the compiler
    * Intel's C++ compiler understands inline ASM and uses "Intel's Syntax" which is what VS2005 interprets when it hits an ASM block
    * The GNU C++ compiler also understands inline ASM, but uses AT&T syntax, making porting this way a bit more cumbersome
    * Re-write the inline assembler using standard assembly if needed, [YASM](http://www.tortall.net/projects/yasm/) has full 64bit windows functionality
  1. [Visit Squid80's homepage.](http://members.optusnet.com.au/squid_80/)
    * He did a lot of heavy lifting to get Avisynth 2.5.5 to compile and work WITHOUT inline asm in the first place (WOW).
    * He also has a collection of plugins already compiled for use with 64bit avisynth
  1. Report any feedback, problems, questions, and concerns on the doom9 forum [in this thread.](http://forum.doom9.org/showthread.php?p=1374745#post1374745)
    * There you will find the collection of plugins I've personally ported for use with this project.
    * If it's a bug, please provide a clip and sample script so I can recreate it
  1. Alternatively, file an issue report on google code
  1. If there are any plugins you routinely use that you'd like to see supported in the 64bit version of Avisynth, please stop by the forum and let me know.  I will do my best to fulfill any feature requests, just keep in mind that I'm only human, and the only human actively compiling this source :)