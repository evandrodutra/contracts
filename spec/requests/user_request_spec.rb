require "rails_helper"

RSpec.describe "User Resquests", type: :request do
  let(:user_attributes) { { full_name: "Marvin", email: "paranoid@example.com", password: "humans" } }

  # As  a user
  # I want to  create an account on the service
  # So that  I can start managing my contracts
  describe "#create" do
    # Given  I don’t have an account
    # When  perform a request with valid values
    # Then  an account should be created
    it "creates an account" do
      post "/users", params: { data: { attributes: user_attributes } }

      expect(response).to have_http_status :created
    end

    # Given  I don’t have an account
    # When  perform a request with an empty  full_name
    # Then  an account should not be created
    # And  the response should include the “Full Name should not be empty” message
    it "returns an error message for invalid full_name attribute" do
      user_attributes[:full_name] = nil

      post "/users", params: { data: { attributes: user_attributes } }

      expect(response).to have_http_status :unprocessable_entity
      expect(json_error[0][:detail]).to eq("Full name should not be empty")
    end

    # Given  I don’t have an account
    # When  a request is performed with an empty  email
    # Then  an account should not be created
    # And  the response should include the “Email should not be empty” message
    it "returns an error message for invalid email attribute" do
      user_attributes[:email] = nil

      post "/users", params: { data: { attributes: user_attributes } }

      expect(response).to have_http_status :unprocessable_entity
      expect(json_error[0][:detail]).to match(/Email should not be empty/)
    end

    # Given  I don’t have an account
    # When  a request is performed with an empty  password
    # Then  an account should not be created
    # And  the response should include the “Password should not be empty” message
    it "returns an error message for invalid password attribute" do
      user_attributes[:password] = nil

      post "/users", params: { data: { attributes: user_attributes } }

      expect(response).to have_http_status :unprocessable_entity
      expect(json_error[0][:detail]).to eq("Password should not be empty")
    end

    # Given  I don’t have an account
    # When  a request is performed with an existent  email
    # Then  an account should not be created
    # And  the response should include the “Email is already taken” message
    it "returns an error message for an email that is already taken" do
      create(:user, email: "paranoid@example.com")

      post "/users", params: { data: { attributes: user_attributes } }

      expect(response).to have_http_status :unprocessable_entity
      expect(json_error[0][:detail]).to eq("Email is already taken")
    end

    # Given  I don’t have an account
    # When  an account is created
    # Then  a user token should be generated
    # And  this token will be used for authentication purposes
    it "creates an account with a JWT token" do
    end
  end
end
