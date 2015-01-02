# encoding: UTF-8
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

# set repl password
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless['mysql-multi']['server_repl_password'] = secure_password

include_recipe 'chef-sugar'
include_recipe 'mysql-multi::_find_slaves'
include_recipe 'mysql-multi'

# drop MySQL master specific configuration file
template '/etc/mysql/conf.d/master.cnf' do
  cookbook node['mysql-multi']['templates']['master.cnf']['cookbook']
  source node['mysql-multi']['templates']['master.cnf']['source']
  variables(
    cookbook_name: cookbook_name
  )
  notifies :restart, "mysql_service[#{node['mysql']['service_name']}]", :delayed
end

execute 'grant-slave' do
  command <<-EOH
  /usr/bin/mysql -u root -p'#{node['mysql']['server_root_password']}' < /root/grant-slaves.sql
  rm -f /root/grant-slaves.sql
  EOH
  action :nothing
end

# Grant replication on slave(s)
node['mysql-multi']['slaves'].each do |slave|
  template "/root/grant-slaves.sql #{slave}" do
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

node.set_unless['mysql-multi']['master'] = best_ip_for(node)

tag('mysql_master')
