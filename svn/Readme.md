Bashrc Functions
---

Since I have to use SVN sometimes I get tired of typing:
svn copy [LONG_ASS_URL_TO_SVN_REPO]/trunkorbranch
[LONG_ASS_URL_TO_SVN_REPO]/branchortag

So, I created these bashrc functions to help me quickly create release
branches and tags from a svn repo.  Note:  These scripts follow a
convention as to how the svn repo is laid out and naming of the branch
and tag revs.  If you don't follow the convention they probably won't be of any use to you. 


One you add them don't forget to 
'''bash
source ~/.bashrc
'''
