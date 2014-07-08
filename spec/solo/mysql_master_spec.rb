require 'spec_helper'

describe 'mysql-multi::mysql_master' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['mysql-multi']['slaves'] = ['1.2.3.4']
    end.converge(described_recipe)
  end

  let(:grant_content) do
    "GRANT REPLICATION SLAVE ON *.* TO 'replicant'@'1.2.3.4' IDENTIFIED BY '';
FLUSH PRIVILEGES;"
  end

  context 'when creating mysql master' do
    it 'creates a master config' do
      resource = chef_run.template('/etc/mysql/conf.d/master.cnf')
      expect(resource).to notify('mysql_service[default]').to(:restart).delayed

      expect(chef_run).to create_template('/etc/mysql/conf.d/master.cnf')
    end

    it 'create grants template' do
      resource = chef_run.template('/root/grant-slaves.sql')
      expect(resource).to notify('execute[grant-slave]').to(:run).immediately

      expect(chef_run).to create_template('/root/grant-slaves.sql').with(
        owner: 'root',
        group: 'root',
        mode: '0600',
        path: '/root/grant-slaves.sql'
      )
      expect(chef_run).to render_file('/root/grant-slaves.sql').with_content(grant_content)
    end

    it 'executes grant-slave' do
      resource = chef_run.execute('grant-slave')
      expect(resource).to do_nothing

      expect(chef_run).to_not run_execute('grant-slave')
    end
  end
end
