# encoding: UTF-8

require_relative 'spec_helper'

mysql_query = "mysql -uroot -pilikerandompasswords -B -e 'show slave status\\G'"

describe command(mysql_query) do
  it { should return_stdout(/Master_Host: 192\.168\.0\.23/) }
  it { should return_stdout(/Master_User: replicant/) }
  it { should return_stdout(/Master_Port: 3306/) }
end

describe file('/etc/mysql/conf.d/slave.cnf') do
  it { should contain('sync_binlog = 1').after(/^[mysqld]/) }
  it { should contain('read_only = 1').after(/^[mysqld]/) }
end

describe file('/etc/mysql/conf.d/my.cnf') do
  it { should contain('server_id').from(/^[mysqld]/).to(/^[mysqldump]/) }
end
