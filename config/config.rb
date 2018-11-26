require 'ostruct'
require 'yaml'

module PuppetWebhook
  # An object for generating configuration from a file for the sinatra
  # application. This is not meant as a public API.
  #
  # Examples:
  #
  #   config = PuppetWebhook::Config.new('/etc/puppet_webhook/config.yml')
  class Config
    # Public: Initialize a new PuppetWebhook::Config object.
    #
    # file - path to the app's configuration file
    def initialize(file = 'config.yml')
      @config = OpenStruct.new(YAML.load_file(file))
    end

    private

    # Private: Set default values for settings that cannot accept
    # nil for a value
    #
    def defaults
      @config.user ||= 'puppet'
      @config.pass ||= 'puppet'
    end
  end
end
