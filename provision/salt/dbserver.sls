# Our CentOS image comes with MySQL 5.1.6 preinstalled. We should
# remove these packages before replacing with MySQL 5.5
old-mysql:
  pkg.removed:
    - pkgs:
      - mysql
      - mysql-libs
      - mysql-server

mysql55-server:
  pkg.installed

mysql55:
  service.running:
    - name: mysqld
    - require:
      - pkg: mysql55-server