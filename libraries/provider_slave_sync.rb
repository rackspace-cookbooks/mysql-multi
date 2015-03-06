class Chef
  class Provider
    # Sets up Mysql Slave server and connects them to master servers
    class MysqlmSlaveSync < Chef::Provider::LWRPBase
      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      def action_create
        connect_slaves
      end

      def connect_slaves
        execute 'change master' do
          command <<-EOH
          /usr/bin/mysql -h #{new_resource.host} -u root -p'#{new_resource.rootpasswd}' < /root/change.master.sql
          rm -f /root/change.master.sql
          EOH
          sensitive true
          action :nothing
        end

        template 'change.master.sql' do
          path new_resource.path
          cookbook new_resource.cookbook
          source new_resource.source
          owner new_resource.owner
          group new_resource.group
          mode new_resource.mode
          sensitive true
          variables(
            host: new_resource.master_ip,
            user: new_resource.user,
            password: new_resource.replpasswd
          )
          notifies :run, 'execute[change master]', :immediately
        end
      end
    end
  end
end
