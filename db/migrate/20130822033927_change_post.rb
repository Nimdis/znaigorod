class ChangePost < ActiveRecord::Migration
  def up
    add_column :posts, :rating, :float
    add_column :posts, :kind, :text

    posts = Post.all
    pg = ProgressBar.new(posts.count)
    posts.each do |post|
      post.content = (post.annotation + post.content)
      post.save!
      pg.increment!
    end
    remove_column :posts, :annotation
  end

  def down
    remove_column :posts, :rating
    remove_column :posts, :kind
    add_column :posts, :annotation, :text
  end
end
