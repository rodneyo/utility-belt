#create a release branch
# requires that you name your release branches and tags follow the following convention
#
# release_branch.[major rev 1-9].[tag number 1-9]
#
# function will ask if you are creating a major or minor branch and increment that revision by 1
# # example: release_branch.1.0 will become release_branch.1.1 for a minor rev and
#            release_branch.1.0 will become release_branch2.0 for a major rev
function svncb() {
  if [[ -z $1 ]]; then
    echo "svn repo needed. Usage: snvrelease [svn repo]"
  else
    local RAW_BRANCH=`exec 6>&2 2>/dev/null; svn log -v http://[SVN_SERVER]/svn/$1/branches | awk '/^   A/ { print $2 }' | head -1; exec 2>&6 6>&-`
    local BRANCH=`echo $RAW_BRANCH | awk -F/ '{print $3}'`
    local CURRENT_MAX_RELEASE_NBR=$(echo $BRANCH | awk -F '.' '{ print $2 }')
    local CURRENT_MIN_RELEASE_NBR=$(echo $BRANCH | awk -F '.' '{ print $3 }')

    while true; do
      read -p "$(tput setaf 3)$(tput bold)Will this be major or minor release branch? [min=Minor | max=Major | q to exit]$(tput sgr0) " branch_type
      case $branch_type in 

         min )   echo "Creating a new minor branch..."
                 local NEW_MIN_RELEASE_NBR=$(( CURRENT_MIN_RELEASE_NBR  + 1 ))
                 local NEW_RELEASE_BRANCH=release_branch.$CURRENT_MAX_RELEASE_NBR.$NEW_MIN_RELEASE_NBR
                 break;;

         max )   echo "Creating a new major branch..."
                 local NEW_MAX_RELEASE_NBR=$(( CURRENT_MAX_RELEASE_NBR  + 1 ))
                 local NEW_RELEASE_BRANCH=release_branch.$NEW_MAX_RELEASE_NBR.0
                 break;;

         [qex] ) return;;

         * )     echo "$(tput setaf 3)$(tput bold)Please enter [min] for a Minor branch or [max] for a Major branch$(tput sgr0) "
      esac
    done

    echo "===================================================================================="
    echo "=                            Release Branch Details                                ="
    echo "===================================================================================="
    echo "Current Release Branch: $BRANCH"
    if [[ $branch_type == 'min' ]]; then
        echo "$(tput setaf 6)$(tput bold)New minor branch: $NEW_RELEASE_BRANCH$(tput sgr0)"
    elif [[ $branch_type == 'max' ]]; then
        echo "$(tput setaf 6)$(tput bold)New major branch: $NEW_RELEASE_BRANCH$(tput sgr0)"
    fi
    
    while true; do
      read -p "$(tput setaf 3)$(tput bold)Is the above an acceptable release branch revision? [y/n]$(tput sgr0) " branch_it
      case $branch_it in
         [yY]*) echo "Creating the release branch: $(tput setaf 2)$(tput bold)$NEW_RELEASE_BRANCH$(tput sgr0)"
                echo svn copy http://[SVN SERVER]/svn/$1/trunk http://[SVN_SERVER]/svn/$1/branches/$NEW_RELEASE_BRANCH
                svnlb $1 |grep $NEW_RELEASE_BRANCH
                break;;
        [nN]* ) echo "$(tput setaf 1)Branch not created, existing...$(tput sgr0)"
                break;;
        * ) echo "Please enter [Y|y] to create the branch or [N|n] to exit without creating the branch"
     esac
    done
  fi
}
