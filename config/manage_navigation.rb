# -*- coding: utf-8 -*-

SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|

    primary.item :users, 'Пользователи', manage_admin_users_path,
      :highlights_on => ->(){ controller_name == 'users' || resource_class.try(:superclass) == User },
      :if => -> { can?(:manage, User) }

    primary.item :organisations, 'Заведения', manage_organizations_path,
      :highlights_on => ->(){ (controller_name == 'organizations' || resource_class.try(:superclass) == Organization) && namespace != 'crm'},
      :if => -> { can?(:manage, Organization) }

    primary.item :affiches, 'Мероприятия города', manage_affiches_path,
      :highlights_on => ->(){ controller_name == 'affiches' || resource_class.try(:superclass) == Affiche },
      :if => -> { can?(:manage, Affiche) }

    primary.item :posts, 'Посты', manage_posts_path,
      :highlights_on => ->(){ controller_name == 'posts' || resource_class.try(:superclass) == Post },
      :if => -> { can?(:manage, Post) }

    primary.item :crm, 'ЦРМ', crm_root_path,
      :highlights_on => ->(){ namespace == 'crm' },
      :if => -> { can?(:manage, :crm) }

    primary.item :main_page, 'Публичный вид', root_url

    primary.dom_class = 'navigation'
  end
end
