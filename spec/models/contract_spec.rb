require "rails_helper"

RSpec.describe Contract, type: :model do

  describe "validations" do
    it { expect(subject).to belong_to(:user) }
    it { expect(subject).to validate_presence_of(:user_id) }
    it { expect(subject).to validate_presence_of(:vendor) }
    it { expect(subject).to validate_presence_of(:starts_on) }
    it { expect(subject).to validate_presence_of(:ends_on) }

    it "for an invalid contract period" do
      contract = build(:contract, starts_on: Time.current.utc, ends_on: 10.days.ago.utc)
      expect(contract.valid?).to be_falsey
      expect(contract.errors.messages[:ends_on]).to eq(["should be greater than Starts on"])
    end

    it "for a valid contract period" do
      contract = build(:contract, starts_on: Time.current.utc, ends_on: 10.days.from_now.utc)
      expect(contract.valid?).to be_truthy
    end
  end
end
