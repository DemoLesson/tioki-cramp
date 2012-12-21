require "rubygems"
require "bundler"

module TiokiCramp
  class Application

    def self.root(path = nil)
      @_root ||= File.expand_path(File.dirname(__FILE__))
      path ? File.join(@_root, path.to_s) : @_root
    end

    def self.env
      @_env ||= ENV['RACK_ENV'] || 'development'
    end

    def self.routes
      @_routes ||= eval(File.read('./config/routes.rb'))
    end

    def self.database_config
      @_database_config ||= YAML.load(File.read('./config/database.yml')).with_indifferent_access
    end

    # Initialize the application
    def self.initialize!
      ActiveRecord::Base.configurations = TiokiCramp::Application.database_config
      ActiveRecord::Base.establish_connection(TiokiCramp::Application.env)

      # Preload application classes
      Dir.glob("./app/**{,/*/**}/*.rb").each {|f| require f}
    end

  end
end

# Load helpers
Dir.glob("./app/helpers/*.rb").each {|f| require f}

Bundler.require(:default, TiokiCramp::Application.env)