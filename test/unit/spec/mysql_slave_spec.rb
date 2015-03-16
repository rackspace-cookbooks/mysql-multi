# encoding: UTF-8

require_relative 'spec_helper'

describe 'mysql-multi::mysql_slave' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['mysql-multi']['master'] = '1.2.3.4'
      node.set['mysql-multi']['server_repl_password'] = 'souliekr@nd0m?'
    end.converge(described_recipe)
  end

  it 'installs mysql2_chef_gem' do
    expect(chef_run).to install_mysql2_chef_gem('default')
  end

  it 'starts the default mysql service' do
    expect(chef_run).to create_mysql_service('chef')
  end

  it 'create default mysql config' do
    expect(chef_run).to create_mysql_config('slave replication')
  end
end
