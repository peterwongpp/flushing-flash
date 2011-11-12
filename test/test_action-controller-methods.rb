require 'action_controller'
require 'helper'

class TestActionControllerMethods < Test::Unit::TestCase
  acb = ActionController::Base.new
  
  def message_format(message_type, content)
    { message_type: message_type, content: content }
  end
  def flash_format(*args)
    r = {}
    args.each do |target, messages|
      r[target] ||= []
      r[target] << messages
      r[target].flatten!
    end
    r
  end
  
  should "return a gem-standardized hash for a message" do
    message = acb.to_flushing_flash_message(:success, "Succeeded!")
    
    assert_equal message_format(:success, "Succeeded!"), message
  end
  
  should "push a message into the flash object" do
    acb.stubs(:action_name).returns("create")
    acb.stubs(:request).returns(Object.new)
    acb.request.stubs(:flash).returns({})
    
    acb.push_flash(:success)
    
    assert_equal flash_format(
      [:default, [message_format(:success, I18n.t("flashes.action_controller.base.create.success"))]]
    ), acb.flash
  end
  
  should "render the message content correctly according to the first and second parameter" do
    acb.stubs(:action_name).returns("create")
    acb.stubs(:request).returns(Object.new)
    acb.request.stubs(:flash).returns({})
    
    acb.push_flash(:success, :i_am_first)
    acb.push_flash(:failure, "I am the Second")
    acb.push_flash(:warning, nil)
    
    assert_equal flash_format(
      [:default, [
          message_format(:success, I18n.t("flashes.i_am_first.success")),
          message_format(:failure, "I am the Second"),
          message_format(:warning, I18n.t("flashes.action_controller.base.create.warning"))
        ]
      ]
    ), acb.flash
  end
end
