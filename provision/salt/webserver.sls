group-www-data:
  group.present:
    - name: www-data
    - gid: 510

user-www-data:
  user.present:
    - name: www-data
    - uid: 510
    - gid: 510
    - groups:
      - www-data
    - require:
      - group: www-data

user-www-deploy:
  user.present:
    - name: www-deploy
    - groups:
      - www-data
    - require:
      - group: www-data

# Provide the cache directory for nginx
/var/cache/nginx:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - require_in:
      - cmd: nginx

# Manage a custom compile script for Nginx.
/root/nginx-compile.sh:
  file.managed:
    - source: salt://config/nginx/compile-nginx.sh
    - user: root
    - group: root
    - mode: 755

# Manage the service init script for Nginx.
/etc/init.d/nginx:
  file.managed:
    - name: /etc/init.d/nginx
    - source: salt://config/nginx/init-nginx
    - user: root
    - group: root
    - mode: 755
    - require_in:
      - cmd: nginx

# Compile and install Nginx.
nginx:
  cmd.run:
    - name: sh nginx-compile.sh
    - cwd: /root/
    - unless: nginx -V &> nginx-version.txt && cat nginx-version.txt | grep -A 42 "nginx/1.11.13" | grep "OpenSSL_1_0_2j"
    - require:
      - pkg: src-build-prereq
      - file: /root/nginx-compile.sh
      - user: www-data
      - group: www-data

# Set Nginx to run in levels 2345.
nginx-init:
  cmd.run:
    - name: chkconfig --level 2345 nginx on
    - cwd: /
    - require:
      - cmd: nginx
      - file: /etc/init.d/nginx

# Configure Nginx with a jinja template.
/etc/nginx/nginx.conf:
  file.managed:
    - template: jinja
    - source:   salt://config/nginx/nginx.conf.jinja
    - user:     root
    - group:    root
    - mode:     644
    - require:
      - cmd:    nginx

# Provide a common *.php location block when needed.
/etc/nginx/foghlaim-php-location-common.conf:
  file.managed:
    - source: salt://config/nginx/foghlaim-php-location-common.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: nginx

# Provide a common HTTPS configuration for all sites.
/etc/nginx/foghlaim-ssl-common.conf:
  file.managed:
    - source: salt://config/nginx/foghlaim-ssl-common.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: nginx

/etc/nginx/sites-enabled/:
  file.directory:
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: nginx
    - require_in:
      - file: /etc/nginx/sites-enabled/default

/etc/nginx/sites-enabled/default:
  file.managed:
    - source: salt://config/nginx/default
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: nginx

/etc/nginx/sites-enabled/status.conf:
  file.managed:
    - source: salt://config/nginx/status.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: nginx

/etc/nginx/mime.types:
  file.managed:
    - source: salt://config/nginx/mime.types
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: nginx

# Start the nginx service.
nginx-service:
  service.running:
    - name: nginx
    - require:
      - cmd: nginx
      - cmd: nginx-init
      - file: /etc/init.d/nginx
      - user: www-data
      - group: www-data
    - watch:
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/sites-enabled/*
