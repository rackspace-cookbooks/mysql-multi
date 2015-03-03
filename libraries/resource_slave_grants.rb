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
      attribute :replpasswd, kind_of: String, default: 'BadDefaultReplPasswd'
      attribute :host, kind_of: String, default: '127.0.0.1'
      attribute :rootpasswd, kind_of: String, default: 'VeryBadRootPasswd'
    end
  end
end
