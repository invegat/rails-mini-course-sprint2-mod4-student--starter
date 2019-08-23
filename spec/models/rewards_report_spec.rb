require 'rails_helper'

RSpec.describe RewardsReport do
  describe "#notify" do
    let(:rewards) { [
      double("reward", purchase_count: 30, id: 1),
      double("reward", purchase_count: 70, id: 2),
      double("reward", purchase_count: 100, id: 3)              
    ]}
    it "should total the purchase_count values" do
      allow(NotificationService).to receive(:send_purchase_report)

      rr = RewardsReport.new(rewards)
      rr.notify()

      expect(NotificationService).to have_received(:send_purchase_report).with(200) 
    end
  end
end
