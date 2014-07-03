#
# Cookbook Name:: mysql-multi
# Recipe:: mysql_master
#
# Copyright 2014, Rackspace US, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'mysql-multi'
include_recipe 'mysql-multi::_find_slaves'

# drop MySQL master specific configuration file
template '/etc/mysql/conf.d/master.cnf' do
  source 'master.cnf.erb'
  variables(
    cookbook_name: cookbook_name
  )
  notifies :restart, 'mysql_service[default]', :delayed
end

# Grant replication on slave(s)
node['mysql-multi']['slaves'].each do |slave|
  execute 'grant-slave' do
    command <<-EOH
    /usr/bin/mysql -u root -p'#{node['mysql']['server_root_password']}' < /root/grant-slaves.sql
    rm -f /root/grant-slaves.sql
    EOH
    action :nothing
  end

  template '/root/grant-slaves.sql' do
    path '/root/grant-slaves.sql'
    source 'grant.slave.erb'
    owner 'root'
    group 'root'
    mode '0600'
    variables(
      user: node['mysql-multi']['slave_user'],
      password: node['mysql-multi']['server_repl_password'],
      host: slave
    )
    notifies :run, 'execute[grant-slave]', :immediately
  end
end

tag('mysql_master')
