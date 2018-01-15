require "rails_helper"

RSpec.describe ContractSerializer do
  describe "with a Contract object" do
    let(:user) { create(:user) }
    let(:contract) { create(:contract) }
    let(:serializer) { described_class.new(contract) }
    let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

    it "returns the a valid JSON-schema" do
      expect(serialization.to_json).to match_response_schema(:contract)
    end
  end
end
