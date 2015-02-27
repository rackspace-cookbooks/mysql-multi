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
node.set_unless['mysql']['server_root_password'] = secure_password
node.save

mysql_service "#{node['mysql']['service_name']}" do
  version node['mysql']['version']
  bind_address node['mysql']['bind_address']
  port node['mysql']['port']
  initial_root_password node['mysql']['server_root_password']
  action [:create, :start]
end

# add /root/.my.cnf file to system for local MySQL management
template '/root/.my.cnf' do
  cookbook node['mysql-multi']['templates']['user.my.cnf']['cookbook']
  source node['mysql-multi']['templates']['user.my.cnf']['source']
  owner 'root'
  group 'root'
  mode '0600'
  variables(
    cookbook_name: node['mysql-multi']['templates']['user.my.cnf']['cookbook'],
    host: '127.0.0.1',
    user: 'root',
    pass: node['mysql']['server_root_password']
  )
end
