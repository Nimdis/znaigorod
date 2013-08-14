class ChangeImagesStringToText < ActiveRecord::Migration
  def up
    change_table :afisha do |t|
      t.change :poster_url, :text
      t.change :image_url, :text
    end
  end

  def down
    change_table :afisha do |t|
      t.change :poster_url, :string
      t.change :image_url, :string
    end
  end
end
