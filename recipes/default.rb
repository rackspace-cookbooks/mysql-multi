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

mysql_service 'default'

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
  cookbook 'mysql-multi'
  source 'my.cnf.erb'
  variables(
    serverid: serverid,
    cookbook_name: cookbook_name,
    bind_address: node['mysql-multi']['bind_ip']
  )
  notifies :restart, 'mysql_service[default]', :delayed
end

# add /root/.my.cnf file to system for local MySQL management
template '/root/.my.cnf' do
  cookbook 'mysql-multi'
  source 'user.my.cnf.erb'
  owner 'root'
  group 'root'
  mode '0600'
  variables(
    cookbook_name: cookbook_name,
    user: 'root',
    pass: node['mysql']['server_root_password']
  )
end
