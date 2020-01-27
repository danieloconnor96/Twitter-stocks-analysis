#Github sync 

#run the below in Terminal

# initiate the upstream tracking of the project on the GitHub repo
git remote set-url origin https://github.com/danieloconnor96/Twitter-stocks-analysis

# pull all files from the GitHub repo (only file currently is README to test sync)
git pull origin master

# set up GitHub repo to track changes on local machine
git push -u origin master

