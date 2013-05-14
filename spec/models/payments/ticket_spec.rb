require 'spec_helper'

describe Ticket do
  let(:ticket) { Fabricate :ticket }
  subject { ticket }

  describe 'set code and state after create' do
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

  describe 'sending a message when purchasing' do
    before { ticket.sell! }

    its(:sms) { should be_persisted }

    context 'phone of sms' do
      it { ticket.sms.phone.should == ticket.payment.phone }
    end
  end
end
