class UsersController < ApplicationController
  skip_before_action :authenticate_user

  def create
    @user = User.new(user_params[:attributes])

    if @user.save
      render json: @user, status: :created
    else
      respond_with_errors(@user.errors.to_hash(true))
    end
  end

  private

  def user_params
    params.require(:data).permit(:user,
      attributes: %i[full_name email password])
  end
end
