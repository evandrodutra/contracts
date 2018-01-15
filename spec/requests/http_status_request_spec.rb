require "rails_helper"

RSpec.describe "HTTP Status Resquests", type: :request do
  let(:contract) { create(:contract) }
  let(:authorization_header) { { "Authorization" => "Bearer #{Auth.issue_token(contract.user.id)}" } }

  it "responds with status :created" do
    post "/users", params: { data: { attributes: { full_name: "Marvin", email: "paranoid@example.com", password: "humans" } } }

    expect(response).to have_http_status :created
  end

  it "responds with status :unprocessable_entity" do
    post "/users", params: { data: { attributes: { full_name: nil, email: nil, password: nil } } }

    expect(response).to have_http_status :unprocessable_entity
  end

  it "responds with status :bad_request" do
    post "/users", params: {}

    expect(response).to have_http_status :bad_request
    expect(json_error[:status]).to eq(400)
    expect(json_error[:detail]).to eq("param is missing or the value is empty: data")
  end

  it "responds with status :ok" do
    get "/contracts/#{contract.id}", headers: authorization_header

    expect(response).to have_http_status :ok
  end

  it "responds with status :no_content" do
    delete "/contracts/#{contract.id}", headers: authorization_header

    expect(response).to have_http_status :no_content
  end

  it "responds with status :unauthorized" do
    get "/contracts/#{contract.id}"

    expect(response).to have_http_status :unauthorized
    expect(json_error[:status]).to eq(401)
    expect(json_error[:detail]).to eq("Unauthorized")
  end

  it "responds with status :not_found" do
    get "/contracts/wrong-uuid", headers: authorization_header

    expect(response).to have_http_status :not_found
    expect(json_error[:status]).to eq(404)
    expect(json_error[:detail]).to eq("Contract not found")
  end
end
