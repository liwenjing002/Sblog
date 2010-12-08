class BlogController < ApplicationController
  uses_tiny_mce( :options => {
      :theme => 'advanced',  # 皮肤
      :language => 'zh',  # 中文界面
      :convert_urls => false, # 不转换路径，否则在插入图片或头像时，会转成相对路径，容易导致路径错乱。
      :theme_advanced_toolbar_location => "top",  # 工具条在上面
      :theme_advanced_toolbar_align => "left",
      :theme_advanced_resizing => true,  # 似乎不好使
      :theme_advanced_resize_horizontal => false,
      :paste_auto_cleanup_on_paste => true,
      # 工具条上的按钮布局
      :theme_advanced_buttons1 => %w{formatselect fontselect fontsizeselect forecolor backcolor bold italic underline strikethrough sub sup removeformat},
      :theme_advanced_buttons2 => %w{undo redo cut copy paste separator justifyleft justifycenter justifyright separator indent outdent separator bullist numlist separator link unlink image media emotions separator table separator fullscreen},
      :theme_advanced_buttons3 => [],
      # 字体列表中显示的字体
      :theme_advanced_fonts => %w{宋体=宋体;黑体=黑体;仿宋=仿宋;楷体=楷体;隶书=隶书;幼圆=幼圆;Andale Mono=andale mono,times;Arial=arial,helvetica,sans-serif;Arial Black=arial black,avant garde;Book Antiqua=book antiqua,palatino;Comic Sans MS=comic sans ms,sans-serif;Courier New=courier new,courier;Georgia=georgia,palatino;Helvetica=helvetica;Impact=impact,chicago;Symbol=symbol;Tahoma=tahoma,arial,helvetica,sans-serif;Terminal=terminal,monaco;Times New Roman=times new roman,times;Trebuchet MS=trebuchet ms,geneva;Verdana=verdana,geneva;Webdings=webdings;Wingdings=wingdings,zapf dingbats}, # 字体
      # :force_br_newlines => true, # 此选项强制编辑器将段落符号(P)替换成换行符(BR)。不建议用：ff下不好使，用了此选项后，输入内容的居中、清单或编号都被破坏。
      :plugins => %w{contextmenu paste media emotions table fullscreen}},
    :only => [:new_blog])  # tiny_mce考虑的非常贴心，这里是限定哪些action中起用

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

end
