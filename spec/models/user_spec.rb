require "rails_helper"

RSpec.describe User, type: :model do

  describe "validations" do
    it { expect(subject).to have_secure_password }
    it { expect(subject).to have_many(:contracts) }
    it { expect(subject).to validate_presence_of(:full_name) }
    it { expect(subject).to validate_presence_of(:email) }
    it { expect(subject).to validate_presence_of(:password_digest) }
    it { expect(subject).to validate_uniqueness_of(:email).case_insensitive }

    it "for an invalid email format" do
      expect(subject).not_to allow_value("@example.com").for(:email)
    end

    it "for a valid email format" do
      expect(subject).to allow_value("example@example.com").for(:email)
    end
  end
end
