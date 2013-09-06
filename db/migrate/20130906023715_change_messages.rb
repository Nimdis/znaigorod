class ChangeMessages < ActiveRecord::Migration
  def change
    messages = PrivateMessage.where("invite_kind IS NOT null")
    pg = ProgressBar.new(messages.count)

    messages.each do |message|
      message.update_column(:type, 'InviteMessage')
      pg.increment!
    end

  end
end
