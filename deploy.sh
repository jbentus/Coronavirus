dotnet publish ./Client -c Release -o ./publish

mv ./publish/wwwroot/index.html ./publish/wwwroot/200.html

surge --domain coronavirus-2019.surge.sh ./publish/wwwroot
