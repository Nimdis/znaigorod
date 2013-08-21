class AddProducerTypeToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :producer_type, :string
    Message.where('producer_id is not null').each do |message|
      message.update_attributes(producer_type: 'Account')
    end
  end
end
