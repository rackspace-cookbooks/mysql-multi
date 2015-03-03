class Chef
  class Resource
    class MysqlmSlaveGrants < Chef::Resource::LWRPBase
      resource_name :mysqlm_slave_grants

      actions :create
      default_action :create

      attribute :user, kind_of: String, default: 'replicant'
      attribute :owner, kind_of: String, default: 'root'
      attribute :group, kind_of: String, default: 'root'
      attribute :mode, kind_of: Fixnum, default: 0600
      attribute :passwd, kind_of: String, default: 'BadDefaultReplPasswd'
    end
  end

  class Provider
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
          /usr/bin/mysql -h 127.0.0.1 -u root -p'#{node['mysql']['server_root_password']}' < /root/grant-slaves.sql
          rm -f /root/grant-slaves.sql
          EOH
          action :nothing
        end

        node['mysql']['slave_ip'].each do |slave|
          template "/root/grant-slaves.sql #{slave}" do
            path '/root/grant-slaves.sql'
            source 'grant.slave.erb'
            owner new_resource.owner
            group new_resource.group
            mode new_resource.mode
            variables(
              user: new_resource.user,
              password: new_resource.passwd,
              host: slave
            )
            notifies :run, 'execute[grant-slave]', :immediately
          end
        end
      end
    end
  end
end
