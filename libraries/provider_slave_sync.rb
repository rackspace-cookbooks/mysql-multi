class Chef
  class Provider
    # Sets up Mysql Slave server and connects them to master servers
    class MysqlmSlaveSync < Chef::Provider::LWRPBase
      include MysqlmCookbook::Helpers

      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :create do
        require 'rubygems'
        require 'mysql2'
        begin
          set_mstr = "CHANGE MASTER TO MASTER_HOST='#{new_resource.master_ip}', "
          set_mstr += "MASTER_USER='#{new_resource.repluser}', MASTER_PASSWORD='#{new_resource.replpasswd}';"
          local_client.query(set_mstr)
          local_client.query('START SLAVE;')
        ensure
          close_local_client
        end
      end
    end
  end
end
