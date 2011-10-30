module FlushingFlash
  module ActionControllerMethods
    def self.included(base)
      base.extend ClassMethods
      base.send :include, InstanceMethods
      base.send(:helper_method, :pull_flash)
    end
    
    module ClassMethods
    end
    
    module InstanceMethods
      def push_flash(message_type, *args)
        opts = args.extract_options!

        i18n_options = opts.delete(:i18n_options)
        target = opts.delete(:target) || :default

        flash_content = case args[0].class.name
        when String.name
          args[0]
        when Symbol.name
          I18n.t("flashes.#{args[0]}.#{message_type}", i18n_options)
        else
          I18n.t("flashes.#{self.class.name.gsub(/Controller$/, "").underscore.gsub(/\//, ".")}.#{action_name.underscore}.#{message_type}", i18n_options)
        end

        flash[target] ||= []
        flash[target] << { message_type: message_type, content: flash_content }
      end
    
      def pull_flash(target=:default)
        @pulled_flashes ||= {}
        return @pulled_flashes[target] if @pulled_flashes[target]

        @pulled_flashes[target] = flash[target] || []
        flash.delete(target)

        @pulled_flashes[target]
      end
    end
  end
end

ActionController::Base.send :include, FlushingFlash::ActionControllerMethods
