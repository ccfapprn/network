# This is the heroku deploy environment
# It inherits from production.rb and contains any overrides necessary for a successful deploy to heroku
# git push HEROKU-REMOTE BRANCH_NAME:master --ENV=heroku
require File.expand_path('../development', __FILE__)

Rails.application.configure do
  config.bundle_without = "oracle"
end