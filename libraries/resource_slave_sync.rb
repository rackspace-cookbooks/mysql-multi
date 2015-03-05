class Chef
  class Resource
    # Sets up Mysql Slave server and connects them to master servers
    class MysqlmSlaveSync < Chef::Resource::LWRPBase
      resource_name :mysqlm_slave_sync

      actions :create
      default_action :create

      attribute :cookbook, kind_of: String, default: 'mysql-multi'
      attribute :source, kind_of: String, default: 'change.master.erb'
      attribute :path, kind_of: String, default: '/root/change.master.sql'
      attribute :user, kind_of: String, default: 'replicant'
      attribute :owner, kind_of: String, default: 'root'
      attribute :group, kind_of: String, default: 'root'
      attribute :mode, kind_of: String, default: '0600'
      attribute :replpasswd, kind_of: String, required: true
      attribute :master_ip, kind_of: String, required: true
      attribute :host, kind_of: String, default: '127.0.0.1'
      attribute :rootpasswd, kind_of: String, required: true
    end
  end
end
