class Chef
  class Resource
    class MysqlmSlaveSync < Chef::Resource::LWRPBase
      resource_name :mysqlm_slave_sync

      actions :create
      default_action :create

      attribute :user, kind_of: String, default: 'replicant'
      attribute :owner, kind_of: String, default: 'root'
      attribute :group, kind_of: String, default: 'root'
      attribute :mode, kind_of: Fixnum, default: 0600
      attribute :passwd, kind_of: String, default: 'BadDefaultReplPasswd'
      attribute :master_ip, kind_of: String, default: nil
    end
  end

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
          /usr/bin/mysql -h 127.0.0.1 -u root -p'#{node['mysql']['server_root_password']}' < /root/change.master.sql
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
            password: new_resource.passwd
          )
          notifies :run, 'execute[change master]', :immediately
        end
      end
    end
  end
end
