# This manifest configures Nginx to handle high traffic by setting worker_processes to auto

exec { 'fix_nginx_config':
  command => 'sed -i "s/worker_processes [0-9]*/worker_processes auto/" /etc/nginx/nginx.conf',
  path    => '/usr/bin:/usr/sbin:/bin:/sbin',
}

exec { 'restart_nginx':
  command => 'service nginx restart',
  path    => '/usr/bin:/usr/sbin:/bin:/sbin',
  require => Exec['fix_nginx_config'],
}
