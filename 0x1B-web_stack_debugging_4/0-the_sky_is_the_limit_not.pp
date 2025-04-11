# This manifest configures Nginx to handle high traffic loads

exec { 'tune_nginx_worker_processes':
  command => 'sed -i "s/^worker_processes .*/worker_processes auto;/" /etc/nginx/nginx.conf',
  path    => ['/usr/bin', '/usr/sbin', '/bin', '/sbin'],
  onlyif  => 'grep -q "^worker_processes [0-9];" /etc/nginx/nginx.conf',
}

exec { 'restart_nginx':
  command => 'service nginx restart',
  path    => ['/usr/bin', '/usr/sbin', '/bin', '/sbin'],
  require => Exec['tune_nginx_worker_processes'],
}

