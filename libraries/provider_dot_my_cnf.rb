class Chef
  class Provider
    class MysqlmDotMyCnf < Chef::Provider::LWRPBase

      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      def action_create
        drop_dot_my_cnf
      end

      def drop_dot_my_cnf
        template '.my.cnf' do
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
          action :create
        end
      end
    end
  end
end
