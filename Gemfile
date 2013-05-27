source 'http://rubygems.org'

group :assets do
  gem 'jcrop-rails'
  gem 'libv8',                      '~> 3.11.8' unless RUBY_PLATFORM =~ /freebsd/
  gem 'therubyracer',               :platforms => :ruby, :require => 'v8'
  gem 'turbo-sprockets-rails3'
  gem 'uglifier'
end

group :default do
  gem 'RedCloth'
  gem 'active_attr'
  gem 'activemerchant', :require => 'active_merchant'
  gem 'ancestry'
  gem 'attribute_normalizer'
  gem 'auto_html'
  gem 'cancan'
  gem 'coffee-rails'
  gem 'compass-rails'
  gem 'curb',                       :require => false
  gem 'daemons'
  gem 'default_value_for'
  gem 'delayed_job_active_record'
  gem 'devise'
  gem 'devise-russian'
  gem 'draper'
  gem 'el_vfs_client'
  gem 'enumerize'
  gem 'esp-ckeditor'
  gem 'fastimage'
  gem 'friendly_id'
  gem 'gilenson'
  gem 'grape'
  gem 'has_scope'
  gem 'has_searcher'
  gem 'hashie'
  gem 'inherited_resources',        :git => 'git://github.com/DouweM/inherited_resources', :branch => 'nested-singletons' # NOTE: https://github.com/josevalim/inherited_resources/pull/194
  gem 'jquery-rails',               '2.0.3'
  gem 'kaminari'
  gem 'mainsms_api'
  gem 'nested_form'
  gem 'omniauth-facebook'
  gem 'omniauth-google-oauth2'
  gem 'omniauth-mailru'
  gem 'omniauth-odnoklassniki'
  gem 'omniauth-twitter'
  gem 'omniauth-vkontakte'
  gem 'omniauth-yandex'
  gem 'openteam-commons'
  gem 'paperclip-elvfs'
  gem 'pg',                         :require => false
  gem 'progress_bar'
  gem 'rails'
  gem 'recaptcha',                  :require => 'recaptcha/rails'
  gem 'russian'
  gem 'sass-rails'
  gem 'simple-navigation'
  gem 'simple_form'
  gem 'sitemap_generator'
  gem 'sunspot_rails'
  gem 'text-hyphen'
  gem 'timecop',                    :require => false
  gem 'validates_email_format_of'
  gem 'vkontakte_api',              :require => false
end

group :development do
  gem 'annotate',                   :require => false
  gem 'brakeman'
  gem 'capistrano-db-tasks', :git => 'git://github.com/sgruhier/capistrano-db-tasks'
  gem 'capistrano-unicorn'
  gem 'debugger'
  gem 'hirb'
  gem 'openteam-capistrano'
  gem 'quiet_assets'
  gem 'rails-erd'
  gem 'sunspot_solr'
  gem 'thin'
end

group :test do
  gem 'fabrication',                :require => false
  gem 'rspec-rails',                :require => false
  gem 'sqlite3',                    :require => false
  gem 'sunspot_matchers',           :require => false
  gem 'freeze_time'
end
