require "rails_helper"

RSpec.describe Auth do
  let(:user) { create(:user) }
  let(:token) { described_class.issue_token(user.id) }

  context "issue a new JWT token" do
    it "returns a JWT token for a given user_id" do
      jwt = JWT.encode({ user: user.id },
              described_class::SECRET,
              described_class::ALGORITHM)
      expect(token).to eq(jwt)
    end
  end

  context "authenticates an user" do
    it "with a valid token return true" do
      expect(described_class.authenticate(token)).to eq(user)
    end

    it "with an invalid token return false" do
      expect(described_class.authenticate("#{token}-invalid")).to be_falsey
    end
  end

  context "decodes a given token" do
    it "returns user id when token is valid" do
      expect(described_class.decode(token)).to eq({ user: user.id })
    end

    it "returns false when token is invalid" do
      expect(described_class.decode("#{token}-invalid")).to be_falsey
    end
  end
end
