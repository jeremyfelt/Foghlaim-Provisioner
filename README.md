# Foghlaim Provisioner

Handles provisioning for Foghlaim servers.

* [Salt](http://www.saltstack.com/community/) is used to manage configuration and provisioning.
* [Vagrant](http://vagrantup.com) is used to provide development environments.

## Initial Configuration on EC2

```
curl -LO https://github.com/jeremyfelt/Foghlaim-Provisioner/archive/ec2-centos7.tar.gz
tar -xzf ec2-centos7.tar.gz
cd Foghlaim-Provisioner-master/scripts/
sh 00-initial-setup.sh
```

## Regular Provisioning
