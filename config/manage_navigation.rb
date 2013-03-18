# -*- coding: utf-8 -*-

SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|

    primary.item :users, 'Пользователи', manage_admin_users_path,
      :highlights_on => ->(){ controller_name == 'users' || resource_class.try(:superclass) == User },
      :unless => -> { (current_user.roles & ["admin"]).empty? }

    primary.item :organisations, 'Заведения', manage_organizations_path,
      :highlights_on => ->(){ controller_name == 'organizations' || resource_class.try(:superclass) == Organization },
      :unless => -> { (current_user.roles & ["admin", "organizations_editor"]).empty? }

    primary.item :affiches, 'Мероприятия города', manage_affiches_path,
      :highlights_on => ->(){ controller_name == 'affiches' || resource_class.try(:superclass) == Affiche },
      :unless => -> { (current_user.roles & ["admin", "affiches_editor"]).empty? }

    primary.item :posts, 'Посты', manage_posts_path,
      :highlights_on => ->(){ controller_name == 'posts' || resource_class.try(:superclass) == Post },
      :unless => -> { (current_user.roles & ["admin", "posts_editor"]).empty? }

    primary.item :main_page, 'Публичный вид', root_url

    primary.dom_class = 'navigation'
  end
end
