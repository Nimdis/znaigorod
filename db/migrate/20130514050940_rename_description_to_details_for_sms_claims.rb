class RenameDescriptionToDetailsForSmsClaims < ActiveRecord::Migration
  def change
    rename_column :sms_claims, :description, :details
  end
end
