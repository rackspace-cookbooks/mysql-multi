# encoding: UTF-8

require_relative 'spec_helper'

describe 'mysql-multi::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  it 'starts the default mysql service' do
    expect(chef_run).to create_mysql_service('chef')
  end
end
