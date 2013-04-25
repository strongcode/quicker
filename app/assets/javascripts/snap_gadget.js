var DATA_TYPE;

jQuery(document).ready(function ($) {
  $('.jQueryWindowHeight').css('min-height', screen.height - 200);

  // Loading Facebox
  $('a[rel*=facebox]').facebox();

  if ($('.sgAlert, .sgNotice').length > 0) {

    $('.wFull').css({
      'margin-top':'45px'
    });

  }

  $('#sgInsider').click(function (e) {
    e.preventDefault();
    var dat = $(this).attr('data-sgpage');
    var cls = $(this).attr('class');
    var data_val = $(this).attr('data-pid')
    if (cls == 'preferences_icon ' + dat + '_disabled') {
      $(this).attr('class', 'preferences_icon ' + dat + '_normal')
      console.log(data_val);
      $('input#user_preference_landing_page_id').val(data_val);
      $('#sgAssistant').attr('class', 'preferences_icon assistant_disabled')
      $('#sgSidekick').attr('class', 'preferences_icon sidekick_disabled')
    }

    else {
      $(this).attr('class', 'preferences_icon ' + dat + '_disabled')
      $('input#user_preference_landing_page_id').val(null);
    }
  });

  $('#sgAssistant').click(function (e) {
    e.preventDefault();
    var dat = $(this).attr('data-sgpage');
    var cls = $(this).attr('class');
    var data_val = $(this).attr('data-pid')
    if (cls == 'preferences_icon ' + dat + '_disabled') {
      $(this).attr('class', 'preferences_icon ' + dat + '_normal')
      $('input#user_preference_landing_page_id').val(data_val);
      $('#sgInsider').attr('class', 'preferences_icon insider_disabled')
      $('#sgSidekick').attr('class', 'preferences_icon sidekick_disabled')
    }

    else {
      $(this).attr('class', 'preferences_icon ' + dat + '_disabled')
      $('input#user_preference_landing_page_id').val(null);
    }
  });


  $('#sgSidekick').click(function (e) {
    e.preventDefault();
    var dat = $(this).attr('data-sgpage');
    var cls = $(this).attr('class');
    var data_val = $(this).attr('data-pid')
    if (cls == 'preferences_icon ' + dat + '_disabled') {
      $(this).attr('class', 'preferences_icon ' + dat + '_normal')
      console.log(data_val);
      $('input#user_preference_landing_page_id').val(data_val);
      $('#sgAssistant').attr('class', 'preferences_icon assistant_disabled')
      $('#sgInsider').attr('class', 'preferences_icon insider_disabled')
    }

    else {
      $(this).attr('class', 'preferences_icon ' + dat + '_disabled')
      $('input#user_preference_landing_page_id').val(null);
    }
  });

  $('.jQueryChange').click(function (event) {
    event.preventDefault();
    DATA_TYPE = $(this).attr('data-type');
    console.log(DATA_TYPE);
    return;
  });

  if ($('div.wFull').find('#jQueryFlashNotice').length > 0 || $('div.wFull').find('#jQueryAlertNotice').length > 0) {
    $('div.wFull').css('margin-top', '45px');
  }
  else {
    $('div.wFull').css('margin-top', '0px');
  }

  var photo_element = $('.add-photos-path:first').find('.image-label');
  if(photo_element.length > 0) {
    $(photo_element).html('Images');
  }

}); //Document ready function ends here.



jQuery('label.sgClose').live('click', function () {
  jQuery(this).parent('div').remove();
  $('div.wFull').css('margin-top', '0px');
})

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
  var upload_label = $('label.upload_image');
  if($(upload_label).length > 0) {
    $(upload_label).text('browse');
  }
  image_label_render();
}

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest("div.add-photos-path").hide();
  image_label_render();
}

function image_label_render() {
  var photo_row = $('.add-photos-path:visible:first');
  if(photo_row.length > 0) {
    $('.add-photos-path:visible:first').find('.image-label').html('Images');
    $('.jQueryImgUp').prev('div').html('');
  }
  else {
    $('.jQueryImgUp').prev('div').html('Images');
  }
}
