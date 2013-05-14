require 'spec_helper'

describe Ticket do
  let(:ticket) { Fabricate :ticket }
  subject { ticket }

  describe 'set code and state after create' do
    its(:code) { should be_present }
    its(:state) { should == 'for_sale' }
  end

  describe 'states' do
    describe '#reserve!' do
      before { subject.reserve! }
      its(:state) { should == 'reserved' }
    end

    describe '#release!' do
      before { subject.release! }
      its(:state) { should == 'for_sale' }
    end

    describe '#sell!' do
      before { subject.sell! }
      its(:state) { should == 'sold' }
    end
  end

  describe 'sending a message when purchasing' do
    before { subject.sell! }

    its(:sms) { should be_persisted }

    context 'phone of sms' do
      it { subject.sms.phone.should == subject.phone }
    end
  end
end
