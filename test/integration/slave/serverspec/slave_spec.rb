# encoding: UTF-8

require_relative 'spec_helper'

mysql_query = "mysql -uroot -pSillyRootPasswd -h127.0.01 -B --protocol=tcp -h\
               localhost -e 'show slave status\\G'"

describe command(mysql_query) do
  its(:stdout) { should match(/Master_Host: 192\.168\.0\.23/) }
  its(:stdout) { should match(/Master_User: replicant/) }
  its(:stdout) { should match(/Master_Port: 3306/) }
end

describe file('/etc/mysql-chef/conf.d/replication.cnf') do
  it { should contain('sync_binlog = 1').after(/^\[mysqld\]/) }
  it { should contain('read_only = 1').after(/^\[mysqld\]/) }
  it { should contain('server-id').from(/^\[mysqld\]/).to(/^\[/) }
end

describe file('/root/.my.cnf') do
  it { should contain('SillyRootPasswd') }
end
