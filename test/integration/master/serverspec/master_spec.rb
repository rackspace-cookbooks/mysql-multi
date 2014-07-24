# encoding: UTF-8

require_relative 'spec_helper'

mysql_query = %Q(mysql -uroot -pilikerandompasswords -B --disable-column-names\
                 -e 'select host from user where user="replicant"' mysql)

describe command(mysql_query) do
  it { should return_stdout(/192\.168\.0\.23/) }
end

describe file('/etc/mysql/conf.d/master.cnf') do
  it { should contain('sync_binlog = 1').after(/^[mysqld]/) }
  it { should contain('binlog-format = mixed').after(/^[mysqld]/) }
  it { should contain('log-bin = mysql-bin').after(/^[mysqld]/) }
end

describe file('/etc/mysql/conf.d/my.cnf') do
  it { should contain('server_id').from(/^[mysqld]/).to(/^[mysqldump]/) }
end
