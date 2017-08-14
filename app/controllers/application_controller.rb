class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :count_change, :get_section

  def count_change(max, min)
  	result = (min.to_f / max.to_f - 1) * 100.0
  	result.round(3)
  end

  def get_section(max_bought, min_sold, num)
  	section = count_change(max_bought, min_sold)
  	section = section.to_f / num
  end
end

