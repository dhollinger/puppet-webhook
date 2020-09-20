# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq/web'
require './config/environment'

redis_params = {
  host: APP_CONFIG.redis_host ||= 'localhost',
  port: APP_CONFIG.redis_port ||= 6379,
  password: APP_CONFIG.redis_password ||= nil
}

url = "redis://#{redis_params[:host]}:#{redis_params[:port]}/0"

Sidekiq.configure_server do |config|
  config.redis = {
    url: url,
    password: redis_params[:password]
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: url,
    password: redis_params[:password]
  }
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  # Protect against timing attacks:
  # - See https://codahale.com/a-lesson-in-timing-attacks/
  # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
  # - Use & (do not use &&) so that it doesn't short circuit.
  # - Use digests to stop length information leaking
  Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(user), ::Digest::SHA256.hexdigest(APP_CONFIG.user)) &
    Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(APP_CONFIG.pass))
end
