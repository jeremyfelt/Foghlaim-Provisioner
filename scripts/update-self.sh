cd /tmp && rm -fr foghlaim-web
cd /tmp && curl -o foghlaim-web.zip -L https://github.com/jeremyfelt/foghlaim-provisioner/archive/master.zip
cd /tmp && unzip foghlaim-web.zip
cd /tmp && mv Foghlaim-Provisioner-master foghlaim-web
cp -fr /tmp/foghlaim-web/provision/salt /srv/
cp /tmp/foghlaim-web/provision/salt/config/yum.conf /etc/yum.conf
rm /etc/salt/minion.d/*.conf
cp /tmp/foghlaim-web/provision/salt/minions/foghlaim-web.conf /etc/salt/minion.d/
cp /tmp/foghlaim-web/scripts/*.sh /home/jeremyfelt/
