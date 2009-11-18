require 'test_helper'

class ConfigurationTest < ActiveSupport::TestCase

  context "subclass" do
    setup do
      class ::Configuration::Subclass < ::Configuraion
      end
      
      @it = ::Configuration::Subclass
    end

    should "use its class name(the last part) as its default configuration_name." do
      assert_equal 'Subclass', @it.configuration_name
    end

    should "use whatever is set as configuration_name as its configuration_name." do
      name = 'OtherName'
      @it.configuration_name name
      assert_equal name, @it.configuration_name
    end
  end
end
