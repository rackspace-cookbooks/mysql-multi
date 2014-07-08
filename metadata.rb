name 'mysql-multi'
maintainer 'Christopher Coffey'
maintainer_email 'christopher.coffey@rackspace.com'
license 'Apache 2.0'
description 'MySQL replication wrapper cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.2.0'

depends 'mysql'
depends 'apt'
depends 'chef-sugar'
