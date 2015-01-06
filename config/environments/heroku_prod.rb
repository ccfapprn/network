# This is the heroku deploy environment
# It inherits from production.rb and contains any overrides necessary for a successful deploy to heroku
# git push HEROKU-REMOTE BRANCH_NAME:master --ENV=heroku
require File.expand_path('../production', __FILE__)

Rails.application.configure do
  config.force_ssl = false #on heroku test server we don't have SSL
  config.bundle_without = "oracle"
end