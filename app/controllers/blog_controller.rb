class BlogController < ApplicationController
  layout "temp2"
  before_filter :init_blogs
  def list
    p params[:type]
    render :layout => false
  end

  def new_blog
    @blog = Blog.new()
    return unless request.post?
    @blog = Blog.new(params[:blog])
    @blog.users_id = session[:login_id]
    @blog.blog_type = params["type2"][0] if params["type2"]
    if  @blog.save
      redirect_to :controller=>"home"
    end
    
  end



  def edit_blog   
    if !request.post?
      @blog = Blog.find_by_id(params[:blog_id])
      tag_a =[]
      @blog.tag.each{|tag|
        tag_a << tag.text
      }
      @blog.blog_tags = tag_a.join(",")
      @sceond_type =  @blog.blog_type if @blog.blog_type.length >1
      @blog.blog_type = @blog.blog_type[0,1]
      render :action=> "new_blog"
      return
    end
    
    begin
      @blog = Blog.update(params[:blog][:id],params[:blog])
      @blog.blog_type = params["type2"][0] if params["type2"]
      if @blog.save
        redirect_to :controller=>"home"
      else
        render :action=> "new_blog"
      end
    rescue
      @error_msg = "no blog"
    end
  end

  def delete_blog
    begin
      @blog = Blog.find_by_id(params[:blog_id])
      @blog.delete
      redirect_to :controller=>"home"
    rescue
      @error_msg = "博客无法删除，博客不存在或正在编辑"
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


  def blog_detail
    @blog = Blog.find_by_id(params[:blog_id])
  end


  #初始化一些博客，由于右边的工具栏，几乎一直存在导致每个页面都需要@blogs对象和时间列表@date_list
  def init_blogs
    @blogs =Blog.paginate :per_page => 5, :page => 1

    @date_list = Blog.find_by_sql("select to_char(updated_at,'YYYY-MM') as dates \
                    from blogs  group by dates order by dates asc limit 10")
  end

end
