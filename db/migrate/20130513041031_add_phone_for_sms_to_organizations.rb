class AddPhoneForSmsToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :phone_for_sms, :string
  end
end
