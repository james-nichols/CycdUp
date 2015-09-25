# CycdUp

Put this repo directory in [OpenFrameworksDir]/apps/myApps/ and compile using xcodebuild on macosx. Not sure if compiles on Linux.

After compiling, and plugging in the ardiuno, run ./bin/CycdUp.app/Contents/MacOS/CycdUp 

Then run synthesis in SuperCollider by opening the CycdUpSynths.scd patch and running the part between brackets, probably twice to ensure it's all running. This is done by double clicking on the first open-bracket so that the region between brackets is all selected, then hit "Apple-Enter" in osx. Not sure about Linux SC, but I'm sure it's something like Ctrl-Enter.

Multi-channel audio is usually not a problem in SuperCollider, and each "bike" is sent to channels 1-4. However, sometimes SuperCollider can be a bit funny about choosing the right soundcard (e.g. sometimes it will choose the built-in sound instead of the soundcard you want). When you start the code, in the "Post Window" to the bottom right, there will be a section that says something like:
```
Number of Devices: 3
   0 : "Built-in Microph"
   1 : "Built-in Output"
   2 : "Pro Tools Aggregate I/O"

"Built-in Microph" Input Device
   Streams: 1
      0  channels 2

"Built-in Output" Output Device
   Streams: 1
      0  channels 2
```
If the soundcard you want to use is not the Output Device at the end of that list (where it says "Built-in Output" Output Device), you need to change the entry at the start of the code where it says:
```
o.device = nil; // use the system default soundcard
```
and change nil to "Soundcard Name", where Soundcard Name is spelt exactly in the list in that previous section (e.g. "Pro Tools Aggregate I/O").

Once the synthesis is running, you can go back to the visualisation app and make it full-screen in the "Window" menu.
