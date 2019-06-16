server '13.115.176.5', user: 'ec2-user', roles: %w{app db web}
set :ssh_options, keys: '/Users/wakayamayuki/.ssh/id_rsa'
