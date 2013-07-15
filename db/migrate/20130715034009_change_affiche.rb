class ChangeAffiche < ActiveRecord::Migration
  def up
    add_column :affiches, :kind, :text

    pg = ProgressBar.new(Affiche.all.count)

    Affiche.all.each do |affiche|
      affiche.update_column :kind, affiche.type.underscore
      pg.increment!
    end

    remove_column :affiches, :type
  end

  def down
    add_column :affiches, :type, :string

    pg = ProgressBar.new(Affiche.all.count)

    Affiche.all.each do |affiche|
      affiche.update_column :type, affiche.kind.camelize
      pg.increment!
    end

    remove_column :affiches, :kind
  end
end
