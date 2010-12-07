class HomeController < ApplicationController
  def index
      @blogs = Blog.paginate :per_page => 10, :page => params[:page]||1

     p 123
  end

  def filter
    @a = "12312"
  render :layout => false
  end
end
