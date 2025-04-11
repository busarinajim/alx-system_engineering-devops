# Fix Nginx config to handle high traffic with no failed requests

exec { 'tune-nginx':
  command => 'sed -i "s/^worker_processes .*/worker_processes auto;/" /etc/nginx/nginx.conf &&
    sed -i "/events {/a \    worker_connections 1024;" /etc/nginx/nginx.conf &&
    service nginx restart',
  path    => '/usr/bin:/usr/sbin:/bin:/sbin',
  unless  => 'grep "worker_connections 1024;" /etc/nginx/nginx.conf',
}
