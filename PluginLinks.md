## 64-Bit Plugin Collection ##

---


New on 3/21/2010

[AddGrainC x64](http://www.mediafire.com/?imj5nkwdkj1)

Built on 3/14/2010

[AutoCrop x64](http://www.mediafire.com/?mzddfmjjdyx)

New on 3/21/2010

[aWarpSharp x64](http://www.mediafire.com/?mjmfnuwf2ky)

This version is based on SEt's original rewrite found [in this thread](http://forum.doom9.org/showthread.php?t=147285)

Built on 3/20/2010

[Color Matrix x64](http://www.mediafire.com/?ztjwmywqmm4)

New on 3/13/2010

[DFTTest x64](http://www.mediafire.com/?oemygnmkrji)-->needs the included libfftw3f-3.dll to be in your system32 directory

Built on 3/19/2010

[DgDecode 1.5.8 x64](http://www.mediafire.com/?c0wmemj5jam)
Note: Is missing some IDCT modes, will get them back ASAP

Built on 4/10/2010

[EEDI2 x64](http://www.mediafire.com/?znmyzdo2ize)
  * Vectorized main loop
  * Further restructured main loop to minimize branching, processor dependent speed increase


[FeildHints x64](http://www.mediafire.com/?ynkidzz4joz)

Built on 3/12/2010

[FFT3DFilter](http://www.mediafire.com/?2ymcyfuzzzw)-->needs the included libfftw3f-3.dll to be in your system32 directory

Built on 3/15/2010

[FFT3DGPU x64](http://www.mediafire.com/?2chnt1jkwwm)
  * The hlsl (shader program) file is edited from the original to adhere to pixel shader 3.0 syntax rules.  Please make sure to place the correct file in the same directory as the 64bit plugin.

New on 3/13/2010

[kemuri-\_9's FFMS2 (The Fabulous FM Source 2)](http://kemuri9.net/dev/avs/ffms2/x64/ffms2.dll)
Big thanks to kemuri-_9 for the build_

Built on 3/29/2010

[GradFun2DB x64](http://www.mediafire.com/?w0trndmni3j)

Built on 4/08/2010

[hqdn3d x64](http://www.mediafire.com/?gyvmmzx0v4z)

Built on 3/14/2010

[LeakKernelDeint x64](http://www.mediafire.com/?tqmjdnjdnum)

Built on of 3/12/2010
[MaskTools 2.0a x64](http://www.mediafire.com/?jqyziyme1zd)

Built on 3/31/2010

[MVTools2 x64](http://www.mediafire.com/?2yjmze2ommz)
  * Continued conversion and updating of assembly functions
  * Removal of some code intended to support processors without mmx/iSSE
  * Converted often used assembly functions to SSE2 instead of mmx/iSSE
  * Updated to latest shared function library from x264
  * Healthy 20%+ speed increase over x86 version in most cases

New on 3/14/2010

[TDeint x64](http://www.mediafire.com/?kmcztm1xzjm)
This is basically the same as squid80's build, main differences being newer avisynth.h and newer compiler

[TelecideHints x64](http://www.mediafire.com/?wnemmzntgnh)

Built on 3/13/2010:

[TIVTC x64](http://www.mediafire.com/?i2qtli1mxik)


New on 3/20/2010

[TNLMeans\_x64 v1.0.3](http://www.mediafire.com/?y4e3zd2zodd)

New on 3/20/2010

[TTempSmooth x64 v0.9.4](http://www.mediafire.com/?zv0jm3mtmzf)

[RemoveGrain x64](http://www.mediafire.com/?qjmyjt52miz)

[Repair x64](http://www.mediafire.com/?q00r32yegnh)

[VerticalCleaner x64](http://www.mediafire.com/?mjctqyjnoxh)


[Visit Squid80's homepage](http://members.optusnet.com.au/squid_80/) for more x64 plugins



## Benchmarking Suggestions ##

Here is a [64bit avs2avi for benchmarking](http://www.mediafire.com/?yykmkawa40j).  You can run it against [the original](http://moitah.net/)

To simply run the script through Avisynth, execute the following at a command prompt:
```
avs2avi64.exe <path:\script.avs> -o n
```