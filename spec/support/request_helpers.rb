module Requests
  module JsonHelpers
    def json_data
      JSON.parse(response.body, symbolize_names: true)[:data]
    end

    def json_error
      JSON.parse(response.body, symbolize_names: true)[:errors]
    end
  end
end
