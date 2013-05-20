require 'spec_helper'

describe Copy do
  let(:copy) { Fabricate :copy }
  subject { copy }

  describe 'set code and state' do
    its(:code) { should be_present }
    its(:state) { should == 'for_sale' }
  end

  describe '#reserve!' do
    before { copy.reserve! }

    its(:state) { should == 'reserved' }
  end

  describe '#release!' do
    before { copy.release! }

    its(:state) { should == 'for_sale' }
  end

  describe '#sell!' do
    before { copy.sell! }
    its(:state) { should == 'sold' }
  end
end

# == Schema Information
#
# Table name: copies
#
#  id            :integer          not null, primary key
#  state         :string(255)
#  code          :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  payment_id    :integer
#  copyable_id   :integer
#  copyable_type :string(255)
#

