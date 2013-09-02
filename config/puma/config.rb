 #!/usr/bin/env puma

# The directory to operate out of.
directory '/usr/share/puppet/rack/puppetmasterd'

# Set the environment in which the rack's app will run. The value must be a string.
environment 'production'

# Daemonize the server into the background.
daemonize

# Store the pid of the server in the file at “path”.
pidfile '/var/run/puppet/puppetmaster_puma.pid'

# Use “path” as the file to store the server info state.
state_path '/var/run/puppet/puppetmaster_puma.state'

# Redirect STDOUT and STDERR to files specified.
stdout_redirect '/var/log/puppet/puppetmaster_puma.log', '/var/log/puppetmaster_puma_err.log', true

# Bind the server to “url”. “tcp://”, “unix://” and “ssl://” are the only
bind 'unix:///var/run/puppet/puppetmaster_puma.sock'

# How many worker processes to run.
workers 2
preload_app!
