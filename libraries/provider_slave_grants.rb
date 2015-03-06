class Chef
  class Provider
    # Used to setup permissions for MySQL replication user on master server
    class MysqlmSlaveGrants < Chef::Provider::LWRPBase
      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      def action_create
        grant_slave_privs
      end

      def grant_slave_privs
        execute 'grant-slave' do
          command <<-EOH
          /usr/bin/mysql -h #{new_resource.host} -u root -p'#{new_resource.rootpasswd}' < /root/grant-slaves.sql
          rm -f /root/grant-slaves.sql
          EOH
          sensitive true
          action :nothing
        end

        new_resource.slave_ip.each do |slave|
          template "grant-slaves.sql #{slave}" do
            path new_resource.path
            cookbook new_resource.cookbook
            source new_resource.source
            owner new_resource.owner
            group new_resource.group
            mode new_resource.mode
            sensitive true
            variables(
              user: new_resource.user,
              password: new_resource.replpasswd,
              host: slave
            )
            notifies :run, 'execute[grant-slave]', :immediately
          end
        end
      end
    end
  end
end
