def skip_callbacks
  Afisha.skip_callback(:save, :after, :save_images_from_vk)
  Afisha.skip_callback(:save, :after, :save_images_from_yandex_fotki)
end

namespace :statistics do
  desc 'Update Yandex.metrika page views count'
  task :yandex => :environment do
    skip_callbacks

    Statistics::Yandex.new.update_statistics
  end

  desc 'Update VK likes count'
  task :vkontakte => :environment do
    skip_callbacks

    Statistics::Vkontakte.new.update_statistics
  end

  desc 'Update Yandex.metrika and VK statistics'
  task :all => [:yandex, :vkontakte] do
    Showing.index
    Showing.clean_index_orphans
  end
end
