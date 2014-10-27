# encoding: UTF-8
#
# Cookbook Name:: mysql-multi
# Recipe:: default
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

# run apt-get update to clear cache issues
include_recipe 'apt' if node.platform_family?('debian')
include_recipe 'chef-sugar'

mysql_service node['mysql']['service_name'] do
  version node['mysql']['version']
  port node['mysql']['port']
  data_dir node['mysql']['data_dir']
  server_root_password node['mysql']['server_root_password']
  server_debian_password node['mysql']['server_debian_password']
  server_repl_password node['mysql-multi']['server_repl_password']
  allow_remote_root node['mysql']['allow_remote_root']
  remove_anonymous_users node['mysql']['remove_anonymous_users']
  remove_test_database node['mysql']['remove_test_database']
  root_network_acl node['mysql']['root_network_acl']
  package_version node['mysql']['server_package_version']
  package_action node['mysql']['server_package_action']
  action :create
end

# creates unique serverid via ipaddress to an int
require 'ipaddr'
serverid = IPAddr.new node['ipaddress']
serverid = serverid.to_i

node.set_unless['mysql-multi']['bind_ip'] = best_ip_for(node)

# creates /etc/mysql/conf.d if it does not exist
directory '/etc/mysql/conf.d' do
  action :create
  recursive true
end

# drop custom my.cnf file
template '/etc/mysql/conf.d/my.cnf' do
  cookbook node['mysql-multi']['templates']['my.cnf']['cookbook']
  source node['mysql-multi']['templates']['my.cnf']['source']
  variables(
    serverid: serverid,
    cookbook_name: cookbook_name,
    bind_address: node['mysql-multi']['bind_ip']
  )
  notifies :restart, "mysql_service[#{node['mysql']['service_name']}]", :delayed
end

# add /root/.my.cnf file to system for local MySQL management
template '/root/.my.cnf' do
  cookbook node['mysql-multi']['templates']['user.my.cnf']['cookbook']
  source node['mysql-multi']['templates']['user.my.cnf']['source']
  owner 'root'
  group 'root'
  mode '0600'
  variables(
    cookbook_name: cookbook_name,
    user: 'root',
    pass: node['mysql']['server_root_password']
  )
end
