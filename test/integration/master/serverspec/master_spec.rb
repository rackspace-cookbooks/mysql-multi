# encoding: UTF-8

require_relative 'spec_helper'

mysql_query = %(mysql -uroot -pSillyRootPasswd -B --disable-column-names\
                 -e 'select host from user where user="replicant"' mysql\
                 -h 127.0.0.1 --protocol=tcp)

describe command(mysql_query) do
  its(:stdout) { should match(/192\.168\.0\.2/) }
end

describe file('/etc/mysql-chef/conf.d/replication.cnf') do
  it { should contain('sync_binlog = 1').after(/^\[mysqld\]/) }
  it { should contain('binlog-format = mixed').after(/^\[mysqld\]/) }
end
