source 'https://rubygems.org'

ruby '2.1.1'

gem 'airbrake'
gem 'bourbon', '~> 3.2.1'
gem 'coffee-rails'
gem 'delayed_job_active_record'
gem 'email_validator'
gem 'flutie'
gem 'jquery-rails'
gem 'neat', '~> 1.5.1'
gem 'pg'
gem 'rack-timeout'
gem 'rails', '~> 4.1.0'
gem 'recipient_interceptor'
gem 'sass-rails', '~> 4.0.3'
gem 'simple_form'
gem 'title'
gem 'uglifier'
gem 'unicorn'
gem 'bootstrap-sass', '~> 2.3.1.0'
gem 'slim'
gem 'underscore-rails'
gem 'font-awesome-rails'
gem 'devise'
gem 'omniauth-facebook'
gem 'chronic'
gem 'friendly_id', '~> 5.0.0'
gem 'stripe', git: 'https://github.com/stripe/stripe-ruby'
gem 'activeadmin', github: 'gregbell/active_admin'
gem 'active_admin_editor'
gem 'kaminari'
gem 'geocoder'
gem 'mailboxer'
gem 'acts_as_commentable'
gem 'state_machine'
gem 'whenever', require: false
gem 'searchkick'

group :development do
  gem 'foreman'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
  gem 'rack-mini-profiler'
  gem 'lol_dba'
  gem 'bullet'
  gem 'uniform_notifier'
  gem 'rails_best_practices'
end

group :development, :test do
  gem 'awesome_print'
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'jazz_hands'
  gem 'rspec-rails', '>= 2.14'
end

group :test do
  gem 'capybara-webkit', '>= 1.0.0'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'webmock'
end

group :staging, :production do
  gem 'newrelic_rpm', '>= 3.7.3'
end

gem 'rails_12factor', group: :production