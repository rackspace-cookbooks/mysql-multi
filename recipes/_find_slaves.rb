# encoding: UTF-8
#
# Cookbook Name:: mysql-multi
# Recipe:: _find_slaves
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
include_recipe 'chef-sugar'

if Chef::Config[:solo]
  errmsg = 'This recipe uses search if slaves attribute is not set.  Chef Solo does not support search.'
  Chef::Log.warn(errmsg)
elsif node['mysql-multi']['slaves'].nil?
  slave_ips = []
  slaves = search('node', "tags:mysql_slave AND chef_environment:#{node.chef_environment}")

  # in order to check if slaves are found we need to pull the first node from the array and test for nil
  if slaves.nil? || slaves.empty? || slaves.first.nil?
    # fail soft if you're on chef or chef-zero and no slaves were found
    # we don't want to assume any values, and someone intended for slaves
    # since the master recipe was included
    errmsg = 'Did not find MySQL slaves to use, reusing existing attribute'
    node.set['mysql-multi']['slaves'] = nil
    Chef::Log.warn(errmsg)
  else
    slaves.each do |slave|
      slave_ips << best_ip_for(slave)
    end
    node.set['mysql-multi']['slaves'] = slave_ips
  end
  str_slaves = node.deep_fetch('mysql-multi', 'slaves')
  Chef::Log.info("Slave MySQL servers attr was set to #{str_slaves}")
else
  str_slaves = node['mysql-multi']['slaves']
  Chef::Log.info("Slaves MySQL server was already set to #{str_slaves}")
end
