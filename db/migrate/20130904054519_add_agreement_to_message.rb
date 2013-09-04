class AddAgreementToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :agreement, :string
  end
end
