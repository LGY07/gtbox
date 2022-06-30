#!/bin/bash
if test -e ./gbsh.tar;then
tar -xf ./gbsh.tar
cp -rf gbsh ~/gbsh
else
mkdir ~/gbsh
cd ~/gbsh
curl -LO https://blog.lgy07.me/gtbox/lts/gtbox.sh
curl -LO https://blog.lgy07.me/gtbox/lts/gbsh/gbsh.cfg
mkdir cache
mkdir pkgs
mkdir pkgs_path
mkdir plugins
curl -LO https://blog.lgy07.me/gtbox/lts/init.tar
tar -xf init.tar
rm init.tar
echo '#!/bin/bash'>~/gbsh/plugins/null.sh
fi
sudo chmod +x ~/gbsh ; sudo chmod +x ~/gbsh/gtbox.sh ; sudo ln -sf ~/gtbox.sh /usr/bin/gtbox