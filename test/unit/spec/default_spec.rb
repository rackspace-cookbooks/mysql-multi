# encoding: UTF-8

require_relative 'spec_helper'

describe 'mysql-multi::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  it 'starts the default mysql service' do
    expect(chef_run).to create_mysql_service('chef')
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
