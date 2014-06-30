git add script
git add lib
git add app
git add db
git add config
git add public
if [ $# -eq 0 ] 
then 
git commit -am "c"
else
git commit -am "$*"
fi
git push
