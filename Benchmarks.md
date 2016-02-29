## Benchmarks ##

These benchmarks are intended to give the end user an idea of the performance difference they can expect when using Avisynth64 instead of the original Avisynth.

All of the benchmarks were done using avs2avi, a program that reads an Avisynth script and then can output the resulting video and audio to any available video for windows compressor.  The original program (32 bit) can be found [here.](http://moitah.net/download/latest/AVS2AVI.zip)  The program is open source, and was compiled for x64, enabling reading of 64 bit Avisynth scripts.  It is available [here.](http://www.mediafire.com/?yykmkawa40j)

These benchmarks were done to a null output, meaning that the script was read and processed, but no data was written to disk.

Compression was not used in any of these tests.

All tests were conducted on an Intel Core i5-750 running at 3.71GHz with 4GB of ram.  All tests were conducted three times, averaging the results.  All tests were run using a single thread, as there is no multi-threading support in the official 32 bit Avisynth.  The input clip used was a 2000 frame DVSD (720x480 @ 29.97fps) capture in the YV12 color space.

Avisynth 2.6 alpha 2 was used for the 32 bit benchmarks.  This was chosen because the code is stable for all input patterns used, and includes a variety of updates to enhance the speed of various internal processes.

Relative increase was determined using the simple formula: (Avisynth64 fps) / (Avisynth32 fps)

#### [TempGaussMC](http://avisynth.org/mediawiki/TempGaussMC) ####

This is a motion-compensated bob deinterlacer, based on temporal gaussian blurring. Reduces noise/grain of the source and does NOT leave the original fields unchanged. Output is rich with details and very stable.  It is very CPU intensive, but the results are worth the wait.

Beta 2 was used for these test, default settings were used.

| **Version** | **Run 1** | **Run 2** | **Run3** | **Average** |
|:------------|:----------|:----------|:---------|:------------|
| **32 bit**  | 5.11 fps  | 5.14 fps  | 5.13 fps | _5.127 fps_ |
| **64 bit**  | 6.58 fps  | 6.58 fps  | 6.57 fps | _6.576 fps_ |
| **Relative Increase** | 128.8%    | 128.0%    | 128.3%   | _128.3%_    |

#### A simple Anti-Aliasing filter ####

This test uses a "simple" filter to anti-alias a clip.  It uses the plugins.  EEDI2 and MaskTools v2.0a36.  Both are available in 32 and 64 bit flavors.

```
input=AviSource("D:\testfile.avi")

ox = width(input)
oy = height(input)

aa = input.TurnRight().EEDI2(field=0).TurnLeft().EEDI2(field=0)

edge = mt_logic(mt_edge(aa, "5 10 5 0 0 0 -5 -10 -5 4", 0, 255, 0, 255),
	\ mt_edge(aa, "5 0 -5 10 0 -10 5 0 -5 4", 0, 255, 0, 255), "max").Greyscale().
	\ Levels(0, 0.8, 128, 0, 255, false).Spline36Resize(ox, oy, -0.5, -0.5, 2 * ox, 2 * oy)

ds = Spline36Resize(aa, ox, oy, -0.5, -0.5, 2 * ox, 2 * oy)

maskmerge = mt_merge(input, ds, edge, U=1, V=1)
return maskmerge

MergeChroma(ds,maskmerge)
```

Here are the results:

| **Version** | **Run 1** | **Run 2** | **Run3** | **Average** |
|:------------|:----------|:----------|:---------|:------------|
| **32 bit**  | 3.30 fps  | 3.30 fps  | 3.30 fps | _3.30 fps_  |
| **64 bit**  | 4.22 fps  | 4.24 fps  | 4.25 fps | _4.237 fps_ |
| **Relative Increase** | 127.9%    | 128.5%    | 128.9%   | _128.4%_    |

#### Resize Performance ####

This test does a simple Spline64Resize(1536,996) to test odd ratios.

| **Version** | **Run 1** | **Run 2** | **Run3** | **Average** |
|:------------|:----------|:----------|:---------|:------------|
| **32 bit**  | 210.63 fps | 210.63 fps | 210.63 fps | _210.63 fps_ |
| **64 bit**  | 222.36 fps | 222.36 fps | 222.36 fps | _222.36 fps_ |
| **Relative Increase** | 105.6%    | 105.6%    | 105.6%   | _105.6%_    |

And this is just for kicks, PointResize(11840,7680) --> 16x larger

| **Version** | **Run 1** | **Run 2** | **Run3** | **Average** |
|:------------|:----------|:----------|:---------|:------------|
| **32 bit**  | 21.87 fps | 21.93 fps | 21.81 fps | _21.87 fps_ |
| **64 bit**  | 29.64 fps | 29.53 fps | 29.64 fps | _29.60 fps_ |
| **Relative Increase** | 135.5%    | 134.7%    | 135.9%   | _135.3%_    |