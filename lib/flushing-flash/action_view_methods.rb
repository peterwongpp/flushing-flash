module FlushingFlash
  module ActionViewMethods
    def self.included(base)
      base.extend ClassMethods
      base.send :include, InstanceMethods
    end
    
    module ClassMethods
    end
    
    module InstanceMethods
      def has_flash?(target=:default)
        pull_flash(target).any?
      end
      
      def flush_flash(target=:default, options={})
        msgs = pull_flash(target)
        using_template = options[:using] || nil
        html_safe = options[:html_safe] || false
        
        if msgs.any?
          if using_template
            render partial: using_template, locals: { messages: msgs }
          else
            msgs.collect do |msg|
              content_tag :div, class: "flash-message #{msg[:message_type]}" do
                concat content_tag(:p, (html_safe? msg[:content].html_safe : msg[:content]))
              end
            end.join.html_safe
          end
        end
      end
    end
  end
end

ActionView::Base.send :include, FlushingFlash::ActionViewMethods
