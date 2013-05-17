require 'spec_helper'

describe Payment do
  describe 'check number of tickets' do
    context 'not enough' do
      let(:payment) { Fabricate.build :payment, :number => 15 }
      before { payment.save }

      it { payment.should be_new_record }
      it { payment.errors[:base].should == [I18n.t('activerecord.errors.messages.not_enough_tickets')] }
    end

    context 'enough' do
      let(:ticket_info) { Fabricate :ticket_info }
      let(:payment) { Fabricate.build :payment, :number => 5, :ticket_info_id => ticket_info.id }

      before { payment.save }

      it { payment.should be_persisted }
    end
  end

  describe 'reserve tickets' do
    let(:ticket_info) { Fabricate :ticket_info, :number => 5 }
    let(:payment) { Fabricate :payment, :number => 3, :ticket_info_id => ticket_info.id }

    before { payment }

    it { ticket_info.copies_reserved.count.should == payment.number }
  end

  describe 'approve' do
    let(:ticket_info) { Fabricate :ticket_info, :number => 5 }
    let(:payment) { Fabricate :payment, :number => 3, :ticket_info_id => ticket_info.id }

    before { payment.approve }

    it { ticket_info.copies_reserved.count.should be_zero }
    it { ticket_info.copies_sold.count.should == payment.number }
  end
end

# == Schema Information
#
# Table name: payments
#
#  id             :integer          not null, primary key
#  ticket_info_id :integer
#  number         :integer
#  phone          :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#

