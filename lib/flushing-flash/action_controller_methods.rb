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
        flash[target] << to_flushing_flash_message(message_type, flash_content)
      end
    
      def pull_flash(target=:default)
        @pulled_flashes ||= {}
        return @pulled_flashes[target] if @pulled_flashes[target]
        
        pulled_flashes = flash[target] || []
        flash.delete(target)
        
        if pulled_flashes.is_a?(Array)
          @pulled_flashes[target] = pulled_flashes
        else
          @pulled_flashes[target] = [to_flushing_flash_message(target, pulled_flashes)]
        end

        @pulled_flashes[target]
      end
      
      def to_flushing_flash_message(message_type, flash_content)
        { message_type: message_type, content: flash_content }
      end
      
      def to_flushing_flash_message(message_or_message_type_or_flash_content, flash_content=nil, message_type_if_flash_content_is_nil=nil)
        if message_or_message_type_or_flash_content.is_a?(Hash)
          # message
          return message_or_message_type_or_flash_content
        elsif flash_content.nil?
          # flash_content
          return { message_type: message_type_if_flash_content_is_nil, content: message_or_message_type_or_flash_content }
        else
          # message_type with flash_content
          return { message_type: message_or_message_type_or_flash_content, content: flash_content }
        end
      end
    end
  end
end

ActionController::Base.send :include, FlushingFlash::ActionControllerMethods
