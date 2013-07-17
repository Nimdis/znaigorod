class Affiche < ActiveRecord::Base
end

class Competition < Affiche
end

class Concert < Affiche
end

class Exhibition < Affiche
end

class MasterClass < Affiche
end

class Movie < Affiche
end

class Other < Affiche
end

class Party < Affiche
end

class Spectacle < Affiche
end

class SportsEvent < Affiche
end

class ChangeAffiche < ActiveRecord::Migration
  def up
    add_column :affiches, :kind, :text, default: []

    pg = ProgressBar.new(Affiche.all.count)

    Affiche.all.each do |affiche|
      affiche.update_attribute :kind, [affiche.type.downcase]
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
