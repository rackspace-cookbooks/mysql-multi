# encoding: UTF-8
name 'mysql-multi'
maintainer 'Rackspace'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license 'Apache 2.0'
description 'MySQL replication wrapper cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://github.com/rackspace-cookbooks/mysql-multi'
issues_url 'https://github.com/rackspace-cookbooks/mysql-multi/issues'
version '2.1.7' # bump this AFTER release, not in a PR or before

supports 'ubuntu'
supports 'centos'
supports 'redhat'

depends 'apt'
depends 'chef-sugar'
depends 'mysql'
depends 'openssl'
depends 'mysql2_chef_gem', '~> 1.0'
