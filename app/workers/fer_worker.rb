class FerWorker
  include Sidekiq::Worker

  def perform(*args)
      currencies = Currency.all
	  currencies.each do |currency|
	  url_current = "http://rate.bot.com.tw/xrt?Lang=zh-TW"
	  url_histroy = "http://rate.bot.com.tw/xrt/quote/l6m/#{currency.name}"
	  lists = FerCrawler.new(url_current, url_histroy, currency.name)
	  lists.current_data
	  lists.history_data
  end
end

class FerCrawler
  def initialize(url_current, url_histroy, currency) 	
  	extend NiceTool
  	@url_current = url_current
  	@url_histroy = url_histroy
  	@currency = currency
  end

  def current_data
	  doc = Nokogiri::HTML(open(@url_current))
	  lists = []
	  doc.css("table tbody tr").each do |row|
	  	datas = row.css("td")
	  	  if datas[0].text =~ /#{@currency}/
	  	    currency = Currency.where(name: @currency)
   		    currency.update(current_buy: datas[3] && replace_value(datas[3].text).to_f,
   		 				    current_sell: datas[4] && replace_value(datas[4].text).to_f
   		    )
   		  end
	  end
  end

  def history_data
  	max_bought = '0'
  	min_sold = '500'
  	max_date = ''
  	min_date = ''
  	doc = Nokogiri::HTML(open(@url_histroy))
	doc.css("table tbody tr").each do |row|
	  datas = row.css("td")

	    date = datas[0] && replace_value(datas[0].text)
	  	we_bought = datas[4] && (datas[4].text)
	  	we_sold = datas[5] && (datas[5].text)

	  	if we_bought.to_f > max_bought.to_f
	      max_bought = we_bought
	      max_date = date
	    end

	    if we_sold.to_f < min_sold.to_f
	      min_sold = we_sold
	      min_date = date
		end
	end

    currency = Currency.where(name: @currency)
    currency.update(max_date: max_date, min_date: min_date, 
    	            history_bought: max_bought.to_f, history_sold: min_sold.to_f)
  end
end


module NiceTool
  def replace_value(data)
    replacement.each {|replacement| data.gsub!(replacement[0], replacement[1])}
    data
  end

  def replacement
  	replacement = [[/\r/, ''], [/\n/, '']]
  end
end
end