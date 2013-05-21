require 'spec_helper'

describe CopyPayment do
  describe 'check number of tickets' do
    context 'not enough' do
      let(:copy_payment) { Fabricate.build :copy_payment, :number => 15 }
      before { copy_payment.save }

      it { copy_payment.should be_new_record }
      it { copy_payment.errors[:base].should == [I18n.t('activerecord.errors.messages.not_enough_tickets')] }
    end

    context 'enough' do
      let(:ticket) { Fabricate :ticket }
      let(:copy_payment) { Fabricate.build :copy_payment, :number => 5, :paymentable => ticket }

      before { copy_payment.save }

      it { copy_payment.should be_persisted }
    end
  end

  describe 'set amount' do
    let(:ticket) { Fabricate :ticket }
    let(:copy_payment) { Fabricate.build :copy_payment, :number => 5, :paymentable => ticket }

    subject { copy_payment }
    before { subject.save }

    its(:amount) { should == 2500.0 }
  end

  describe 'reserve tickets' do
    let(:ticket) { Fabricate :ticket, :number => 5 }
    let(:copy_payment) { Fabricate :copy_payment, :number => 3, :paymentable => ticket }

    before { copy_payment }

    it { ticket.copies_reserved.count.should == copy_payment.number }
  end

  describe 'approve' do
    let(:ticket) { Fabricate :ticket, :number => 5 }
    let(:copy_payment) { Fabricate :copy_payment, :number => 3, :paymentable => ticket }

    before { copy_payment.approve }

    it { ticket.copies_reserved.count.should be_zero }
    it { ticket.copies_sold.count.should == copy_payment.number }
  end
end

# == Schema Information
#
# Table name: payments
#
#  id         :integer          not null, primary key
#  ticket_id  :integer
#  number     :integer
#  phone      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

