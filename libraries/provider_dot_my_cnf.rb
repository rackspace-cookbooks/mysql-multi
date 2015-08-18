class Chef
  class Provider
    # used to create and managed .my.cnf files
    class MysqlmDotMyCnf < Chef::Provider::LWRPBase
      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :create do
        template '.my.cnf' do # ~FC009
          cookbook new_resource.cookbook
          path "#{new_resource.path}.my.cnf"
          source new_resource.source
          owner new_resource.owner
          group new_resource.group
          mode new_resource.mode
          variables(
            cookbook_name: new_resource.cookbook,
            host: new_resource.host,
            user: new_resource.user,
            pass: new_resource.passwd
          )
          sensitive true
          action :create
        end
      end

      action :delete do
        file '.my.cnf' do
          path "#{new_resource.path}.my.cnf"
          action :delete
        end
      end
    end
  end
end
