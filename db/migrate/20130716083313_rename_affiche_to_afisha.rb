class RenameAfficheToAfisha < ActiveRecord::Migration
  def up
    rename_table :affiches, :afisha
    rename_column :showings, :affiche_id, :afisha_id
    rename_column :tickets, :affiche_id, :afisha_id
    rename_column :affiche_schedules, :affiche_id, :afisha_id

    attachments = Attachment.where(:attachable_type => 'Affiche')
    pg = ProgressBar.new(attachments.count)

    attachments.each do |a|
      a.update_attribute :attachable_type, 'Afisha'
      pg.increment!
    end

    comments = Comment.where(:commentable_type => 'Affiche')
    pg = ProgressBar.new(comments.count)

    comments.each do |c|
      c.update_attribute :commentable_type, 'Afisha'
      pg.increment!
    end
  end

  def down
    rename_table :afisha, :affiches
    rename_column :showings, :afisha_id, :affiche_id
    rename_column :tickets, :afisha_id, :affiche_id
    rename_column :affiche_schedules, :afisha_id, :affiche_id

    attachments = Attachment.where(:attachable_type => 'Afisha')
    pg = ProgressBar.new(attachments.count)

    attachments.each do |a|
      a.update_attribute :attachable_type, 'Affiche'
      pg.increment!
    end

    comments = Comment.where(:commentable_type => 'Afisha')
    pg = ProgressBar.new(comments.count)

    comments.each do |c|
      c.update_attribute :commentable_type, 'Affiche'
      pg.increment!
    end
  end
end
