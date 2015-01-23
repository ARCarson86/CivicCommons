class ConfigNotFoundError < ArgumentError; end

# Adds a saftey net to configuration files.
#
# Config files are defined in the yml format.
#
# environment:
#   baselevel_1: somevalue
#   baselevel_2:
#     sublevel_a: "some other value"
#     sublevel_b: "some other value"
#
# The environment level defines the environment the configuration is for.
# The base level is the first level of configuration after the environment declaration.
# The sublevel is any configuration below the base level.
#
# Features include:
# * raise ConfigNotFound Error when:
# ** an undefined baselevel is called.
# ** an undefined sublevel is called.
# * validate that a config has been set.
# * default a value for an unset config.
module Configurator
  def self.included(base) #:nodoc:
    base.extend Configurator::ClassMethods
    super
  end

  module ClassMethods

    # Load in the yml formated configuration file.
    #
    # load_config will define a method for each baselevel.
    # All sublevels under the base levels are stored as a Hash
    #
    # If a config is inapproriately accessed it will raise a ConfigNotFoundError.
    def load_config(param)
      config_file = param[:file]
      environment = param[:environment]

      cc_config = YAML.load_file(config_file)

      cc_config[environment].each do |duple|
        method = duple[0]
        value = duple[1]

        (class << self; self; end).class_eval do
          define_method method do |*args|
            if value.is_a?(Hash)
              value.default_proc = Proc.new do |value, key_called|
                raise ConfigNotFoundError, "Configuration not found. Make sure config/civic_commons.yml has settings for #{Rails.env} => #{method} => #{key_called}."
              end
              value
            else
              value
            end
          end
        end
      end
    end

    # Validate that a Required Config is set, else raise an ConfigNotFoundError
    #
    # require_config :config => {:this_config => has_a_sublevel_config}, :description => "description of config"
    # require_config :config => :something, :description => "description of config"
    def require_config(parameters)
      if parameters.respond_to?(:keys)
        description = parameters[:description] || "civic commons configuration"

        config = parameters[:config]
        if config.respond_to?(:keys)
          config_key = config.keys.first
          config_value = config[config_key].to_s
        else
          begin # call the method and if it raises an exception we know it was never set!
            self.send(config)
          rescue # Use the custom error message rather then the default one provide by method missing
            raise ConfigNotFoundError, "Please set up the #{description}. See the civic_commons.yml.sample for an example."
          end
        end

        raise ConfigNotFoundError, "Please set up the #{description}. See the civic_commons.yml.sample for an example." unless self.send(config_key).key?(config_value)
      end
    end

    # Sets a default value for a config if one is not provided.
    #
    # default_config :of => {:mailer => :error_email}, :to => {:email => :support_email}
    # default_config :of => :use_ssl, :to => true
    def default_config(parameters)
      to = parameters[:to]
      if to.respond_to?(:keys)
        to_key = to.keys.first
        to_value = to[to_key].to_s
        to_setting = self.send(to_key)[to_value]
      else
        to_setting = to_value
      end

      of = parameters[:of]
      if of.respond_to?(:keys)
        of_key = of.keys.first
        of_value = of[of_key].to_s
      else
        (class << self; self; end).class_eval do |*args|
          define_method of.to_s do
            to_setting
          end
        end
        return
      end

      unless self.send(of_key).key?(of_value)
        self.send(of_key)[of_value] = to_setting
        Rails.logger.info "#{to} has been defaulted to #{to_setting}"
      end
    end

    # Throw a ConfigNotFoundError if a method call is not found.
    # We assume they are trying for a valid config or mis-typed a config.
    def method_missing(methId, *params)
      raise ConfigNotFoundError, "Configuration option #{methId} missing from config/civic_commons.yml"
    end

  end

end

