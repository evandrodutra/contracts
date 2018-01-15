require "rails_helper"

RSpec.describe "HTTP Status Resquests", type: :request do
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
end
