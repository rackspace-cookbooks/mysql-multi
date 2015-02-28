# encoding: UTF-8

require_relative 'spec_helper'

mysql_query = %(mysql -uroot -pilikerandompasswords -B --disable-column-names\
                 -e 'select host from user where user="replicant"' mysql\
                 -h localhost --protocol=tcp)

describe command(mysql_query) do
  its(:stdout) { should match /192\.168\.0\.23/ }
end

log_bin = '/var/log/mysql-chef/mysql-bin.log'

describe file('/etc/mysql-chef/conf.d/replication.cnf') do
  it { should contain('sync_binlog = 1').after(/^\[mysqld\]/) }
  it { should contain('binlog-format = mixed').after(/^\[mysqld\]/) }
  it { should contain("log_bin = #{log_bin}").from(/^\[mysqld\]/).to(/^\[/) }
  it { should contain('server-id').from(/^\[mysqld\]/).to(/^\[/) }
end
