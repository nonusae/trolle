require_relative 'boot'

require 'rails/all'
Bundler.require(*Rails.groups)

module Projects
  class Application < Rails::Application
    config.load_defaults 5.1
    config.generators do |g| 
        g.test_framework :rspec,
            view_specs: false, 
            helper_specs: false, 
            routing_specs: false,
            request_specs: false
    end
  end
end
