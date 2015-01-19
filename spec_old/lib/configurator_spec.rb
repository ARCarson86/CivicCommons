require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Configurator do
  context "load_config" do
    class TestConfig
      include Configurator
      load_config(:file => File.join(Rails.root, "config", "civic_commons.yml.sample"), :environment => Rails.env)
    end

    it "sets up an access method based on the base level of a config." do
      TestConfig.rails_secret_token.should == "randonStuffThatsAtLeast30CharachtersYo128DirtyWithTh"
    end

    it "makes the sub levels accssable as a hash." do
      TestConfig.email['default_email'].should == "my_default_email@example.com"
      TestConfig.email['support_email'].should == "my_support_email@example.com"
    end

    it "raises an exception when an undefined base level is accessed." do
      lambda { TestConfig.baselevel }.should raise_error ConfigNotFoundError
    end

    it "raises an exception when an undefined sublevel is accessed." do
      lambda { TestConfig.mailer['sublevel'] }.should raise_error ConfigNotFoundError
    end
  end

  context "require_config" do
    it "raises an exception when a base level config is not set." do
      invalid_config_parameter = lambda {
        class InvalidConfigParameter
          include Configurator
          load_config(:file => File.join(Rails.root, "config", "civic_commons.yml.sample"), :environment => Rails.env)

          require_config :config => :undefined_baselevel, :description => "default email"
        end
      }

      begin
        invalid_config_parameter.call
      rescue ConfigNotFoundError => e
        e.message.should == "Please set up the default email. See the civic_commons.yml.sample for an example."
      end
      invalid_config_parameter.should raise_error ConfigNotFoundError
    end

    it "raises an exception when a sublevel config is not set." do
      lambda {
        class InvalidConfigParameter
          include Configurator
          load_config(:file => File.join(Rails.root, "config", "civic_commons.yml.sample"), :environment => Rails.env)

          require_config :config => {:email => :undefined_sublevel}, :description => "default email"
        end
      }.should raise_error ConfigNotFoundError
    end
  end

  context "default_config" do
    it "sets a base config to a default value of another configs value" do
      class SetDefaultConfig
        include Configurator
        load_config(:file => File.join(Rails.root, "config", "civic_commons.yml.sample"), :environment => Rails.env)

        default_config :of => :default_test, :to => {:email => :default_email}
      end

      SetDefaultConfig.default_test.should == "my_default_email@example.com"
    end

    it "sets a sublevel config to a default value of another configs value" do
      class SetDefaultConfig
        include Configurator
        load_config(:file => File.join(Rails.root, "config", "civic_commons.yml.sample"), :environment => Rails.env)

        default_config :of => {:email => :sublevel}, :to => {:email => :default_email}
      end

      SetDefaultConfig.email['sublevel'].should == "my_default_email@example.com"
    end
  end

  context "method missing" do
    it "raises a ConfigNotFound Error when a undefined base level and sublevel config is utilized" do
      lambda {
        class MethodMissingConfigTest
          include Configurator
          load_config(:file => File.join(Rails.root, "config", "civic_commons.yml.sample"), :environment => Rails.env)

          default_config :of => {:undefined_base_level => :undefined_sublevel}, :to => {:email => :default_email}
        end
      }.should raise_error ConfigNotFoundError
    end
  end

end

