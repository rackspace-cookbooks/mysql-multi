class Chef
  class Resource
    # Used to setup permissions for MySQL replication user on master server
    class MysqlmSlaveGrants < Chef::Resource::LWRPBase
      resource_name :mysqlm_slave_grants

      actions :create
      default_action :create

      attribute :cookbook, kind_of: String, default: 'mysql-multi'
      attribute :source, kind_of: String, default: 'grant.slave.erb'
      attribute :path, kind_of: String, default: '/root/grant-slaves.sql'
      attribute :user, kind_of: String, default: 'replicant'
      attribute :owner, kind_of: String, default: 'root'
      attribute :group, kind_of: String, default: 'root'
      attribute :mode, kind_of: Fixnum, default: 0600
      attribute :replpasswd, kind_of: String, required: true
      attribute :host, kind_of: String, default: '127.0.0.1'
      attribute :rootpasswd, kind_of: String, required: true
      attribute :slave_ip, kind_of: Array, required: true
    end
  end
end
