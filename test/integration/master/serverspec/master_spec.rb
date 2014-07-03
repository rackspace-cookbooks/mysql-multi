# Encoding utf-8

require_relative 'spec_helper'

mysql_query = %Q[mysql -uroot -pilikerandompasswords -B --disable-column-names\
                 -e 'select host from user where user="replicant"' mysql]

describe command(mysql_query) do
  it { should return_stdout /192\.168\.0\.23/ }
end
