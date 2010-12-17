class HomeController < ApplicationController
  before_filter :init_blogs
  def index
    type = params[:type]if params[:type] != 'o'
    @blogs = Blog.paginate :per_page => 5, :page => params[:page]||1,
      :conditions => ['blog_type like ?',type||"%" ],
      :order =>"created_at desc"
    get_random_tag(nil)
    redirect_to :action=>"tag_search",:tag=>  params[:tag],:way=>params[:way]||"recent" if params[:tag]or params[:way]
  end

  
  def tag_search
    order = "created_at desc" if  params[:way]=="recent"
    order = "replay_count desc" if params[:way]=="popular"
    order = "replay_count asc,created_at desc" if params[:way]=="unreply"
    order = "RANDOM()" if params[:way]=="random"
    
    sql = 'id in ( select blog_id from
                               tags_in_blogs
                             where tag_id = ?)'

    sql +=" and TO_CHAR(updated_at,'YYYY-MM') = '#{params[:date]}'" if params[:date]

    conditions = nil
    conditions =  [sql,params[:tag].to_i ] if params[:tag]

    @blogs =Blog.paginate :per_page => 5, :page => params[:page]||1,
      :conditions =>conditions,
      :order =>order
    tag_now = Tag.find_by_id(params[:tag])
    get_random_tag(tag_now)
    render :template => "home/search_tags",:layout => false if !params[:left]
    render :template => "home/search_left_tags",:layout => false  if params[:left]
  end


  def get_random_tag(tag_now=nil,num= 15)
    @tag = tag_now if tag_now
    sql = ''
    if tag_now
      sql = "select * from tags where id != #{tag_now.id} order by random() limit #{num-1}"
    else
      sql = "select * from tags order by random() limit #{num-1}"
    end
    @tags = Tag.find_by_sql(sql)
    
  end

  #初始化一些博客，由于右边的工具栏，几乎一直存在导致每个页面都需要@blogs对象和时间列表@date_list
  def init_blogs
    @blogs =Blog.paginate :per_page => 5, :page => 1

    @date_list = Blog.find_by_sql("select to_char(updated_at,'YYYY-MM') as dates \
                    from blogs  group by dates order by dates asc limit 10")
  end
end
