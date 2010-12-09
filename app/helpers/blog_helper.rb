module BlogHelper
  def get_child_type(father = nil)
    type_list = APP_CONFIG["type"]
    types = []
    type_list.each{|type|
      types<<[t(type["value"]),type["code"]] if type["code"]!= 'o' if !father

      type["children"].each{|c_type|
        types<<[t(c_type["value"]),c_type["code"]]
      } if father and type["code"]==father
    }
    return types
  end

  def get_acion_name
    self.controller.action_name
  end
end
