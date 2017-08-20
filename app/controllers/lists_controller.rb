class ListsController < ApplicationController
	def index
	  FerWorkerJob.perform_later
	  @currencies = Currency.all
	  @currency = Currency.new
	  @selection = {
	  	'USD美金' => 'USD', 
	    'EUR歐元' => 'EUR',
	  	'GBP英鎊'=> 'GBP',
	  	'AUD澳幣' => 'AUD',
	  	'CAD加幣' => 'CAD',
	  	'SGD新加坡幣' => 'SGD',
	  	'CHF瑞士法郎' => 'CHF',
	  	'JPY日圓' => 'JPY',
	  	'ZAR南非幣' => 'ZAR',
	  	'SEK瑞典幣' => 'SEK',
	  	'NZD紐元' => 'NZD',
	  	'THB泰幣' => 'THB',
	  	'CNY人民幣' => 'CNY',
	    'HKD港幣' => 'HKD',
	  	# 'PHP菲國比索' => 'PHP',
	  	# 'IDR印尼幣' => 'IDR',
	  	# 'KRW韓元' => 'KRW',
	  	# 'VND越南盾' => 'VND',
	  	# 'MYR馬來幣' => 'MYR',
	  }
	end

	def about
	end
end