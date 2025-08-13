source "https://rubygems.org"

gem "rails", "~> 8.0.2"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

# Para Active Storage variants (procesar imágenes)
gem "image_processing", "~> 1.14"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false

  # RuboCop base + preset recomendado por Rails
  gem "rubocop", require: false
  gem "rubocop-rails-omakase", require: false

  # Cops adicionales para Rails y performance
  gem "rubocop-rails", require: false
  gem "rubocop-performance", require: false

  # Soporte para linting de vistas ERB
  gem "rubocop-erb", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
