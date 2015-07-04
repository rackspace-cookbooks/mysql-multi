if defined?(ChefSpec)
  def mysqlm_dot_my_cnf(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysqlm_dot_my_cnf, :create, resource_name)
  end

  def mysqlm_slave_grants(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysqlm_slave_grants, :create, resource_name)
  end

  def mysqlm_slave_sync(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysqlm_slave_sync, :create, resource_name)
  end
end
