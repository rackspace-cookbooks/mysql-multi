# encoding: UTF-8

require_relative 'spec_helper'

describe 'mysql-multi::mysql_slave' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['mysql-multi']['master'] = '1.2.3.4'
      node.set['mysql-multi']['server_repl_password'] = 'souliekr@nd0m?'
    end.converge(described_recipe)
  end

  let(:change_master_content) do
    "CHANGE MASTER TO MASTER_HOST='1.2.3.4',MASTER_USER='replicant', MASTER_PASSWORD='souliekr@nd0m?';
START SLAVE;"
  end

  context 'when creating a slave node' do
    it 'create default mysql config' do
      expect(chef_run).to create_mysql_config('slave replication')
    end
  end
end
