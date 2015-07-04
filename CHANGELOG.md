mysql-multi Cookbook CHANGELOG
==============================
This file is used to list changes made in each version of the mysql-multi
cookbook.

v2.1.6 (2015-07-04)
- Fixed bug with the resource name mysqlm_slave_sync

v2.1.5 (2015-05-28)
- Added a check for best_ip_for returning nil. That does not help anything.

v2.1.4 (2015-05-04)
- Added guard to mysql_master recipe to not do slave grants if no slaves are set.

v2.1.3 (2015-04-10)
- Added additional search functionality (PR #59)

v2.1.2 (2015-04-06)
- Added guard to slave_sync provider to keep it from trying to setup replication every run.

v2.1.1 (2015-3-24)
- Minor changes to the way recipe handles serverid's and added chef_gem version attribute

v2.1.0 (2015-3-20)
- Major update to recipes, moved MySQL service install specific code to default.rb
  Leaving Master/Slave specific code in the other recipes

v2.0.0 (2015-3-02)
- Major update to provide compatibility with MySQL community cookbook version 6.x

v1.4.3 (update me for the release)
- Bump for dev

v1.4.2 (2014-12-05)
- Use `fail` instead of `Chef::Application.fatal!` in `_find_master` so that it can be caught

v1.3.3 (2014-08-27)
- Set the slave root password to match master since the sync will change it (Issue #21)
- Fix serverspec tests. (PR #22)

v1.3.2 (2014-08-01)
- Don't fail hard on solo runs without proper attribute config
- Better logic for error checking on empty slaves
- Throw a warning with no slaves instead of raising a fatal
- Set up `mysql_service` with upstream attribute options to allow overriding

v1.3.1 (2014-07-28)
- Clean up search logic
- Handle array result from search for master

v1.3.0 (2014-07-25)
- Add Travis-CI testing
- Add supported OS in metadata
- Updated search logic

v1.2.2 (2014-07-15)
-------------------
- Fix attribute typo (#10)

v1.2.1 (2014-07-11)
-------------------
- Create a proper array so we don't run into nil issues (#8)
- Fix bug preventing mulitiple slaves (#9)

v1.2.0 (2014-07-08)
-------------------
- Add search functionality
- Add 100% coverage in ChefSpec
