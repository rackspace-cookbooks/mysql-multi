# encoding: UTF-8

default['mysql-multi']['master'] = nil
default['mysql-multi']['slaves'] = nil
default['mysql-multi']['slave_user'] = 'replicant'
default['mysql-multi']['server_repl_password'] = nil
default['mysql-multi']['bind_ip'] = nil

default['mysql-multi']['templates']['my.cnf']['cookbook'] = 'mysql-multi'
default['mysql-multi']['templates']['my.cnf']['source'] = 'my.cnf.erb'

default['mysql-multi']['templates']['user.my.cnf']['cookbook'] = 'mysql-multi'
default['mysql-multi']['templates']['user.my.cnf']['source'] = 'user.my.cnf.erb'

default['mysql-multi']['templates']['slave.cnf']['cookbook'] = 'mysql-multi'
default['mysql-multi']['templates']['slave.cnf']['source'] = 'slave.cnf.erb'

default['mysql-multi']['templates']['master.cnf']['cookbook'] = 'mysql-multi'
default['mysql-multi']['templates']['master.cnf']['source'] = 'master.cnf.erb'

# additional mysql namespace attributes needed for recipe since community
# cookbook moved to version 6.x

default['mysql-multi']['install_recipe'] = 'mysql-multi'
default['mysql-multi']['server_root_password'] = nil
default['mysql-multi']['service_name'] = 'chef'
default['mysql-multi']['server_version'] = '5.5'
default['mysql-multi']['bind_address'] = '0.0.0.0'
default['mysql-multi']['service_port'] = '3306'
default['mysql-multi']['serverid'] = nil
