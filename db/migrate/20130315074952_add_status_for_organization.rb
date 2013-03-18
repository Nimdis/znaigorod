class AddStatusForOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :status, :string
    Organization.update_all(status: :fresh)
  end
end
