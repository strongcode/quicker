module Sidekick::ReviewsHelper

  def link_to_add_fields(name, f, association, my_class = nil)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association,new_object,:child_index => "new_#{association}") do |builder|
      render :partial => association.to_s.singularize + "_fields", :locals => {:f => builder}
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", :class => my_class)
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", :class => 'link-to-remove btn btn-small')
  end

  def get_static_map(location, streetview = nil, height, width)
    if streetview
      image_tag "http://maps.googleapis.com/maps/api/streetview?size=#{height}x#{width}&location=#{location.latitude},#{location.longitude}&sensor=false", :id => "location-#{location.id}"
    else
      image_tag "http://maps.googleapis.com/maps/api/staticmap?center=#{location.latitude},#{location.longitude}&size=#{height}x#{width}&zoom=13&type=roadmap&sensor=false"
    end
  end

  def get_static_map_params(latitude, longitude, streetview = nil, height, width)
    if streetview
      image_tag "http://maps.googleapis.com/maps/api/streetview?size=#{height}x#{width}&location=#{latitude},#{longitude}&sensor=false", :id => "location-#{0}"
    else
      image_tag "http://maps.googleapis.com/maps/api/staticmap?center=#{latitude},#{longitude}&size=#{height}x#{width}&zoom=13&type=roadmap&sensor=false"
    end
  end

  def get_review_percentage(count, total_count)
    begin
      (100 * count)/total_count
    rescue
      0
    end
  end

  def location_image photo
    photo.present? && photo.image.present? ? (image_tag photo.image_url(:standard_image)) : ('')
  end
end



