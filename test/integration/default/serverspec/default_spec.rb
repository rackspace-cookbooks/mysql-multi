# encoding: UTF-8

require_relative 'spec_helper'

mysql_query = "mysql -uroot -pilikerandompasswords -h localhost -e 'status' --protocol tcp"

describe command(mysql_query) do
  its(:stdout) { should match(/^mysql( )+Ver/) }
  its(:stdout) { should match(/^Uptime:/) }
end

describe file('/etc/mysql-chef/conf.d') do
  it { should be_directory }
end

describe file('/root/.my.cnf') do
  it { should contain('user=root').from('\[mysql\]').to('\[client\]') }
  it { should contain('password=ilikerandompasswords').from('\[mysql\]').to('\[client\]') }
  it { should contain('user=root').after('\[client\]') }
  it { should contain('password=ilikerandompasswords').after('\[client\]') }
  it { should be_mode(600) }
end
