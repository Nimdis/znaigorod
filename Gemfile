source 'http://rubygems.org'

group :assets do
  gem 'jcrop-rails'
  gem 'jquery-fileupload-rails'
  gem 'libv8',                      '~> 3.11.8' unless RUBY_PLATFORM =~ /freebsd/
  gem 'therubyracer',               :platforms => :ruby, :require => 'v8'
  gem 'turbo-sprockets-rails3'
  gem 'uglifier'
end

group :default do
  gem 'RedCloth'
  gem 'active_attr'
  gem 'activemerchant',             :require => 'active_merchant'
  gem 'ancestry'
  gem 'attribute_normalizer'
  gem 'auto_html'
  gem 'cancan'
  gem 'coffee-rails'
  gem 'compass-rails'
  gem 'curb',                       :require => false
  gem 'daemons'
  gem 'default_value_for'
  gem 'devise'
  gem 'devise-russian'
  gem 'draper'
  gem 'el_vfs_client'
  gem 'enumerize',                  :git => 'git://github.com/brainspec/enumerize', :branch => 'master' # NOTE https://github.com/brainspec/enumerize/pull/87
  gem 'esp-ckeditor'
  gem 'fastimage'
  gem 'friendly_id'
  gem 'gilenson'
  gem 'grape',                      '~> 0.6.0'
  gem 'grape-entity'
  gem 'has_scope'
  gem 'has_searcher'
  gem 'hashie',                     '~> 2.0.5'
  gem 'htmldiff'
  gem 'inherited_resources',        :git => 'git://github.com/DouweM/inherited_resources', :branch => 'nested-singletons' # NOTE: https://github.com/josevalim/inherited_resources/pull/194
  gem 'jquery-rails',               '2.0.3'
  gem 'kaminari'
  gem 'koala', "~> 1.7.0rc1"
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
  gem 'postmark-rails'
  gem 'progress_bar'
  gem 'rails'
  gem 'recaptcha',                  :require => 'recaptcha/rails'
  gem 'russian'
  gem 'sanitize'
  gem 'sass-rails'
  gem 'sidekiq'
  gem 'simple-navigation'
  gem 'simple_form'
  gem 'sinatra',                    :require => false
  gem 'sitemap_generator'
  gem 'state_machine'
  gem 'sunspot_rails'
  gem 'text-hyphen'
  gem 'timecop',                    :require => false
  gem 'validates_email_format_of'
  gem 'vkontakte_api',              :require => false
end

group :development do
  gem 'annotate',                   :require => false
  gem 'brakeman'
  gem 'capistrano-db-tasks',        :git => 'git://github.com/sgruhier/capistrano-db-tasks'
  gem 'capistrano-unicorn'
  gem 'debugger'
  gem 'hirb'
  gem 'letter_opener'
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
