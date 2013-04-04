class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.references :user
      t.string :role

      t.timestamps
    end
    add_index :roles, :user_id

    User.find_each do |user|
      user.roles_from_mask.each do |role|
        user.roles.create! role: role
      end
    end
  end
end
