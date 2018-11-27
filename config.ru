$LOAD_PATH.unshift(File.dirname("lib/#{__FILE__}"))

require 'fileutils'
require 'logger'
require 'puppet_webhook'
require 'sidekiq/web'

if ENV['RACK_ENV'] == 'production'
  LOGGER = Logger.new('/home/dhollinger/puppet_webhook.log').freeze
  LOCKFILE = '/home/dhollinger/puppet_webhook/puppet_webhook.lock'.freeze

  FileUtils.makedirs('/home/dhollinger/puppet_webhook')
  FileUtils.touch(LOCKFILE) unless File.exist?(LOCKFILE)

  PuppetWebhook.set :logger, LOGGER
end

PuppetWebhook.set :root, File.dirname(__FILE__)
PuppetWebhook.set :command_prefix, 'umask 0022;'

app = Rack::URLMap.new('/' => PuppetWebhook.new, '/sidekiq' => Sidekiq::Web.new)

run app
