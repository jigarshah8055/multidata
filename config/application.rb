require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Multidata
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    def use_database(subdomain)
      ActiveRecord::Base.establish_connection(website_connection(subdomain))
    end

    # Revert back to the shared database
    def revert_database
      ActiveRecord::Base.establish_connection(default_connection)
    end

    private

    # Regular database.yml configuration hash
    def default_connection
      @default_config ||= ActiveRecord::Base.connection.instance_variable_get("@config").dup
    end

    # Return regular connection hash but with database name changed
    # The database name is a attribute (column in the database)
    def website_connection(subdomain)
      default_connection.dup.update(:database => subdomain)
    end
  end
end
