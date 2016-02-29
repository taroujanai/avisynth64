[The original Avisynth](http://www.avisynth.org) is a scripting language and a collection of filters for simple (and not so simple!) non-linear video editing tasks. It frameserves video to applications.

This branch of the project takes the 2.5.8 source code and adds support for the new 64bit x86 processors, taking advantage of the improvements offered by the new architecture.  This also allows removal of legacy functions intended to extend support to older processors, lacking certain SIMD instruction sets.  The end result is a leaner and faster binary.

Scripting syntax remains the same, as well as the plugin system used by the original Avisynth.  Any scripts written for the original will work without modification.  Any plugins used must be compiled as 64bit binaries, which are in limited availability at the time.  Work is being done to provide a complete library of plugins for use with this project.

## [Try it out now!](http://avisynth64.googlecode.com/files/avisynth64_4-16-10.rar) ##

#### [Installtion instruction are here](http://code.google.com/p/avisynth64/wiki/InstallationInstructions) ####

#### [Plugins for use with the project are here](http://code.google.com/p/avisynth64/wiki/PluginLinks) ####

#### [Benchmarks to gauge speed increase when moving to 64 bit code](http://code.google.com/p/avisynth64/wiki/Benchmarks) ####
