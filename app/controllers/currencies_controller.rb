class CurrenciesController < ApplicationController

  def create
  	@currency = Currency.create(currency_params)
  	if !@currency.save
      flash[:danger] = @currency.errors.messages
    end
  	redirect_to lists_path
  end

  def destroy
  	@currency = Currency.find(params[:id])
  	@currency.destroy
  	redirect_to lists_path
  end

  private 

  def currency_params
  	params.require(:currency).permit(:name)
  end
end
