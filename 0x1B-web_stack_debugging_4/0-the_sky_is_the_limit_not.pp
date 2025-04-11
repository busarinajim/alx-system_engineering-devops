# Puppet manifest to fix Nginx failing under high load by increasing ulimit and worker connections

# Increase ulimit for Nginx user
file { '/etc/security/limits.conf':
  ensure  => file,
  content => "# Increase file descriptor limit for Nginx\nwww-data soft nofile 65535\nwww-data hard nofile 65535\n",
  mode    => '0644',
}

# Ensure Nginx configuration allows more connections
file { '/etc/nginx/nginx.conf':
  ensure  => file,
  content => @('END_OF_NGINX_CONF')
user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
    worker_connections 4096; # Increased from default
    multi_accept on;
}

http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    gzip on;

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
| END_OF_NGINX_CONF
  mode    => '0644',
  notify  => Service['nginx'],
}

# Ensure Nginx service is running and restarts if config changes
service { 'nginx':
  ensure     => running,
  enable     => true,
  hasrestart => true,
}
