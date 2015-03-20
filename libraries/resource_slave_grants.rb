class Chef
  class Resource
    # Used to setup permissions for MySQL replication user on master server
    class MysqlmSlaveGrants < Chef::Resource::LWRPBase
      resource_name :mysqlm_slave_grants
      actions :create
      default_action :create

      attribute :user, kind_of: String, default: 'replicant'
      attribute :replpasswd, kind_of: String, required: true
      attribute :host, kind_of: String, default: '127.0.0.1'
      attribute :root_user, kind_of: String, default: 'root'
      attribute :rootpasswd, kind_of: String, required: true
      attribute :slaves, kind_of: Array, required: true
      attribute :port, kind_of: String, default: '3306'
    end
  end
end
