$(document).ready(function(){
  $(".links_container").on('click','.help_links',function(){
    $('.help_links').removeClass('redLink');
    $(this).addClass('redLink');
    var req_detail = $(this).attr('id');
    $(".advantages").hide();
    $(".adv_image").hide();
    $("."+req_detail+"_details").show();
  });

  $(".account_container").on('click','.help_links',function(){
    $('.help_links').removeClass('redLink');
    $(this).addClass('redLink');
    var req_detail = $(this).attr('id');
    $(".advantages").hide();
    $("."+req_detail+"_details").show();
  });
   
});