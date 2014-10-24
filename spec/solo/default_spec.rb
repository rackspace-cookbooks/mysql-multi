# encoding: UTF-8

require 'spec_helper'

describe 'mysql-multi::default' do
  let(:chef_run) {  ChefSpec::Runner.new.converge(described_recipe) }

  it 'starts the default mysql service' do
    expect(chef_run).to create_mysql_service('default')
  end

  it 'creates /etc/mysql/conf.d' do
    expect(chef_run).to create_directory('/etc/mysql/conf.d').with(
      recursive: true
    )
  end

  it 'creates base config' do
    resource = chef_run.template('/etc/mysql/conf.d/my.cnf')

    expect(resource).to notify('mysql_service[default]').to(:restart).delayed
    expect(chef_run).to create_template('/etc/mysql/conf.d/my.cnf')
    expect(chef_run).to render_file('/etc/mysql/conf.d/my.cnf').with_content('server-id')
  end

  it 'creates .my.cnf' do
    expect(chef_run).to create_template('/root/.my.cnf').with(
      owner: 'root',
      group: 'root',
      mode: '0600'
    )

    expect(chef_run).to render_file('/root/.my.cnf').with_content('user=root')
  end
end
