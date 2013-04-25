var status;
function validate_file_extn(filename) {
  var image_extns = new Array(/^jpg$/i, /^png$/i, /^jpeg$/i, /^ico$/i, /^gif$/i)
  var extn = filename.split('.');
  for(var i = 0; i < image_extns.length; i++) {
    if(extn[1].match(image_extns[i])) {
      status = "true"
      break;
    }
    else {
      status = "false";
    }
  }
  return status;
}

function fancy_box_close() {
  $('body').removeClass('fancybox-lock');
  parent.jQuery.fancybox.close();
}

function fancy_box_close_inner() {
  $(document).on('click','.jQueryFancyboxClose',function(){
    $('body').removeClass('fancybox-lock').attr('style','');
    $(this).parents('.fancybox-overlay').first().hide();
  });
}

function fancy_box_iframe_close() {
  $(document).on('click','.jQueryFancyboxIframeClose',function(){
    $('body').removeClass('fancybox-lock');
    parent.jQuery.fancybox.close();
  });

}

  
function ajax_req_minor_category() {
  jQuery.ajax({
    data: 'location[sg_major_category]='+$('select#jQuerySelectMajorCategory option:selected').val(),
    url: '/minor-category',
    method: 'GET'
  });
}

function ajax_req_minor_category_suggestion() {
  jQuery.ajax({
    data: 'sg_major_category='+$('select#jQuerySelectMajorCategorySuggestion option:selected').val(),
    url: '/insider/suggestions/get_minor_category',
    method: 'GET'
  });
}

function readURL(input, element_id) {
  var status = validate_file_extn(input.files[0].name);
  if(status != 'false'){
    if (input.files && input.files[0]) {
      // console.log(input.files[0])
      if(input.files[0].size < 1400000) {
        var reader = new FileReader();
        reader.onload = function (e) {
          $('#'+element_id)
          .attr('src', e.target.result)
          .width(90)
          .height(90);
        };

        reader.readAsDataURL(input.files[0]);
      }
      else {
        alert("Maximum Size is 1400KB");
      }
    
    }
  }
  else {
    alert("File type is not supported");
  }
  
}

// Personalize Your Advisors Function

var img_string = '';

function build_image_string(advisor_class, advisor) {
  var gender = $(advisor_class).find('input:radio[name='+advisor+'[gender]]:checked').val();
  console.log(gender);
  var hair = $(advisor_class).find('#'+advisor+'_hair').val();
  var skin = $(advisor_class).find('#'+advisor+'_skin').val();
  img_string = advisor+'_'+gender+'_'+hair+'_'+skin;
  console.log(img_string);
  $(advisor_class).find('img').attr('src', '/assets/advisor_icons/'+advisor+'/'+img_string+'.png');
}

function dashboard_fr_section(form){
  var checkbox_count = 0;
  checkbox_count = $(form).find('input[type=checkbox]:checked').length;
  if(checkbox_count > 0 )  {
    $(form).find('input[type=submit]').removeAttr('disabled');
  }
  else {
    $(form).find('input[type=submit]').attr('disabled', 'disabled');
  }
}

