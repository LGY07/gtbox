#!/bin/bash
if test -e ./gbsh.tar;then
mv ./gbsh.tar ~/gbsh.cache
cd ~/
mv ./gbsh.cache ./gbsh.tar
tar -xf ./gbsh.tar
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
fi
echo '#!/bin/bash'>~/gbsh/plugins/null.sh
sudo chmod 751 ~/gbsh ; sudo ln -sf ~/gtbox.sh /usr/bin/gtbox