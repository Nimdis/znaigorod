class AddDescriptionToTicketInfo < ActiveRecord::Migration
  def change
    add_column :ticket_infos, :description, :text
  end
end
