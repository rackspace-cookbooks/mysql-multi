mysql-multi
===========

Chef wrapper cookbook to create master/slave MySQL server setups. This wrapper should work on all Debian and RHEL platform family OS's.

Utilization
------------

Cookbook works as a wrapper around the community MySQL cookbook to allow for the creation of master/slave and master/multi-slave MySQL systems.

The cookbook utilizes two recipes depending on the server's role.

`mysql_master.rb` : sets up a master MySQL server and creates replicant users for each slave node definded within attributes.

`mysql_slave.rb` : sets up a slave MySQL server pointing to the master node definded within attributes.

Keep in mind this is a stripped down, simple MySQL replication wrapper cookbook. The only thing that must be done to make the cookbook work is the servers have to be created prior to bootstrapping chef since you have to set the IP addresses of the servers within attributes for discovery. We do not use a self discovery mechanism such as search for this recipe. I tend to set these attributes as environment variable to make setup easy, but they can be set in various ways, depending on your use case.

Attributes
-----------

`['mysql-multi']['master']` : sets the IP address that defines the master node

`['mysql-multi']['slaves']` : is any array that defines the IP address(es) of the slave node(s).

`['mysql-multi']['slave_user']` : allows for the setting of a custom name for the slave MySQL user, by default it is set to 'replicant'.

`['mysql-multi']['server_repl_password']` : is set to match `['mysql']['server_repl_password']` just to keep attribute names uniform throughout this cookbook.


License & Authors
-----------------
- Author:: Christopher Coffey (<christopher.coffey@rackspace.com>)
- Author:: Brint O'Hearn (<brint.ohearn@rackspace.com>)

```text

Copyright:: 2014 Rackspace US, Inc

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