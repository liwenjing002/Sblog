class HomeController < ApplicationController

  def index
    type = params[:type]if params[:type] != 'o'
    @blogs = Blog.paginate :per_page => 5, :page => params[:page]||1,
      :conditions => ['blog_type like ?',type||"%" ],
      :order =>"created_at desc"
    get_random_tag(params[:tag])
    redirect_to :action=>"tag_search",:tag=>  params[:tag],:way=>params[:way]||"recent" if params[:tag]or params[:way]
  end

  
  def tag_search
    order = "created_at asc" if  params[:way]=="recent"
    order = "replay_count asc" if params[:way]=="popular"
    order = "replay_count desc,created_at desc" if params[:way]=="unreply"
    order = "replay_count asc" if params[:way]=="popular"
    order = "RANDOM()" if params[:way]=="random"
    
    conditions = nil
    conditions =  ['id in ( select blog_id from
                               tags_in_blogs
                             where tag_id = ?)',params[:tag].to_i ] if params[:tag]

    @blogs =Blog.paginate :per_page => 5, :page => params[:page]||1,
      :conditions =>conditions,
      :order =>order
    tag_now = Tag.find_by_id(params[:tag])
    get_random_tag(tag_now)
    render :template => "home/search_tags",:layout => false 
  end


  def get_random_tag(tag_now=nil)
    @tag = tag_now.id if tag_now
    sql = ''
    if tag_now
      sql = "select * from tags where id != #{tag_now.id} order by random() limit 9"
    else
      sql = "select * from tags order by random() limit 10"
    end
    @tags = Tag.find_by_sql(sql)
    @tags << tag_now if tag_now
    
  end

  

end
