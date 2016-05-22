#!/bin/bash
#
cp -fr ../provision/salt /srv/
cp ../provision/salt/config/yum.conf /etc/yum.conf
mkdir -p /srv/pillar/

# If running initial setup on an existing setup, customizations
# will be overwritten.
cp ../pillars/*.sls /srv/pillar/

# Start by installing Salt.
sh ./bootstrap-salt.sh -K stable

rm -fr /etc/salt/minion.d/*.conf
cp ../provision/salt/minions/foghlaim-web.conf /etc/salt/minion.d/
echo "foghlaim-web" > /etc/salt/minion_id
