class AddInviteKindToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :invite_kind, :string
  end
end
