# encoding: UTF-8
#
# Cookbook Name:: mysql-multi
# Recipe:: _find_master
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
  errmsg = 'This recipe uses search if master attribute is not set.  Chef Solo does not support search.'
  Chef::Application.fatal!(errmsg, 1)
elsif node['mysql-multi']['master'].nil?
  master = search('node', 'tags:mysql_master' << " AND chef_environment:#{node.chef_environment}")
  Chef::Log.warn('Multiple servers tagged as master found!') if master.count > 1
  # needed because the search returns a list, so nil? is always true
  master = master.first

  if !master.nil?
    node.set['mysql-multi']['master'] = best_ip_for(master.first)
  else
    errmsg = 'Did not find a MySQL master to use, but one was not set'
    Chef::Application.fatal!(errmsg, 1)
    # fail hard if you're on chef or chef-zero and no master was found
    # we don't want to assume localhost or any other value, and cause more
    # problems or an outage
  end
else
  str_master = node['mysql-multi']['master']
  Chef::Log.info("Master MySQL server was already set to #{str_master}")
end
