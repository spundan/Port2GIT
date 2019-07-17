#!/bin/bash
trap "exit" INT

echo -n "Enter the subversion URL and press [ENTER]: "
read URL


echo -n "Enter the subversion username and press [ENTER]: "
read username


echo "##############################################
Cloning into svn folder"
svn checkout --username $username $URL ./svn


echo "##############################################
- Retrieving a list of all Subversion committers
- That will grab all the log messages, pluck out the usernames, eliminate any duplicate usernames, sort the usernames and place them into a svn-authors.txt file."
cd ./svn
svn log -q | awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' | sort -u > ../svn-authors.txt


echo "##############################################
- Subversion simply lists the username for each commit. Git’s commits have much richer data, but at its simplest, the commit author needs to have a name and email listed. By default the git-svn tool will just list the SVN username in both the author and email fields. But with a little bit of work, you can create a list of all SVN users and what their corresponding Git name and emails are. This list can be used by git-svn to transform plain svn usernames into proper Git committers.
- Now edit each line in the file. For example, convert:

user1 = user1 <user1>
into this:
user1 = user1 <user1@hisemail.com>

##############################################
This is the list of authors:"
cd ..
cat svn-authors.txt
read -p "


##############################################
Press enter to start editing the authors file"
nano svn-authors.txt
read -p "


##############################################
All ready to clone SVN to Git!
Press enter to continue!
"
git svn clone $URL --no-metadata -A svn-authors.txt --stdlayout ./git


cd ./git
echo -n "Enter the Git web URL and press [ENTER]: "
read GITURL
git remote rename origin old-origin
git remote add origin $GITURL
git push -u origin --all
git push -u origin --tags
# git remote add origin $GITURL
# git push -u origin master
echo "Done !"