// Document Ready Starts Here
jQuery(document).ready(function($) {

  // $('#jQuerysgPassionateForm').fileupload();

  $( "#datepicker" ).datepicker({
    minDate: 0,
    dateFormat: "yy-mm-dd"
  });

  $(".datetime_select").datepicker({
    dateFormat:'yy-mm-dd',
    minDate: 0,
    showAnim:'slide',
    showButtonPanel:false,
    onSelect: function (dateText, inst) {
      $($(this).next('input[type="hidden"]')[0]).attr('value', dateText);
    }
  });

  $("input[data-datetime-select='true']").each(function (index) {
    $(this).prev().datepicker('setDate', $(this).val());
  });

  fancy_box_close_inner();
  fancy_box_iframe_close();

  $(".offer-search").on('change','.major_categories',function(){
    $.ajax({
      url: "/update_minor_categories",
      data: {
        'major_category': $(this).val()
      }
    });

    
  });

  //  $('#profileImage').change(function(){
  //    var filename = $(this).val();
  //status = validate_file_extn(filename);
  //
  //    if(status == "true") {
  //      $('#jquery-photo-save').val(true);
  //      $(this).closest('form').submit();
  //    }
  //    else {
  //      alert(filename+" This file type is not supported. Please upload only images.")
  //      $(this).val(null);
  //    }
  //  });

  $('#sgPassionateImage').change(function(){
    //    var filename = $(this).val();
    //    status = validate_file_extn(filename);
    //    if(status == "true") {
    //      $('#sg-image-path').val(filename);
    //      alert(filename+" is added successfully");
    //    }
    //    else {
    //      alert(filename+" This file type is not supported. Please upload only images.")
    //      $('#sg-image-path').val(null);
    //      $(this).val(null);
    //    }
    });

  $('select#jQuerySelectMajorCategory').change(function(){
    ajax_req_minor_category();
  });
  
  $('select#jQuerySelectMajorCategorySuggestion').change(function(){
    ajax_req_minor_category_suggestion();
  });
  
  // Hide header and footer if page is inside an iframe
  var frame_element = window.frameElement;
  if(frame_element) {
    if(jQuery('div.navbar').length > 0){
      jQuery('div.navbar').hide();
    }
    if(jQuery('footer.footer').length > 0 ){
      jQuery('footer.footer').hide();
    }

    if(jQuery('.jQueryIframePopup').length > 0) {
      jQuery('.jQueryIframePopup').removeClass('container').addClass('popup-container-custom');
    }
  }

  // Before saving advance preference
  
  $('#jQueryAdvPreSave').click(function(){
    $('#adv_pref_save').val(1);
    $('#category_flag').val(1);
    return;
  });

  $('.jQueryAdvPrefCancel').click(function(event){
    event.preventDefault();
    jQuery.ajax({
      url: '/user_profile/reset',
      method: 'get'
    });
  });

  $('#jQuerysgPassionateForm').find('.cancelbtn').click(function(ev){
    //ev.preventDefault();
    fancy_box_close();
  });

  // Personalize Your Advisors

  $('.gender').click(function(){
    var advisor_class = $(this).closest('.advisor');
    var advisor = $(advisor_class).attr('data-advisor');
    build_image_string(advisor_class, advisor);
  });

  $('.hair').click(function(){
    var color = $(this).attr('id');
    var advisor_class = $(this).closest('.advisor');
    var advisor = $(advisor_class).attr('data-advisor');
    $(advisor_class).find('#'+advisor+'_hair').val(color);
    build_image_string(advisor_class, advisor);
  });

  $('.skin').click(function(){
    var color = $(this).attr('id');
    var advisor_class = $(this).closest('.advisor');
    var advisor = $(advisor_class).attr('data-advisor');
    $(advisor_class).find('#'+advisor+'_skin').val(color);
    build_image_string(advisor_class, advisor);
  });

  $('.jQueryAvatarBoxClose').click(function(){
    fancy_box_close();
    return;
  });

  //Dashboard Friend and Friend request Section

  dashboard_fr_section($('.jQueryFriendArchiveForm'));
  dashboard_fr_section($('.jQueryFriendReqArchiveForm'));

  $('.jQueryFriendsSelector').click(function(){
    if($(this).is(':checked')) {
      $(this).siblings('img').addClass('add-photo-border');
      dashboard_fr_section($(this).closest('form'));
    }
    else {
      $(this).siblings('img').removeClass('add-photo-border');
      dashboard_fr_section($(this).closest('form'));
    }

  });

  // Insider On hover show Ignore button

  jQuery('.jQueryIgnoreBtn').hover(function(){
    $(this).find('a').show();
  }, function(){
    $(this).find('a').hide();
  });

  if ($("[rel=tooltip]").length) {
    $("[rel=tooltip]").tooltip();
  }
  //Choose eiether new list name for existing list name - Sidekick
  var text_length = 0;
  $('.input-location-list-name').on('keyup', function(ev){
    text_length = $(this).val().length;
    if(text_length > 0) {
      $('.select-new-or-existing-ll').attr('disabled', 'disabled');
    }
    else {
      $('.select-new-or-existing-ll').removeAttr('disabled');
    }
  });

  $('select.select-new-or-existing-ll').on('change', function() {
    if($(this).val() == '') {
      $('.input-location-list-name').val('');
      $('.input-location-list-name').removeAttr('disabled');
    }
    else {
      $('.input-location-list-name').val('');
      $('.input-location-list-name').attr('disabled', 'disabled');
    }
  });


  $('.button-list-update').on('click', function(ev){
    ev.preventDefault();
    var id = $(this).attr('id');
    $('form#list_form_'+id).submit();
  })

  var text = $('input#location_list_name').val();
  var status = validate_presence(text);
  if(status) {
    $('.jQuery-sg-check-for-loc').removeAttr('disabled')
  }
  else {
    $('.jQuery-sg-check-for-loc').attr('disabled', 'disabled')
  }

  $('input#location_list_name').keyup(function(){
    text = $(this).val();
    status = validate_presence(text);
    if(status) {
      $('.jQuery-sg-check-for-loc').removeAttr('disabled')
    }
    else {
      $('.jQuery-sg-check-for-loc').attr('disabled', 'disabled')
    }
  });

  $('select.jQueryShowMy').change(function(){
    if($(this).val() == ''){
      window.location = '/sidekick';
      $('.jQueryShare').hide();
      return false;
    }
    Category_Toggles.update_categroy_icon_class();
    $(this).closest('form').submit();
  });

  // Prevent form submitting multiple times
  var form_id = '';
  $("form").submit(function() {
    form_id = $(this).attr('id');
    if(form_id != 'show_my_list_form') {
      $(this).submit(function() {
        return false;
      });
      return true;
    }
  });

  $('button.button-my-review-submit').click(function(e){
    e.preventDefault();
    $('#sidekick_drill_down_my_review_form').submit();
  });

});
// Document Ready Ends Here
//

$(document).on('click', '.jQueryArchive', function() {
  $(this).closest('form').attr('action',"/archive");
  return;
});
$(document).on('click', '.jQueryAccept', function(){
  $(this).closest('form').attr('action',"/accept");
  return;
});

function validate_presence(text) {
  if(/([^\s])/.test(text)) {
    return true //Text is present
  }
  else {
    return false //Blank
  }
}

function facebook_initialize(app_id) {
  FB.init({
    appId      : app_id, // App ID
    status     : true, // check login status
    cookie     : true, // enable cookies to allow the server to access the session
    xfbml      : true  // parse XFBML
  });
}

function facebook_send_message(element_id, full_name, profile_picture) {
  FB.ui(
  {
    method: 'send',
    to: element_id,
    name: 'Sign up for SnapGadget - Just like '+full_name+'!',
    link: 'http://www.snapgadget.com',
    picture: profile_picture,
    description: 'Join '+full_name+' on SnapGadget.'
  },
  function(response) {
    if (response) {
      alert('Post was published.');
    } else {
      alert('Post was not published.');
    }
  }
  );
}