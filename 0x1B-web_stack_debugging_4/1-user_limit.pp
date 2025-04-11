# This manifest increases open file limits for all users to fix login errors

exec { 'increase_open_file_limits':
  command => 'echo "* soft nofile 4096\n* hard nofile 4096" > /etc/security/limits.conf',
  path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
}
