require 'spec_helper'

describe SmsClaim do
  let(:organization) { Fabricate :organization, :balance => Settings['sms_claim.price'] + 1 }
  let(:sauna) { Fabricate :sauna, :organization => organization }
  let(:sms_claim) { Fabricate :sms_claim, :claimed => sauna }

  describe 'balance' do
    let(:sms_claim) { Fabricate.build :sms_claim, :claimed => sauna }

    before { sms_claim.save }

    context 'not enough' do
      let(:organization) { Fabricate :organization, :balance => Settings['sms_claim.price'] - 1 }

      it { sms_claim.should be_new_record }
      it { sms_claim.errors[:base].should == [I18n.t('activerecord.errors.messages.not_enough_money')] }
    end

    context 'enough' do
      it { sms_claim.should be_persisted }
    end

    describe 'pay' do
      before { sms_claim }

      it { organization.balance.should == 1 }
    end
  end
end
