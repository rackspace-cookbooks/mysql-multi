# encoding: UTF-8
#
# Cookbook Name:: mysql-multi
# Recipe:: mysql_master
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
include_recipe node['mysql-multi']['install_recipe']
include_recipe 'mysql-multi::_find_slaves'

if node['mysql-multi']['serverid'].nil?
  # creates unique serverid via ipaddress to an int
  require 'ipaddr'
  serverid = IPAddr.new node['ipaddress']
  serverid = serverid.to_i
else
  serverid = node['mysql-multi']['serverid']
end

# drop master.cnf configuration file
mysql_config 'master replication' do
  config_name 'replication'
  cookbook node['mysql-multi']['templates']['master.cnf']['cookbook']
  instance node['mysql-multi']['service_name']
  source node['mysql-multi']['templates']['master.cnf']['source']
  variables(
    cookbook_name: cookbook,
    server_id: serverid,
    mysql_instance: node['mysql-multi']['service_name']
  )
  notifies :restart, "mysql_service[#{node['mysql-multi']['service_name']}]", :immediately
  action :create
end

# grant replication user privs for slave servers
if node['mysql-multi']['slaves'].nil?
  errmsg = 'Unable to determine any slaves, skipping grants'
  Chef::Log.warn(errmsg)
else
  mysqlm_slave_grants 'master' do
    replpasswd node['mysql-multi']['server_repl_password']
    rootpasswd node['mysql-multi']['server_root_password']
    slaves node['mysql-multi']['slaves']
  end
end

tag('mysql_master')
