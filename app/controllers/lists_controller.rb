class ListsController < ApplicationController
	def index
	  extend NiceTool
	  url = "http://rate.bot.com.tw/xrt?Lang=zh-TW"
	  doc = Nokogiri::HTML(open(url))
	  @str = String.new
	  lists = []
	  doc.css("table tr").each do |row|
	  	datas = row.css("td")
	  	lists << {
	  		title: datas[0] && replace_value(datas[0].text),
	  		we_buy: datas[3] && replace_value(datas[3].text),
	  	    we_sell: datas[4] && replace_value(datas[4].text),
	  	}
	  end
	  @str = lists
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


