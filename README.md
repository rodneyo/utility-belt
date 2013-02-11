utility-belt
============

Various scripts, one-liners, basrc functions etc that I've written, found, plagiarize or otherwise found useful

Warpcore
--------
I love solving problems with code, but sometimes that can be hard when you
work in a cubicle and need some quite time to work through a solution.
Enter warpcore.  A simple little script that uses play from the SoX
audio library to generate the Enterprise's warp core noise.  

Usage is dead simple.  I only implemented two variations, suited to my taste.  
```bash
warpcore w1
warpcore w2
warpcore q  (kills the process)
```

Oh, I work in Linux (ubuntu mostly) and OSX and you may need to install
these....
Ubuntu/Debian
```bash
sudo apt-get install libasound2-plugins libasound2-python libsox-fmt-all
sudo apt-get install sox
```
OSX
```bash
brew install sox
```

