class CurrenciesController < ApplicationController
  def index
  	@currencies = Currency.all
  	@currency = Currency.new
  end
  def create
  	@currency = Currency.create(currency_params)
  	if @currency.save
  	  redirect_to currencies_path
  	else
  	  render :index
  	end 
  end

  def destroy
  	@currency = Currency.find(params[:id])
  	@currency.destroy
  	redirect_to currencies_path
  end

  private 

  def currency_params
  	params.require(:currency).permit(:name)
  end
end
