var list_val = new Array();
var com_elements = new Array();
var position = 0;

(function($){

  $.fn.extend({
    toggleIcons: function(add_class, remove_class) {

      Category_Toggles.check_icon_status(this, add_class, remove_class);
      
      this.click(function(){
        var status = $(this).is(':checked');
        if(status) {
          Category_Toggles.enable_category_loc_icons($(this).attr('id'));
        }

        Category_Toggles.check_icon_status(this, add_class, remove_class);
      });

    },

    update_class : function(add_class, remove_class) {
      this.attr('checked', 'checked');
    }
    
  });

})(jQuery);

Category_Toggles = {
  pin_index: -1,
  
  init: function() {

    $('#business').toggleIcons("business_active", "business_disable");
    $('#food').toggleIcons("food_active", "food_disable");
    $('#lifestyle').toggleIcons("lifestyle_active", "lifestyle_disable");
    $('#shopping').toggleIcons("shopping_active", "shopping_disable");
    $('#travel').toggleIcons("travel_active", "travel_disable");
    Category_Toggles.toggle_map_locations();
    
  },

  set_custom_buttons_visibility : function(page) {
    jQuery(document).ready(function(){
      Category_Toggles.check_buttons_visibility(page);
      $(".jQuerySgCategories, .jQueryLocToggle").click(function(){
        Category_Toggles.check_buttons_visibility(page);
      });
    });

  },

  check_buttons_visibility: function(page){
    var i = 0;
    var count = 0;
    Category_Toggles.bounds = Google_Map.map.getBounds();
    for(i = 0; i< Google_Map.markers.length; i++) {
      if(Category_Toggles.bounds.contains(Google_Map.markers[i].getPosition())) {
        if(Google_Map.markers[i].getVisible()) {
          count++;
        }
      }
    }
    for(i = 0; i< Google_Map.passionate_marker_arr.length; i++) {
      if(Category_Toggles.bounds.contains(Google_Map.passionate_marker_arr[i].getPosition())) {
        if(Google_Map.passionate_marker_arr[i].getVisible()) {
          count++;
        }
      }
    }
    if(count > 0) {
      if(page == 'location_list') {
        $('.jQuerySaveMyList').hide();
        $('.jQueryShare').css('display', 'block');
      }
      else {
        $('.jQuerySaveMyList').show();
        $('.jQueryShare').css('display', 'none');
      }
    }
    else {
      $('.jQuerySaveMyList').hide();
      $('.jQueryShare').css('display', 'none');
    }
  },

  update_categroy_icon_class: function() {
    $('#business').update_class("business_active", "business_disable");
    $('#food').update_class("food_active", "food_disable");
    $('#lifestyle').update_class("lifestyle_active", "lifestyle_disable");
    $('#shopping').update_class("shopping_active", "shopping_disable");
    $('#travel').update_class("travel_active", "travel_disable");
  //$('#friends').removeAttr('checked');
  //$('#friends').prev().removeClass('friends_active').addClass('friends_disable');

  },

  check_icon_status: function(element, add_class, remove_class) {
    var category = $(element).attr('id');

    var status = $(element).is(':checked');
    var _label = $('label.jQuery'+Category_Toggles.capitaliseFirstLetter(category));

    if(status){
      $(_label).find('img').attr('src','/assets/category-icons/'+category+'_minus.png');
    }
    else {
      $(_label).find('img').attr('src','/assets/category-icons/'+category+'_plus.png');
    }

    Category_Toggles.update_locations_status();

    var category_element = $('.jQuery-'+Category_Toggles.capitaliseFirstLetter(category) +'-locations');
    var inner_locs = $(category_element).find('.show_me');
    if($(inner_locs).length > 3) {
      $(category_element).css({
        'height' : '30%',
        'overflow' : 'auto'
      });
    }
    if($(inner_locs).length < 1) {
      $(category_element).css({
        'height' : '0%'
      });
    }

  },

  update_locations_status : function() {
    // list_val = $('.jQuerySelectFriends').find('select').val();
    //console.log(list_val);
    for(var i = 0; i < Google_Map.markers.length ; i++) {

      // console.log(typeof(Google_Map.markers[i].status));

      if($('#'+Google_Map.markers[i].category.toLowerCase()).is(':checked'))
      {
        if(Google_Map.markers[i].status == "true")
        {
          //position = jQuery.inArray(Google_Map.markers[i].user_id + '', list_val);

          //com_elements = Category_Toggles.get_common_elements(Google_Map.markers[i].reviewers_id, list_val);
          //if(position != -1 || com_elements > 0){
          //alert("show me");
          //console.log("My and My frirnd");
          //console.log(list_val);
          //console.log(Google_Map.markers[i].user_id);
          Google_Map.markers[i].setVisible(true);
          //$('#'+target_div).addClass('show_me').removeClass('hide_me');
          //$('#'+Google_Map.markers[i].location_id).addClass('show_me').removeClass('hide_me');
          $('#jQueryLocation-'+Google_Map.markers[i].location_id).addClass('show_me').removeClass('hide_me');
        //}/
        //else {
        //console.log(Google_Map.markers[i].user_id);
        //Google_Map.markers[i].setVisible(false);
        //$('#'+target_div).addClass('hide_me').removeClass('show_me');
        //$('#'+Google_Map.markers[i].location_id).addClass('hide_me').removeClass('show_me');
        // $('#jQueryLocation-'+Google_Map.markers[i].location_id).addClass('hide_me').removeClass('show_me');
        //}

        }
        else {
          Google_Map.markers[i].setVisible(false);
          $('#'+Google_Map.markers[i].location_id).addClass('hide_me').removeClass('show_me');
          $('#jQueryLocation-'+Google_Map.markers[i].location_id).addClass('hide_me').removeClass('show_me');
        }

      } 
      else {
        Google_Map.markers[i].setVisible(false);
        $('#'+Google_Map.markers[i].location_id).addClass('hide_me').removeClass('show_me');
        $('#jQueryLocation-'+Google_Map.markers[i].location_id).addClass('hide_me').removeClass('show_me');
      }
      
    }
  
  },

  enable_location_icon: function(category) {
    $('#'+category).attr('checked','checked');
    $('#'+category).prev().removeClass(category+'_disable').addClass(category+'_active');
    $('label.jQuery'+Category_Toggles.capitaliseFirstLetter(category)).find('img').attr('src', '/assets/category-icons/'+category+'_minus.png');
  },

  //get_common_elements: function(reviewers_id, list_val) {
  //  var common = $.grep(list_val, function(element) {
  //    return $.inArray(parseInt(element), reviewers_id) !== -1;
  //  });
  //  return common;
  //},

  capitaliseFirstLetter: function (string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
  },

  toggle_map_locations: function() {
    $('.jQueryLocToggle').click(function() {
      var id = $(this).attr('id').split('-')[1];
      Category_Toggles.find_location_pin(id);
      //console.log(index);
      if($(this).is(':checked')) {
        $('#img-'+id).attr('src', '/assets/sidekick/checked.png');
        Google_Map.markers[Category_Toggles.pin_index].setVisible(true);
      }
      else {
        Google_Map.markers[Category_Toggles.pin_index].setVisible(false);
        $('#img-'+id).attr('src', '/assets/sidekick/not_checked.png');
      }

    });
  },

  find_location_pin: function(id) {
    jQuery.each(Google_Map.markers, function(index, marker){
      //console.log(marker);
      if(marker.location_id == id) {
        Category_Toggles.pin_index = index;
        return;
      }
    });
  },

  enable_category_loc_icons: function(id) {
    var category = Category_Toggles.capitaliseFirstLetter(id);
    $('.jQuery-'+category+'-locations').find(':checkbox').attr('checked','checked');
    $('img.jQuery-sidebar-category-img').attr('src', '/assets/sidekick/checked.png');
  }


}



jQuery(document).ready(function($){
  Category_Toggles.init();
});

//jQuery('#friends').live('click', function(){
//Category_Toggles.check_icon_status(this, "friends_active", "friends_disable");
//if($(this).is(':checked')){
//  Google_Map.fit_bounds_status = "false";
//}
//else {
//  Google_Map.fit_bounds_status = "true";
//  Google_Map.clear_fit_bounds_map();
//  var center = Google_Map.map.getCenter();
//  Google_Map.map.panTo(center);
//  Google_Map.get_bounded_locations(center.lat(), center.lng(), '/sidekick/locations');
//
//}

//})
