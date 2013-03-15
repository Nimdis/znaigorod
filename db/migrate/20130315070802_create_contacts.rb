class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :full_name
      t.string :post
      t.string :phone
      t.string :mobile_phone
      t.string :email
      t.string :skype
      t.string :vkontakte
      t.string :facebook
      t.references :organization

      t.timestamps
    end
    add_index :contacts, :organization_id
  end
end
