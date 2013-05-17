require 'spec_helper'

describe TicketInfo do
  let(:ticket_info) { Fabricate :ticket_info }

  describe 'creates ticket' do
    subject { ticket_info }

    its(:copies_count) { should == ticket_info.number }
  end
end

# == Schema Information
#
# Table name: ticket_infos
#
#  id             :integer          not null, primary key
#  affiche_id     :integer
#  number         :integer
#  original_price :float
#  price          :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  description    :text
#  stale_at       :datetime
#

