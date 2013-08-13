class AddAvatarAttachmentToAccount < ActiveRecord::Migration
  def change
    add_attachment :accounts, :avatar
  end
end
