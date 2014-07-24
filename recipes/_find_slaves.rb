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
if Chef::Config[:solo]
  errmsg = 'This recipe uses search if slaves attribute is not set. \
    Chef Solo does not support search.'
  Chef::Application.fatal!(errmsg, 1)
elsif node['mysql-multi']['slaves'].nil? || node['mysql-multi']['slaves'].empty?
  slave_ips = []
  slaves = search('node', 'tags:mysql_slave'\
                  " AND chef_environment:#{node.chef_environment}")

  if !slaves.nil?
    slaves.each do |slave|
      slave_ips << best_ip_for(slave)
    end
    node.set['mysql-multi']['slaves'] = slave_ips
  else
    errmsg = 'Did not find MySQL slaves to use, but none were set'
    Chef::Application.fatal!(errmsg, 1)
    # fail hard if you're on chef or chef-zero and no slaves were found
    # we don't want to assume any values, and someone intended for slaves
    # since the master recipe was included
  end
else
  str_slaves = node['mysql-multi']['slaves']
  Chef::Log.info("Slave MySQL servers attr was already set to #{str_slaves}")
end
