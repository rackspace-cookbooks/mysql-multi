class Chef
  class Resource
    # Sets up Mysql Slave server and connects them to master servers
    class MysqlmSlaveSync < Chef::Resource::LWRPBase
      resource_name :mysqlm_slave_sync
      actions :create
      default_action :create

      attribute :repluser, kind_of: String, default: 'replicant'
      attribute :replpasswd, kind_of: String, required: true
      attribute :master_ip, kind_of: String, required: true
      attribute :root_user, kind_of: String, default: 'root'
      attribute :host, kind_of: String, default: '127.0.0.1'
      attribute :rootpasswd, kind_of: String, required: true
      attribute :port, kind_of: String, default: '3306'
    end
  end
end
