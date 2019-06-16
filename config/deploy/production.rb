server '13.115.176.5', user: 'ec2-user', roles: %w{app db web}
set :ssh_options, keys: [File.expand_path('/Users/wakayamayuki/workspace/key_management/mappura-4-key.pem')]
# set :ssh_options, keys: '/Users/wakayamayuki/.ssh/id_rsa'
