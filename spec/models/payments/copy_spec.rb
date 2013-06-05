require 'spec_helper'

describe Copy do
  let(:copy) { Fabricate :copy }
  subject { copy }

  describe 'set code and state' do
    its(:code) { should be_present }
    its(:state) { should == 'for_sale' }
  end

  describe '#release!' do
    let(:copy_payment) { copy.copy_payment }
    before { copy.release! }

    its(:state) { should == 'for_sale' }
    it { copy_payment.state.should == 'canceled' }
  end
end

# == Schema Information
#
# Table name: copies
#
#  id              :integer          not null, primary key
#  state           :string(255)
#  code            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  copy_payment_id :integer
#  copyable_id     :integer
#  copyable_type   :string(255)
#  row             :integer
#  seat            :integer
#

