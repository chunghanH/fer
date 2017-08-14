class CurrenciesController < ApplicationController

  def create
  	@currency = Currency.create(currency_params)
  	if @currency.save
  	  redirect_to lists_path
  	else
  	  render '/lists'
  	end 
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
