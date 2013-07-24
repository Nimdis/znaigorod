# encoding: utf-8

SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :root, 'ЗнайГород', root_path do |item|
      item.item :users, 'Все пользователи', users_path do |user_item|
        user_item.item :user, @user, user_path if @user
      end
    end
    primary.dom_class = 'breadcrumbs'
  end
end
