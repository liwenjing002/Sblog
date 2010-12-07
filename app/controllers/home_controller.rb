class HomeController < ApplicationController

  def index
    type = params[:type]
    type = nil if params[:type] == 'o'
    @blogs = Blog.paginate :per_page => 10, :page => params[:page]||1,
      :conditions => ['blog_type like ?',type||"%" ],
      :order => 'created_at'
    render :layout => false if params[:way]
  end


end
