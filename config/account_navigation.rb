# encoding: utf-8

SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :root, 'ЗнайГород', root_path do |item|
      item.item :accounts, 'Все пользователи', accounts_path do |account_item|
        account_item.item :account, @account, account_path if @account
      end
    end
    primary.dom_class = 'breadcrumbs'
  end
end
