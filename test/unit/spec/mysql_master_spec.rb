# encoding: UTF-8

require_relative 'spec_helper'

describe 'mysql-multi::mysql_master' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['mysql-multi']['slaves'] = ['1.2.3.4']
      node.set['mysql-multi']['server_repl_password'] = 'foobar'
    end.converge(described_recipe)
  end

  let(:grant_content) do
    "GRANT REPLICATION SLAVE ON *.* TO 'replicant'@'1.2.3.4' IDENTIFIED BY 'foobar';
FLUSH PRIVILEGES;"
  end

  context 'when creating mysql master' do
    it 'create default mysql config' do
      expect(chef_run).to create_mysql_config('master replication')
    end
  end
end
