module BlogHelper
  def get_child_type
     type_list = APP_CONFIG["type"]
     types = []
      type_list.each{|type|
        types<<[t(type["value"]),type["code"]] if type["code"]!= 'o'
      }
      return types
  end
end
