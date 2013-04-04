class SetProviderForExistingUsers < ActiveRecord::Migration
  def up
    User.where('provider is NULL').update_all(provider: 'vkontakte')
  end

  def down
  end
end
