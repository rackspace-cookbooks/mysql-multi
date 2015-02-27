# encoding: UTF-8
#
# Cookbook Name:: mysql-multi
# Recipe:: mysql_slave
#
# Copyright 2015, Rackspace US, Inc.
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

include_recipe 'mysql-multi::_find_master'
include_recipe 'mysql-multi'

# creates unique serverid via ipaddress to an int
require 'ipaddr'
serverid = IPAddr.new node['ipaddress']
serverid = serverid.to_i

mysql_config 'slave replication' do
  config_name 'replication'
  cookbook node['mysql-multi']['templates']['slave.cnf']['cookbook']
  instance node['mysql']['service_name']
  source node['mysql-multi']['templates']['slave.cnf']['source']
  variables(
    cookbook_name: cookbook,
    server_id: serverid,
    mysql_instance: node['mysql']['service_name']
  )
  notifies :restart, "mysql_service[#{node['mysql']['service_name']}]", :immediately
  action :create
end
# Connect slave to master MySQL server
execute 'change master' do
  command <<-EOH
  /usr/bin/mysql -h 127.0.0.1 -u root -p'#{node['mysql']['server_root_password']}' < /root/change.master.sql
  rm -f /root/change.master.sql
  EOH
  action :nothing
end

template '/root/change.master.sql' do
  path '/root/change.master.sql'
  source 'change.master.erb'
  owner 'root'
  group 'root'
  mode '0600'
  variables(
    host: node['mysql-multi']['master'],
    user: node['mysql-multi']['slave_user'],
    password: node['mysql-multi']['server_repl_password']
  )
  notifies :run, 'execute[change master]', :immediately
end

tag('mysql_slave')
