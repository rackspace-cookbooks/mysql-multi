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

include_recipe 'apt' if node.platform_family?('debian')
include_recipe 'mysql-multi::_find_master'
include_recipe 'mysql-multi'

# creates unique serverid via ipaddress to an int
require 'ipaddr'
serverid = IPAddr.new node['ipaddress']
serverid = serverid.to_i

# drop slave.cnf configuration file
mysql_config 'slave replication' do
  config_name 'replication'
  cookbook node['mysql-multi']['templates']['slave.cnf']['cookbook']
  instance node['mysql-multi']['service_name']
  source node['mysql-multi']['templates']['slave.cnf']['source']
  variables(
    cookbook_name: cookbook,
    server_id: serverid,
    mysql_instance: node['mysql-multi']['service_name']
  )
  notifies :restart, "mysql_service[#{node['mysql-multi']['service_name']}]", :immediately
  action :create
end

# sync slaves to master
mysqlm_slave_sync 'slaves' do
  replpasswd node['mysql-multi']['server_repl_password']
  rootpasswd node['mysql-multi']['server_root_password']
  master_ip node['mysql-multi']['master_ip']
end

# drop .my.cnf file
mysqlm_dot_my_cnf 'root' do
  passwd node['mysql-multi']['server_root_password']
end

tag('mysql_slave')
