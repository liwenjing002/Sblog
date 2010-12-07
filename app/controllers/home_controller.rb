class HomeController < ApplicationController
  def index

  end

  def filter
    @a = "12312"
  render :layout => false
  end
end
