class ChangePost < ActiveRecord::Migration
  def up
    add_column :posts, :rating, :string
    add_column :posts, :kind, :text

    # normalize content
    posts = Post.all
    pg = ProgressBar.new(posts.count)
    posts.each do |post|
      post.content = (post.annotation + post.content)
      while post.content.match(/<([^>]*)>\s*<\/([^>]*)>/i) do
        post.content.gsub!(/<([^>]*)>\s*<\/([^>]*)>/i, '')
      end
      post.save!
      pg.increment!
    end
  end

  def down
    remove_column :posts, :rating
    remove_column :posts, :kind
  end
end
