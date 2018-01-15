require "rails_helper"

RSpec.describe UserSerializer do
  describe "with a Contract object" do
    let(:user) { create(:user) }
    let(:serializer) { described_class.new(user) }
    let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

    it "returns the a valid JSON-schema" do
      expect(serialization.as_json).to match_response_schema(:user)
    end
  end
end
