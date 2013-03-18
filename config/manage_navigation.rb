# -*- coding: utf-8 -*-

SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|

    primary.item :users, 'Пользователи', manage_admin_users_path,
      :highlights_on => ->(){ controller_name == 'users' || resource_class.try(:superclass) == User },
      :if => -> { can?(:manage, User) }

    primary.item :organisations, 'Заведения', manage_organizations_path,
      :highlights_on => ->(){ (controller_name == 'organizations' || resource_class.try(:superclass) == Organization) && namespace != 'crm'},
      :if => -> { can?(:manage, Organization) } do |org_item|
        [Meal, Entertainment, Culture, Sauna, Sport, Creation].each do |kind|
          org_item.item kind, kind.model_name.human, [:manage, kind.model_name.underscore.pluralize]
        end
    end

    primary.item :affiches, 'Мероприятия города', manage_affiches_path,
      :highlights_on => ->(){ controller_name == 'affiches' || resource_class.try(:superclass) == Affiche },
      :if => -> { can?(:manage, Affiche) } do |affiche_item|
        Affiche.ordered_descendants.each do |kind|
          affiche_item.item kind, kind.model_name.human, [:manage, kind.model_name.underscore.pluralize]
        end
    end

    primary.item :posts, 'Конкурсы', manage_contests_path,
      :highlights_on => ->(){ resource_class == Contest },
      :if => -> { can?(:manage, Contest) }

    primary.item :posts, 'Посты', manage_posts_path,
      :highlights_on => ->(){ resource_class == Post },
      :if => -> { can?(:manage, Post) }

    primary.item :crm, 'ЦРМ', crm_root_path,
      :highlights_on => ->(){ namespace == 'crm' },
      :if => -> { can?(:manage, :crm) } do |crm_item|
        [Organization, Activity].each do |kind|
          crm_item.item kind, kind.model_name.human, [:crm, kind.model_name.underscore.pluralize]
        end
    end

    primary.item :main_page, 'Публичный вид', root_url

    primary.dom_class = 'navigation'
  end
end
