require 'spec_helper'

describe TicketInfo do
  let(:ticket_info) { Fabricate :ticket_info }

  describe 'creates ticket' do
    subject { ticket_info }

    its(:tickets_count) { should == ticket_info.number }
  end
end
