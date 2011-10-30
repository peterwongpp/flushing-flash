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
        using_template = options[:using]
        
        if msgs.any?
          if using_template
            render using_template, locals: { messages: msgs }
          else
            msgs.collect do |msg|
              content_tag :div, class: "alert-message #{msg[:message_type]} fade in" do
                concat link_to("x", "#", class: "close")
                concat content_tag(:p, msg[:content].html_safe)
              end
            end.join.html_safe
          end
        end
      end
    end
  end
end

ActionView::Base.send :include, FlushingFlash::ActionViewMethods
