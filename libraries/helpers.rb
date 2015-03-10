module MysqlmCookbook
  # Helper methods to be used in MySQL-Multi cookbook libraries
  module Helpers
    def local_client
      @local_client ||=
        Mysql2::Client.new(
          host: new_resource.host,
          username: new_resource.root_user,
          password: new_resource.rootpasswd,
          port: new_resource.port
        )
    end

    def close_local_client
      @local_client.close if @local_client
    rescue Mysql2::Error
      @local_client = nil
    end
  end
end
