class ListsController < ApplicationController
	def index
	  currency = "USD"
	  url_current = "http://rate.bot.com.tw/xrt?Lang=zh-TW"
	  url_histroy = "http://rate.bot.com.tw/xrt/quote/l6m/#{@current}"
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
      
      puts 
      if cp[:currency] =~ /#{@currency}/
	    lists << {
	      currency: @currency,
	      min_date: histroy_data[:min_date],
	      min_sell: histroy_data[:min_sell],
	      max_date: histroy_data[:max_date],
	      max_buy: histroy_data[:max_buy],
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
	  doc.css("table tr").each do |row|
	  	datas = row.css("td")
	  	lists << {
	  	  currency: datas[0] && replace_value(datas[0].text),
	  	  we_buy: datas[3] && replace_value(datas[3].text),
	  	  we_sell: datas[4] && replace_value(datas[4].text),
	  	}
	  end
	  lists
  end

  def histroy_data
  	max_buy = 0
  	min_sell = 1000
  	max_date = ''
  	min_date = ''
  	doc = Nokogiri::HTML(open(@url_histroy))
	doc.css("table tr").each do |row|
	  datas = row.css("td")

	    date = datas[0] && replace_value(datas[0].text)
	    currency = datas[1] && replace_value(datas[1].text)
	    we_buy = datas[4] && replace_value(datas[4].text)
	  	we_sell = datas[5] && replace_value(datas[5].text)

	  	if we_buy > max_buy
	      max_buy = we_buy 
	      max_date = date
	    end

	    if we_sell < min_sell
	      min_sell = we_sell 
	      min_date = date
		end
	end
    lists = {max_buy: max_buy, min_sell: min_sell, max_date: 'max_date', min_date: 'min_date'}
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