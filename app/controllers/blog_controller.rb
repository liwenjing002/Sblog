class BlogController < ApplicationController
  uses_tiny_mce
  def list
    p params[:type]
    render :layout => false
  end

  def new_blog
    @blog = Blog.new()
    return unless request.post?
    @blog = Blog.new(params[:blog])
    @blog.owner_id =session[:login_id]
    @blog.blog_type = params["type2"][0] if params["type2"]
    if  @blog.save
      redirect_to :controller=>"home"
    end
    
  end


  def select_with_ajax
    type_list = APP_CONFIG["type"]
    @types = []
    type_list.each{|type|
      type["children"].each{|c_type|
        @types<<[t(c_type["value"]),c_type["code"]]
      } if type["code"]==params[:father] and   type["children"]
    }
    render(:layout => false)
  end

end
