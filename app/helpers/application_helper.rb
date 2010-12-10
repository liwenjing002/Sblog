# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def is_login
    session[:is_login]
  end

  #获得登录名
  def get_login_name
    session[:login_name]
  end


  def get_flash(type)
    if flash!= nil && flash.length!=0
      if type=='notice'
        content_tag("div", flash[:notice], "id" =>  "notice", "class" =>  "notice" )
      elsif type=='errorExplanation'
        content_tag("div", content_tag( "h2", "哦哦~~~请注意" ) +\
            content_tag("ul")+content_tag("li", flash[:notice]),\
            "id" =>  "errorExplanation", "class" =>  "errorExplanation" )
      end
    end
  end


  def head_inner_class(href)
    href_class = "menu-item menu-item-type-custom "
    href_class +="current-menu-item current_page_item menu-item-home" if href == self.controller.action_name
  end

  def error_div(model, field)
    return unless model
    field = field.is_a?(Symbol) ? field.to_s : field
    errors = model.errors[field]
    return unless errors
    error_list = []
    errors.each{ | msg| error_list << content_tag("li", msg) }
    content_tag("div", content_tag("ul", error_list), "id" =>  "errorExplanation", \
        "class" =>  "errorExplanation" )
  end


  #加载博客分类列
  def head_content
    type_list = APP_CONFIG["type"]
    content_tag("ul",  get_li_list(type_list),\
        "id" =>  "secondary-menu", "class" =>  "nav clearfix sf-js-enabled" )
  end


  def get_type_by_code(code)
    APP_CONFIG["type"].each{|type|
      return type if type["code"] ==code
      type["children"].each{|c_type|
        return c_type if c_type["code"]==code
      }if type["children"]
    }
  end

  def get_li_list(list)
    li_list = []
    list.each{|type|
      temp_ul = ''
      temp_ul = content_tag("ul",get_li_list(type["children"]),:class=>"sub-menu", \
          :style=>"display: none; visibility: hidden; ") if type["children"]

      li_list<<content_tag("li", link_to(t(type["value"]),"/home?type=#{type["code"]}")+temp_ul,\
          :id=>"menu-item-62" ,:class=>"#{set_li_class(type["code"])}")
    }
    return li_list
  end

  def set_li_class(type)
    class_s = "menu-item menu-item-type-taxonomy"
    params_type = params[:type]||"o"
    class_s +=" current-menu-item current-category-ancestor \
              current-menu-ancestor current-menu-parent menu-item-66 sf-ul" if params_type.include?(type)
  end


  def format_date(date,formate)
    date.strftime(formate)
  end


  def format_string_date(string,patt="%Y-%m")
   date =  Date._strptime(string,patt)
   date =Time.mktime(date[:year],date[:month])
   format_date(date,"%B %Y") if I18n.locale.to_s =='en'
   format_date(date,"%m月  %Y") if I18n.locale.to_s =='zh'
  end



  def strip_html(text,len=0,endss="...")
    if text.length>0
      ss=text.gsub(/<\/?[^>]*>/,"")

      if len>0 && ss.length>0
        ss = truncate_u(ss,len,endss)
      end
    end
    return ss
  end




  def truncate_u(text, length = 30, truncate_string = "   。 。 。")
    l=0
    char_array=text.unpack("U*")
    char_array.each_with_index do |c,i|
      l = l+ (c<127 ? 0.5 : 1)
      if l>=length
        return char_array[0..i].pack("U*")+(i<char_array.length-1 ? truncate_string : "")
      end
    end
    return text
  end

end
