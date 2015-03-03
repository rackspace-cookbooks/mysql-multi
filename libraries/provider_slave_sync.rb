class Chef
  class Provider
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
          action :nothing
        end

        template '/root/change.master.sql' do
          path '/root/change.master.sql'
          source 'change.master.erb'
          owner new_resource.owner
          group new_resource.group
          mode new_resource.mode
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
