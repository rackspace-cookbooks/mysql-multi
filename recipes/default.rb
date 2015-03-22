# encoding: UTF-8
#
# Cookbook Name:: mysql-multi
# Recipe:: default
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

# run apt-get update to clear cache issues
include_recipe 'apt' if node.platform_family?('debian')
include_recipe 'chef-sugar'

node.set_unless['mysql-multi']['bind_ip'] = best_ip_for(node)

# set passwords dynamically...
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless['mysql-multi']['server_root_password'] = secure_password

mysql_service node['mysql-multi']['service_name'] do
  version node['mysql-multi']['server_version']
  bind_address node['mysql-multi']['bind_address']
  port node['mysql-multi']['service_port']
  initial_root_password node['mysql-multi']['server_root_password']
  action [:create, :start]
end

# add /root/.my.cnf file to system for local MySQL management
mysqlm_dot_my_cnf 'root' do
  passwd node['mysql-multi']['server_root_password']
end

mysql2_chef_gem 'default' do
  action :install
  client_version node['mysql-multi']['server_version']
end
