threads 5, 5
port ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RACK_ENV") { "development" }
quiet false
prune_bundler
if ENV['APP_ROOT']
  directory ENV['APP_ROOT']
end
