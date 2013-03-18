class MoveSaunasUp < ActiveRecord::Migration
  def up
    create_table :saunas do |t|
      t.text     :category
      t.text     :feature
      t.text     :offer
      t.string   :payment
      t.integer  :organization_id
      t.string   :title
      t.text     :description

      t.timestamps
    end

    Sauna.class_eval do
      attr_accessible :organization_id
    end

    pb = ProgressBar.new(Entertainment.where(type: 'Sauna').count)

    Entertainment.where(type: 'Sauna').find_each do |legacy_sauna|
      attributes = legacy_sauna.attributes.delete_if { |attr| %w[id created_at updated_at type].include?(attr) }

      new_sauna = Sauna.new(attributes).tap do |sauna|
        pb.increment! if sauna.save(validate: false)
      end

      %w[sauna_accessory sauna_broom sauna_alcohol sauna_oil sauna_child_stuff sauna_stuff sauna_massage].each do |ass|
        obj = legacy_sauna.send(ass)
        obj.update_column(:sauna_id, new_sauna.id)
      end

      legacy_sauna.sauna_halls.each do |sauna_hall|
        sauna_hall.update_column(:sauna_id, new_sauna.id)
      end

      Image.where(imageable_type: 'Entertainment', imageable_id: legacy_sauna.id).each do |image|
        image.update_column(:imageable_id, new_sauna.id)
        image.update_column(:imageable_type, 'Sauna')
      end
    end

    ActiveRecord::Base.connection.execute("delete from entertainments where type = 'Sauna'")
  end

  def down
  end
end
