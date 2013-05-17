class MakeCopyPolymorpic < ActiveRecord::Migration
  def up
    add_column :copies, :copyable_id, :integer
    add_column :copies, :copyable_type, :string
    add_index :copies, :copyable_id
    add_index :copies, :copyable_type

    Copy.where(:copyable_id => nil).each { |copy| copy.update_column :copyable_id, copy.ticket_info_id }
    Copy.where(:copyable_type => nil).each { |copy| copy.update_column :copyable_type, 'TicketInfo' }

    remove_column :copies, :ticket_info_id
  end

  def down
    add_column :copies, :ticket_info_id, :integer
    add_index :copies, :ticket_info_id

    Copy.where(:ticket_info_id => nil).each { |copy| copy.update_column :ticket_info_id, copy.copyable_id }

    remove_index :copies, :column => :copyable_type
    remove_index :copies, :column => :copyable_id
    remove_column :copies, :copyable_type
    remove_column :copies, :copyable_id
  end
end
