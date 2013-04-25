#ActiveModel::Errors.class_eval do
#  def [](attribute)
#    attribute = attribute.to_sym
#    dotted_attribute = attribute.to_s.gsub("_", ".").to_sym
#    attribute_result = get(attribute)
#    dotted_attribute_result = get(dotted_attribute)
#    if attribute_result
#      attribute_result
#    elsif dotted_attribute_result
#      dotted_attribute_result
#    else
#      set(attribute, [])
#    end
#  end
#end