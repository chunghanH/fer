class ListsController < ApplicationController
	def index
	  currency = "USD"
	  url_current = "http://rate.bot.com.tw/xrt?Lang=zh-TW"
	  url_histroy = "http://rate.bot.com.tw/xrt/quote/l6m/#{@currency}"
	  lists = DashBoard.new(url_current, url_histroy, currency)
	  @lists = lists.analysis
	end
end

class DashBoard
  def initialize(url_current, url_histroy, currency)
  	extend NiceTool
  	@url_current = url_current
  	@url_histroy = url_histroy
  	@currency = currency
  end

  def analysis
    lists=[]
    current_data.each do |cp|
      if cp[:currency] =~ /#{@currency}/
	    lists << {
	      currency: @currency,
	      min_date: history_data[:min_date],
	      min_sold: history_data[:min_sold],
	      max_date: history_data[:max_date],
	      max_bought: history_data[:max_bought],
	      we_buy: cp[:we_buy],
	      we_sell: cp[:we_sell],
	    }
      end
    end
    lists
  end

  def current_data
	  doc = Nokogiri::HTML(open(@url_current))
	  lists = []
	  doc.css("table tbody tr").each do |row|
	  	datas = row.css("td")
	  	lists << {
	  	  currency: datas[0] && replace_value(datas[0].text),
	  	  we_buy: datas[3] && replace_value(datas[3].text),
	  	  we_sell: datas[4] && replace_value(datas[4].text),
	  	}
	  end
	  lists
  end

  def history_data
  	max_bought = '0'
  	min_sold = '500'
  	max_date = ''
  	min_date = ''
  	doc = Nokogiri::HTML(open(@url_histroy))
  	puts @url_histroy
	doc.css("table tbody tr").each do |row|
	  datas = row.css("td")

	    date = datas[0] && replace_value(datas[0].text)
	   #  we_bought = datas[4] && replace_value(datas[4].text)
	  	# we_sold = datas[5] && replace_value(datas[5].text)
	  	we_bought = datas[4] && (datas[4].text)
	  	we_sold = datas[5] && (datas[5].text)
	  	puts "#{we_bought}"
	  	# puts "#{we_sold}"

	  	if we_bought.to_f > max_bought.to_f
	      max_bought = we_bought
	      max_date = date
	    end

	    if we_sold.to_f < min_sold.to_f
	      min_sold = we_sold
	      min_date = date
		end
	end

    lists = {
    	max_bought: max_bought, 
    	min_sold: min_sold, 
    	max_date: max_date, 
    	min_date: min_date,
    }
    	  	  

  end

  def crawler

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