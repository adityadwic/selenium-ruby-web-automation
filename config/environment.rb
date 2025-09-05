require 'yaml'

module Config
  class Environment
    def self.data
      @data ||= YAML.load_file(File.join(File.dirname(__FILE__), 'environments.yml'))
    end

    def self.base_url
      data[current_env]['base_url']
    end

    def self.browser
      ENV['BROWSER'] || data[current_env]['browser']
    end

    def self.headless
      ENV['HEADLESS'] == 'true' || data[current_env]['headless']
    end

    def self.timeout
      data[current_env]['timeout']
    end

    def self.current_env
      ENV['ENV'] || 'test'
    end
  end
end
