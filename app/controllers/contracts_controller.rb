class ContractsController < ApplicationController
  before_action :assign_contract, only: %i[show destroy]

  def show
    render json: @contract, status: :ok
  end

  def create
    @contract = current_user.contracts.new(contract_params[:attributes])

    if @contract.save
      render json: @contract, status: :created
    else
      respond_with_errors(@contract.errors.to_hash(true))
    end
  end

  def destroy
    @contract.destroy!
    head :no_content
  end

  private

  def contract_params
    params.require(:data).permit(:contract,
      attributes: %i[vendor starts_on ends_on price])
  end

  def assign_contract
    @contract = current_user.contracts.where(id: params[:id]).first

    return respond_with_not_found("Contract") unless @contract
  end
end
