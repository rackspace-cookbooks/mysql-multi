class Chef
  class Provider
    # Used to setup permissions for MySQL replication user on master server
    class MysqlmSlaveGrants < Chef::Provider::LWRPBase
      include MysqlmCookbook::Helpers

      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :create do
        require 'rubygems'
        require 'mysql2'
        begin
          new_resource.slaves.each do |slave|
            grant_repl = "GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO '#{new_resource.user}"
            grant_repl += "'@'#{slave}' IDENTIFIED BY '#{new_resource.replpasswd}';"
            local_client.query(grant_repl)
          end
          local_client.query('FLUSH PRIVILEGES;')
        ensure
          close_local_client
        end
      end
    end
  end
end
