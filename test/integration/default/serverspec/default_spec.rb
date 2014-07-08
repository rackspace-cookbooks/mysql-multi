# Encoding utf-8

require_relative 'spec_helper'

mysql_query = "mysql -uroot -pilikerandompasswords -e 'status'"

describe command(mysql_query) do
  it { should return_stdout(/^mysql/) }
  it { should return_stdout(/^Uptime:/) }
end

describe file('/etc/mysql/conf.d') do
  it { should be_directory }
end

describe file('/etc/mysql/conf.d/my.cnf') do
  it { should contain('server_id').from(/^[mysqld]/).to(/^[mysqldump]/) }
end

describe file('/root/.my.cnf') do
  it { should contain('user=root').from('[mysql]').to('[client]') }
  it { should contain('password=ilikerandompasswords').from('[mysql]').to('[client]') }
  it { should contain('user=root').after('[client]') }
  it { should contain('password=ilikerandompasswords').after('[client]') }
  it { should be_mode(600) }
end
