utility-belt
============

Various scripts, one-liners, basrc functions etc that I've written, found, plagiarize or otherwise found useful

Svn
--------
A few wrapper shell scripts to make it eaiser for me to create different branches,tags and 
revisions.  More are forthcoming... unless I get the team to move :sparkles: git :sparkles:

Shell
--------
Some bash scripts.
 1.  my laptop rsync backup
 1.  remove old kernels that always seem to pile up2

Programs
--------
1. ad_utilities.py - generic program that can be changed to output various active directory data


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

