mysql-multi Cookbook CHANGELOG
==============================
This file is used to list changes made in each version of the mysql-multi
cookbook.

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
