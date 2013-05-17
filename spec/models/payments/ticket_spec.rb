require 'spec_helper'

describe Ticket do
  let(:ticket) { Fabricate :ticket }
  subject { ticket }

  describe 'set code and state' do
    its(:code) { should be_present }
    its(:state) { should == 'for_sale' }
  end

  describe '#reserve!' do
    before { ticket.reserve! }

    its(:state) { should == 'reserved' }
  end

  describe '#release!' do
    before { ticket.release! }

    its(:state) { should == 'for_sale' }
  end

  describe '#sell!' do
    before { ticket.sell! }
    its(:state) { should == 'sold' }
  end
end

# == Schema Information
#
# Table name: tickets
#
#  id             :integer          not null, primary key
#  ticket_info_id :integer
#  state          :string(255)
#  code           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  payment_id     :integer
#

