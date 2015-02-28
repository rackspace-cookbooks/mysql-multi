# encoding: UTF-8

require 'chefspec'
require 'chefspec/berkshelf'

def stub_resources
  Chef::Node.any_instance.stub(:save)
end

at_exit { ChefSpec::Coverage.report! }
