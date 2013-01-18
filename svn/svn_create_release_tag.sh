# create a release tag
# requires that you name your release branches and tags follow the following convention
#
# release_branch.[major rev 1-9].[minor rev 0-9]
# release_tag.[major rev 1-9].[tag number 1-9]
#
# The function will find the lastest created tag, parse the rev number and increase the [tag number]
# by 1.  Information is displayed detailing the release branch the tag will be cut from, 
# the current tag, and finally the new tag.  
# You will be prompted to accept the tag or allowed to exit.
function svnct() {
  if [[ -z $1 ]]; then
    echo "svn repo needed. Usage: snvrelease [svn repo]"
 elif [[ -z $2 ]]; then
    echo "Please provide a commit message for the tag"
  else
    local RAW_BRANCH=`exec 6>&2 2>/dev/null; svn log -v http://[SVN_SERVER]/svn/$1/branches | awk '/^   M/ { print $2 }' | head -1; exec 2>&6 6>&-`
    local BRANCH=`echo $RAW_BRANCH | awk -F/ '{print $3}'`

    local RAW_TAG=`exec 6>&2 2>/dev/null; svn log -v http://[SVN_SERVER]/svn/$1/tags | awk '/^   A \/tags\/release_tag/ { print $2 }' | head -1; exec 2>&6 6>&-`
    local CURRENT_TAG=`echo $RAW_TAG | awk -F/ '{print $3}'`
    local TAG_NBR=$(echo $CURRENT_TAG | awk -F '.' '{ print $3 }')
    local NEW_RELEASE_TAG_NBR=$(( TAG_NBR + 1 ))
    local RELEASE_BRANCH_TAG=`echo $CURRENT_TAG | grep -o 'release_tag\.[0-9]\+'`
    local NEW_RELEASE_TAG=$RELEASE_BRANCH_TAG.$NEW_RELEASE_TAG_NBR
    echo "===================================================================================="
    echo "=                            Release Tag Details                                   ="
    echo "===================================================================================="
    echo "Current Release Branch: $(tput setaf 6)$(tput bold)$BRANCH$(tput sgr0)"
    echo "Current Tag:            $(tput setaf 6)$(tput bold)$CURRENT_TAG$(tput sgr0)"
    echo "New Release Tag:        $(tput setaf 6)$(tput bold)$NEW_RELEASE_TAG$(tput sgr0)"
    echo

    while true; do
      read -p "Is the above an acceptable release tag revision? [y/n] " tag_it
      case $tag_it in
        [yY]* ) echo "New release tag $(tput setaf 2)$(tput bold)$NEW_RELEASE_TAG$(tput sgr0) created"
                echo
                $(svn copy http://[SVN_SERVER]/svn/$1/branches/$BRANCH http://[SVN_SERVER]/svn/$1/tags/$NEW_RELEASE_TAG -m '$2')
                svnlt $1 |grep $NEW_RELEASE_TAG
                break;;
        [nN]* ) echo "$(tput setaf 1)Tag not created, exiting...$(tput sgr0)"
                break;;
        * ) echo 'Please enter [Y|y] to create the tag or [N|n] to exit without creating a tag'
      esac
    done
  fi
}

