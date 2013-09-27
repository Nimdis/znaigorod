class CreateWebcams < ActiveRecord::Migration
  def change
    create_table :webcams do |t|
      t.string  :kind
      t.text    :title
      t.text    :slug
      t.text    :url
      t.text    :parameters
      t.text    :cab
      t.integer :width
      t.integer :height
      t.text    :address
      t.string  :latitude
      t.string  :longitude
      t.boolean :state

      t.timestamps
    end
    add_index :webcams, :slug
  end
end
