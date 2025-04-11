# This manifest fixes Nginx configuration to handle high traffic properly

exec { 'fix--for-nginx':
  command => 'sed -i "/^worker_processes/c\worker_processes auto;" /etc/nginx/nginx.conf && service nginx restart',
  path    => '/usr/bin:/usr/sbin:/bin:/sbin',
}

