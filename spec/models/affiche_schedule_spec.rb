require 'spec_helper'

describe AfficheSchedule do
  let(:affiche_schedule_attributes) { Hash[:affiche_schedule_attributes => Fabricate.attributes_for(:affiche_schedule)] }
  let(:attributes) { Fabricate.attributes_for(:exhibition).merge(affiche_schedule_attributes) }
  let(:exhibition) { Exhibition.create! attributes }

  describe 'should create showings for affiche' do
    it { exhibition.showings.count.should == 4 }

    subject { exhibition.showings.first }

    its(:place) { should == 'place' }
    its(:hall) { should == 'hall' }
    its(:starts_at) { should == Time.zone.parse('2012-06-01 11:00') }
    its(:ends_at) { should == Time.zone.parse('2012-06-01 17:00') }
    its(:price_min) { should == 100 }
    its(:price_max) { exhibition.showings.first.price_max.should == 0 }
  end

  describe 'should destroy affiche showings' do
    before { exhibition.affiche_schedule.destroy }

    it { exhibition.showings.should be_empty }
  end

  describe 'should delete old showings before creation new' do
  end
end

# == Schema Information
#
# Table name: affiche_schedules
#
#  id              :integer          not null, primary key
#  afisha_id       :integer
#  starts_on       :date
#  ends_on         :date
#  starts_at       :time
#  ends_at         :time
#  holidays        :string(255)
#  place           :string(255)
#  hall            :string(255)
#  price_min       :integer
#  price_max       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :integer
#  latitude        :string(255)
#  longitude       :string(255)
#

