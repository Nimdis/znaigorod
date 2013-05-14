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

  describe 'after create reserve tickets' do
    let(:ticket_info) { Fabricate :ticket_info, :number => 5 }
    let(:payment) { Fabricate :payment, :number => 3, :ticket_info_id => ticket_info.id }

    before { payment }

    it { ticket_info.tickets_reserved.count.should == payment.number }
  end

  describe 'approve' do
    let(:ticket_info) { Fabricate :ticket_info, :number => 5 }
    let(:payment) { Fabricate :payment, :number => 3, :ticket_info_id => ticket_info.id }

    before { payment.approve }

    it { ticket_info.tickets_reserved.count.should be_zero }
    it { ticket_info.tickets_sold.count.should == payment.number }
  end
end
