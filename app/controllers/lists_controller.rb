class ListsController < ApplicationController
	def index
	  # FerWorkerJob.set( wait: 1.minutes ).perform_later
	  FerWorkerJob.perform_later
	  @currencies = Currency.all
	end

	def about
		@str = 'hello i am tom'
	end
end