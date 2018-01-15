class ApplicationController < ActionController::API
  before_action :authenticate_user

  def respond_with_unauthorized
    render_errors(data: { status: 401, detail: "Unauthorized" }, status: :unauthorized)
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
