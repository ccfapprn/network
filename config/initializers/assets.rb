# Add to assets path
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')

# Had to add these here to get in Precompile Package
Rails.application.config.assets.precompile += %w( font-awesome-4.2.0/css/font-awesome.min.css )
Rails.application.config.assets.precompile += %w( pages.css )
Rails.application.config.assets.precompile += %w( forem.css forem.js )
Rails.application.config.assets.precompile += %w( social/maps.js social/places.js typeahead-addresspicker.js social/social_profile.js )
Rails.application.config.assets.precompile += %w( .svg .eot .woff .ttf)
Rails.application.config.assets.precompile += %w( reports/default.js )
Rails.application.config.assets.precompile += %w( google_analytics.js )
Rails.application.config.assets.precompile += %w( join.js )
Rails.application.config.assets.precompile += %w( my_dashboard.js )
Rails.application.config.assets.precompile += %w( my_trends.js )
Rails.application.config.assets.precompile += %w( my_connections.js )
Rails.application.config.assets.precompile += %w( research.js )
