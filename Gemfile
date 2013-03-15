source 'http://rubygems.org'

group :assets do
  gem 'coffee-rails'
  gem 'compass-rails'
  gem 'jquery-rails',               '2.0.3'
  gem 'libv8',                      '~> 3.11.8' unless RUBY_PLATFORM =~ /freebsd/
  gem 'sass-rails'
  gem 'therubyracer',               :platforms => :ruby, :require => 'v8'
  gem 'uglifier'
end

group :default do
  gem 'RedCloth'
  gem 'active_attr'
  gem 'attribute_normalizer'
  gem 'auto_html'
  gem 'cancan'
  gem 'curb',                       :require => false
  gem 'daemons'
  gem 'default_value_for'
  gem 'delayed_job_active_record'
  gem 'draper'
  gem 'el_vfs_client'
  gem 'enumerize'
  gem 'esp-ckeditor'
  gem 'fastimage'
  gem 'formtastic'
  gem 'formtastic'
  gem 'friendly_id'
  gem 'gilenson'
  gem 'grape'
  gem 'has_scope'
  gem 'has_searcher'
  gem 'hashie'
  gem 'inherited_resources',        :git => 'git://github.com/DouweM/inherited_resources', :branch => 'nested-singletons' # NOTE: https://github.com/josevalim/inherited_resources/pull/194
  gem 'kaminari'
  gem 'nested_form'
  gem 'omniauth-twitter'
  gem 'omniauth-vkontakte'
  gem 'openteam-commons'
  gem 'paperclip-elvfs'
  gem 'pg',                         :require => false
  gem 'progress_bar'
  gem 'rails'
  gem 'recaptcha',                  :require => 'recaptcha/rails'
  gem 'russian'
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
  gem 'capistrano-ext'
  gem 'hirb'
  gem 'quiet_assets'
  gem 'rails-erd'
  gem 'rvm-capistrano'
  gem 'sunspot_solr',               '2.0.0.pre.120925'
  gem 'thin'
end

group :test do
  gem 'fabrication',                :require => false
  gem 'rspec-rails',                :require => false
  gem 'sqlite3',                    :require => false
  gem 'sunspot_matchers',           :require => false
  gem 'freeze_time'
end
