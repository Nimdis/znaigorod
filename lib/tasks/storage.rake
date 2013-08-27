# encoding: utf-8

require 'progress_bar'

desc 'Migrate data from storage to dev-storage'
task :storage => :environment do

  models = {
    'Account'       => 'avatar_url',
    'Afisha'        => 'image_url',
    'Afisha'        => 'poster_image_url',
    'Afisha'        => 'poster_url',
    'Attachment'    => 'file_url',
    'Coupon'        => 'image_url',
    'MenuPosition'  => 'image_url',
    'Organization'  => 'logotype_url',
    'Post'          => 'poster_url',
    'Work'          => 'image_url',
  }

  models.map do |klass, field|
    puts "Update #{klass}##{field}"
    items = klass.classify.constantize.where("#{field} IS NOT NULL AND #{field} LIKE 'http://storage%'")
    bar = ProgressBar.new(items.count)
    items.each do |item|
      item.update_column(field.to_sym, item.send(field).gsub('http://storage', 'http://dev-storage'))
      bar.increment!
    end
  end

end
