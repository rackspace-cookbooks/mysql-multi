mysql-multi
===========

[![Circle CI](https://circleci.com/gh/rackspace-cookbooks/mysql-multi.svg?style=svg)](https://circleci.com/gh/rackspace-cookbooks/mysql-multi)

Chef wrapper cookbook to create master/slave MySQL server setups. This wrapper
should work on all Debian and RHEL platform family OS's.

Utilization
------------

This cookbook provides libraries to work along with MySQL community cookbook to
allow for the creation of master/slave and master/multi-slave MySQL systems.

The recipes and libraries provided here are designed for clean initial server setups of
this type of systems. They are not designed to do any type of fail-over, this type
of automation is better addressed by other tools.

*** Special Note:
This cookbook only supports MySQL community cookbook version 6.x, major changes
in this cookbook prior to version 6 have caused it to not be backwards compatible.
If you need support for MySQL community cookbook 5.x then use version 1.4.2 of
this cookbook.

This cookbook provides two recipes depending on the server's role. Keep in mind this
cookbook as well as the community MySQL cookbook have gone to a pure library design.
These recipes are provided for backwards compatibility and as examples of how to
write wrapper recipes to utilize the libraries. They may be removed in later releases.

`default.rb` : install a MySQL server instance.

`mysql_master.rb` : sets up a master MySQL server and creates replicant users
for each slave node defined within attributes. This recipe only configures master
specific configurations, it expects default.rb to be ran prior for proper converge.

When utilized, search will look for the node(s) in the same environment with the tag
`mysql_slave` and grant the allowed replicating node(s). If you do not want to
use search, create the slave node(s) first before bootstrapping, and set the
attribute `['mysql-multi']['master']` with the correct IP array.

`mysql_slave.rb` : sets up a slave MySQL server pointing to the master node
defined within attributes. This recipe only configures slave specific
configurations, it expects default.rb to be ran prior for proper converge.

Search will look for the node in the same environment with the tag
`mysql_master` and set master replication to that node. If you do not want to
use search, create the master node first before bootstrapping, and set the
attribute `['mysql-multi']['master']` with the correct IP.

Note that once a master has been discovered, it will no longer be automatically
changed to new masters as they are deployed. If a new master is installed, or
the existing master is deleted, you must manually set a new master for existing
slaves by editing the `['mysql-multi']['master']` attribute as described below.

Attributes
-----------

`['mysql-multi']['master']` : sets the IP address that defines the master node

`['mysql-multi']['slaves']` : is any array that defines the IP address(es) of
the slave node(s).

`['mysql-multi']['slave_user']` : allows for the setting of a custom name for
the slave MySQL user, by default it is set to 'replicant'.

`['mysql-multi']['server_repl_password']` : sets password for replicant user

`['mysql-multi']['bind_ip']` is an override for the logic that determines the
best `bind_address` for mysql. Allowing you to set it to whatever is needed for
your specific configuration.

`['mysql-multi']['install_recipe']` default behaviour is to install MySQL using 
mysql-multi::default recipe, however this allows the use of your own custom recipe
should you require alternative configuration (e.g. data directory). Default to 'mysql-multi'

`['mysql-multi']['serverid']` default behaviour is to use a unique ID create from
the IP address, however this allows manual overriding. Default to nil

Additional attributes added due to the redesign of the community MySQL recipe.

`['mysql-multi']['server_root_password']` sets root password for MySQL service.

`['mysql-multi']['service_name']` sets name for mysql service used in MySQL community recipe. Default is set to 'chef'

`['mysql-multi']['server_version']` sets version of mysql installed via MySQL community cookbook. Defaults to 5.5.

`['mysql-multi']['bind_address'] ` sets listening bind_address to 0.0.0.0 by default

`['mysql-multi']['service_port']` sets listening port for MySQL service. Default to 3306.

Notice on need for mysql2 gem
-------------------------------

The libraries (specifically slave_grants and slave_sync) require the mysql2 gem to be
installed on the nodes. This is currently done within the slave/master sample recipes. If
you are calling these libraries directly you need to ensure you are addressing this
requirement.

It can be addresses by adding the cookbook `mysql2_chef_gem' to your depends lists
as well as adding this code to your recipe:

```ruby

mysql2_chef_gem 'default' do
  client_version node['mysql-multi']['server_version']
  action :install
end

```

Custom my.cnf settings
------------------------

Currently the community MySQL cookbook does not address the need to add custom my.cnf configuration options to the default my.cnf file.

It simply drops the default my.cnf provided by the OS. You are expected to write a custom my.cnf file and add it to the /etc/mysql-service/conf.d/ directory if needed.

This can be done using the mysql_config resource, below is an example of what that might look like:

```ruby

mysql_config 'custom my.cnf stuff' do
  config_name 'custom.my.cnf'
  instance 'default'
  source 'custom.my.cnf.erb'
  variables(:foo => 'bar')
  action :create
  notifies :restart, 'mysql_service[default]'
end

```

For additional documentation and examples see [MySQL community README] (https://github.com/chef-cookbooks/mysql)


License & Authors
-----------------
- Author:: Christopher Coffey (<christopher.coffey@rackspace.com>)
- Author:: Brint O'Hearn (<brint.ohearn@rackspace.com>)
- Author:: BK Box (<bk@theboxes.org>)

```text

Copyright:: 2014-2015 Rackspace US, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
