class ApplicationController < ActionController::API
  before_action :authenticate_user

  rescue_from ActionController::ParameterMissing, with: :respond_with_bad_request

  def respond_with_errors(errors)
    errors_list = errors.map do |k, m|
      { status: 422, detail: m.join(", "), source: { pointer: "/data/attributes/#{k}" } }
    end

    render_errors(data: errors_list, status: :unprocessable_entity)
  end

  def respond_with_unauthorized
    render_errors(data: { status: 401, detail: "Unauthorized" }, status: :unauthorized)
  end

  def respond_with_bad_request
    render_errors(data: { status: 400, detail: "param is missing or the value is empty: data" }, status: :bad_request)
  end

  def respond_with_not_found(entity_name = nil)
    render_errors(data: { status: 404, detail: "#{entity_name} not found" }, status: :not_found)
  end

  def current_user
    @current_user
  end

  def authenticate_user
    user = Auth.authenticate(authorization_token)
    return respond_with_unauthorized unless user

    @current_user ||= user
  end

  private

  def render_errors(data:, status:)
    render json: { errors: data }, status: status
  end

  def authorization_token
    request.headers["Authorization"].to_s.scan(/Bearer (.*)/).flatten.last
  end
end
