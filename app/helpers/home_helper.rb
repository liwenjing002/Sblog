module HomeHelper


  #获得博客筛选列，最新最热门之类的
  def get_main_tabs
    wap_list = APP_CONFIG["wap"]
    li_list = []
    wap_list.each{|way|
      class_value = (way["value"]==params[:way])? "active":""
      class_value = "active" if params[:way]==nil and way["value"]=="recent"

      li_list<<content_tag("li", link_to_remote("<span>#{t(way['value'])}</span>",\
            :update => "main-area",\
            :url=>{ :controller => "home",:way=>way["value"],:tag=>params[:tag]})+\
          "<span class='arrow'></span>",:id=>"main_tab#{way["value"]}",:class=>"#{class_value}")
    }
    content_tag("ul", li_list,\
        "id" =>  "main-tabbed-area", "class" =>  "clearfix" )

  end


  def get_type_name(code)
    type_list = APP_CONFIG["type"]
    type_list.each{|type|
      return t(type["value"]) if type["code"]==code
      if type["children"]
        type["children"].each{|type|
          return t(type["value"]) if type["code"]==code
        }
      end
    }
  end
end
