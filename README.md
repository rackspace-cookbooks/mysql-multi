mysql-multi
===========

Chef wrapper cookbook to create master/slave MySQL server setups. This wrapper
should work on all Debian and RHEL platform family OS's.

Utilization
------------

Cookbook works as a wrapper around the community MySQL cookbook to allow for
the creation of master/slave and master/multi-slave MySQL systems.

The cookbook utilizes two recipes depending on the server's role.

`mysql_master.rb` : sets up a master MySQL server and creates replicant users
for each slave node definded within attributes.

Search will look for the node(s) in the same environment with the tag
`mysql_slave` and grant the allowed replicating node(s). If you do not want to
use search, create the slave node(s) first before bootstrapping, and set the
attribute `['mysql-multi']['master']` with the correct IP array.

`mysql_slave.rb` : sets up a slave MySQL server pointing to the master node
definded within attributes.

Search will look for the node in the same environment with the tag
`mysql_master` and set master replication to that node. If you do not want to
use search, create the master node first before bootstrapping, and set the
attribute `['mysql-multi']['master']` with the correct IP.

Attributes
-----------

`['mysql-multi']['master']` : sets the IP address that defines the master node

`['mysql-multi']['slaves']` : is any array that defines the IP address(es) of
the slave node(s).

`['mysql-multi']['slave_user']` : allows for the setting of a custom name for
the slave MySQL user, by default it is set to 'replicant'.

`['mysql-multi']['server_repl_password']` : is set to match
`['mysql']['server_repl_password']` just to keep attribute names uniform
throughout this cookbook.

`['mysql-multi']['bind_ip']` is an override for the logic that determines the
best `bind_address` for mysql. Allowing you to set it to whatever is needed for
your specific configuration.

License & Authors
-----------------
- Author:: Christopher Coffey (<christopher.coffey@rackspace.com>)
- Author:: Brint O'Hearn (<brint.ohearn@rackspace.com>)
- Author:: BK Box (<bk@theboxes.org>)

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
