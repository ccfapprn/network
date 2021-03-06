#NOTES
# Deploys to heroku/pg should do: heroku config:set BUNDLE_WITHOUT="oracle"
# Deploys to oracle servers should do: heroku config:set BUNDLE_WITHOUT="pg"

source 'https://rubygems.org'

# Required in Rails 4 for logs to work in production
gem 'rails_12factor', group: :production
gem 'quiet_assets', group: :development

gem 'thin'
gem 'airbrake'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.7' #'4.2.0.beta4'


group :pg do
  # Use postgresql as the database for Active Record
  gem 'pg'
end

group :oracle do
  # Use oracle...
  gem "activerecord-oracle_enhanced-adapter", "~> 1.5.0"
  gem 'ruby-oci8', '~> 2.1.0'
end

# User HAML for views
gem 'haml'

# Debugging
gem 'byebug'

# Helps Store Secrets Securely for Heroku Deploys
gem 'figaro'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 3.1.2' #'~> 4.0.0.beta2'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
#gem 'pjax_rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring', group: :development

# Bootstrap and Styles
gem 'sass-rails', '~> 4.0.4' #'~> 5.0.0.beta1' #MARSHALL
gem 'bootstrap-sass'
gem 'autoprefixer-rails'
gem 'font-awesome-rails'

# Authentication
gem 'devise'

# Scaffold Generation
gem 'bootstrap-generators', '~> 3.2.0'

# Markdown Support
gem 'redcarpet', '~> 3.2.0'

# Directed Acyclic Graph
gem 'acts-as-dag'

# Authorization
gem 'rolify'
gem 'authority'

# Facebook
gem 'koala'

# Forum
gem 'forem', :github => "openpprn/forem", :branch => "rails-4.2"
gem 'kaminari', '~> 0.16.1'

# Blogs and Notifications
gem 'acts-as-taggable-on'
gem 'acts_as_commentable'
#gem 'acts_as_commentable_with_threading'

# User Profile
gem 'geocoder'
gem 'carrierwave'
gem 'mini_magick'

# Merit, Karma Points and Badges
gem 'merit'

# For Third-Party API Connections
# gem 'validic' -- handrolling for now, since their gem has no documnetation
gem 'faraday'

# HighCharts
gem "highcharts-rails"

# Enables detection and linking of links in string/texts. Use auto_link(my_string)
gem "rails_autolink"

# Development
group :development do
  gem "better_errors"
  gem "meta_request"
  gem "binding_of_caller"
end


# Testing
group :development, :test do
  gem 'minitest-rails'
  gem 'minitest-reporters'
  gem 'minitest-rails-capybara'
  gem 'selenium-webdriver'
end

gem 'simplecov', :require => false, :group => :test

gem 'whenever' #enables cron jobs (for removing no-longer deserved badges for example)
