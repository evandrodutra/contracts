require "rails_helper"

RSpec.describe "Contract Resquests", type: :request do
  let(:user) { create(:user) }
  let(:leaker) { create(:user, email: "leaker@example.com") }
  let(:authorization_header) { { "Authorization" => "Bearer #{Auth.issue_token(user.id)}" } }
  let(:contracts_attributes) { { vendor: "DB", starts_on: Time.current.utc, ends_on: 1.year.from_now.utc, price: 99.98 } }

  # As  a user
  # I want to  create a contract
  # So that  I can safely store and retrieve information about it
  describe "#create" do
    # Given  I have an account
    # When  a request is performed with valid values
    # Then  a contract should be created
    it "creates an contract" do
      post "/contracts", params: { data: { attributes: contracts_attributes } }, headers: authorization_header

      expect(response).to have_http_status :created
      expect(JSON.parse(response.body)).to match_response_schema(:contract)
    end

    # Given  I have an account
    # When  a request is performed with an empty vendor
    # Then  a contract should not be created
    # And  I the response should include the “Vendor should not be empty” message
    it "returns an error message for invalid vendor attribute" do
      contracts_attributes[:vendor] = nil

      post "/contracts", params: { data: { attributes: contracts_attributes } }, headers: authorization_header

      expect(response).to have_http_status :unprocessable_entity
      expect(json_error[0][:detail]).to eq("Vendor should not be empty")
    end

    # Given  I have an account
    # When  a request is performed with an empty  starts_on
    # Then  a contract should not be created
    # And  the response should include the “Starts on should not be empty” message
    it "returns an error message for invalid starts_on attribute" do
      contracts_attributes[:starts_on] = nil

      post "/contracts", params: { data: { attributes: contracts_attributes } }, headers: authorization_header

      expect(response).to have_http_status :unprocessable_entity
      expect(json_error[0][:detail]).to eq("Starts on should not be empty")
    end

    # Given  I have an account
    # When  a request is performed with an empty  ends_on
    # Then  a contract should not be created
    # And  the response should include the “Ends on should not be empty” message
    it "returns an error message for invalid ends_on attribute" do
      contracts_attributes[:ends_on] = nil

      post "/contracts", params: { data: { attributes: contracts_attributes } }, headers: authorization_header

      expect(response).to have_http_status :unprocessable_entity
      expect(json_error[0][:detail]).to eq("Ends on should not be empty")
    end

    # Given  I have an account
    # When  a request is performed with an  ends_on  <  starts_on
    # Then  a contract should not be created
    # And  the response should include the “Ends on should be greater than Starts on” message
    it "returns an error message for invalid ends_on when it is less than starts_on attribute" do
      contracts_attributes[:ends_on] = contracts_attributes[:starts_on] - 2.years

      post "/contracts", params: { data: { attributes: contracts_attributes } }, headers: authorization_header

      expect(response).to have_http_status :unprocessable_entity
      expect(json_error[0][:detail]).to eq("Ends on should be greater than Starts on")
    end
  end

  # As  a user
  # I want to  get information about a contract
  # So that  I use it
  describe "#show" do
    let(:contract) { create(:contract, user: user) }

    # Given  I have an account
    # When  a request is performed to a contract that belongs to me
    # Then  I should see all the contract available fields
    it "lists an contract" do
      get "/contracts/#{contract.id}", headers: authorization_header

      expect(response).to have_http_status :ok
      expect(JSON.parse(response.body)).to match_response_schema(:contract)

      expect(json_data[:id]).to eq(contract.id)
      expect(json_data[:attributes][:vendor]).to eq(contract.vendor)
      expect(json_data[:attributes][:"starts-on"]).to eq(contract.starts_on.to_s(:db))
      expect(json_data[:attributes][:"ends-on"]).to eq(contract.ends_on.to_s(:db))
      expect(json_data[:attributes][:price]).to eq(contract.price.to_s)
    end

    # Given  I have an account
    # When  a request is performed to a contract that does not belong to me
    # Then  I should see “Contract not found” error to prevent information leaking
    context "using a not assigned token" do
      let(:authorization_header) { { "Authorization" => "Bearer #{Auth.issue_token(leaker.id)}" } }

      it "do not list a contract" do
        get "/contracts/#{contract.id}", headers: authorization_header

        expect(response).to have_http_status :not_found
        expect(json_error[:status]).to eq(404)
        expect(json_error[:detail]).to eq("Contract not found")
      end
    end
  end

  # As  a user
  # I want to  delete a contract
  # So that  I no longer manage it
  describe "#destroy" do
    let(:contract) { create(:contract, user: user) }

    # Given  I have an account
    # When  a request is performed to a contract that belongs to me
    # Then  the contract should be deleted
    it "deletes an contract" do
      delete "/contracts/#{contract.id}", headers: authorization_header

      expect(response).to have_http_status :no_content
      expect(Contract.where(id: contract.id).first).to be_nil
    end

    # Given  I have an account
    # When  a request is performed to a contract that does not belong to me
    # Then  the contract should not be deleted
    # And  I should see “Contract not found” error to prevent information leaking
    context "using a not assigned token" do
      let(:authorization_header) { { "Authorization" => "Bearer #{Auth.issue_token(leaker.id)}" } }

      it "do not delete a contract" do
        delete "/contracts/#{contract.id}", headers: authorization_header

        expect(response).to have_http_status :not_found
        expect(json_error[:status]).to eq(404)
        expect(json_error[:detail]).to eq("Contract not found")
        expect(Contract.where(id: contract.id).first).to_not be_nil
      end
    end
  end
end
