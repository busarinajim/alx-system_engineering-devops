# Puppet manifest to fix Nginx failing under high load by increasing ulimit and worker connections

# Increase ulimit for Nginx user
file { '/etc/security/limits.conf':
  ensure  => file,
  content => template('nginx/limits.conf.erb'),
  mode    => '0644',
}

# Ensure Nginx configuration allows more connections
file { '/etc/nginx/nginx.conf':
  ensure  => file,
  content => template('nginx/nginx.conf.erb'),
  mode    => '0644',
  notify  => Service['nginx'],
}

# Ensure Nginx service is running and restarts if config changes
service { 'nginx':
  ensure     => running,
  enable     => true,
  hasrestart => true,
}

# Execute command to apply ulimit change to running session (optional for immediate effect)
exec { 'apply-ulimit':
  command     => 'ulimit -n 65535',
  path        => ['/bin', '/usr/bin'],
  refreshonly => true,
  subscribe   => File['/etc/security/limits.conf'],
}
