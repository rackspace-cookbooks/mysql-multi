class Chef
  class Provider
    # Connects MySQL slave server to the master server
    class MysqlmSlaveSync < Chef::Provider::LWRPBase
      include MysqlmCookbook::Helpers

      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :create do
        require 'rubygems'
        require 'mysql2'
        status = local_client.query('SHOW SLAVE STATUS;')
        if status.count > 0
          then Chef::Log.warn('Replication appears to be configured, Skipping...')
        else
          begin
            Chef::Log.warn('Replication needs to be configured, doing it now.')
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
end
