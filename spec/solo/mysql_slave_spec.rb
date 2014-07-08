require 'spec_helper'

describe 'mysql-multi::mysql_slave' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['mysql-multi']['master'] = '1.2.3.4'
      node.set['mysql-multi']['server_repl_password'] = 'souliekr@nd0m?'
    end.converge(described_recipe)
  end

  let(:change_master_content) do
    "CHANGE MASTER TO MASTER_HOST='1.2.3.4',MASTER_USER='replicant', MASTER_PASSWORD='souliekr@nd0m?';
START SLAVE;"
  end

  context 'when creating a slave node' do
    it 'creates a slave config' do
      resource = chef_run.template('/etc/mysql/conf.d/slave.cnf')
      expect(resource).to notify('mysql_service[default]').to(:restart).delayed

      expect(chef_run).to create_template('/etc/mysql/conf.d/slave.cnf')
    end

    it 'creates change master template' do
      resource = chef_run.template('/root/change.master.sql')
      expect(resource).to notify('execute[change master]').to(:run).immediately

      expect(chef_run).to create_template('/root/change.master.sql').with(
        owner: 'root',
        group: 'root',
        mode: '0600',
        path: '/root/change.master.sql'
      )
      expect(chef_run).to render_file('/root/change.master.sql').with_content(change_master_content)
    end

    it 'executes change master' do
      resource = chef_run.execute('change master')
      expect(resource).to do_nothing

      expect(chef_run).to_not run_execute('change master')
    end
  end
end
