Bashrc Functions
---

Since I have to use SVN sometimes and I love the command line, I get
tired of typing:
 ```bash
svn copy [LONG_ASS_URL_TO_SVN_REPO]/trunkorbranch [LONG_ASS_URL_TO_SVN_REPO]/branchortag
```
whenever I need to create a new tag or branch


So, I created these bashrc functions to help me quickly create release
branches and tags from a svn repo.  Note:  These scripts follow a
convention as to how the svn repo is laid out and naming of the branch
and tag revs.  If you don't follow the convention they probably won't be of any use to you. 

Once added to your .bashrc/.profile or other shell init file you can do
things like:

```bash
svncb [REPO] "commit message"
```
or
```bash
svnct [REPO] "commit message"
```

Assuming the convention below was followed for creating your svn repo and the naming of
your tags and branches...

svncb will ask you if you want to create a major or minor branch from trunk.
Choosing a major branch will create a new release_branch in your branches
directory. It uses the major number of the last release branch incremented
by 1.  So if the previous release branch was release_branch.1.0, a new
branch is created as release_branch.2.0


svnct will cut a new tag from the most recent release_branch and
increment the tag version by 1.  It assumes each release tag is an
update to the release_branch it was cut from.  So release_tag.1.1 becomes release_tag.1.2

Once you add them don't forget to 
```bash
source ~/.bashrc
```


SVN repository and naming convention will go here
---
