git add script
git add lib
git add app
git add db
git add config
if [ $# -eq 0 ] 
then 
git commit -am "c"
else
echo git commit -am $*
git commit -am "$*"
fi
git push
