jQuery(document).ready(function ($) {

  $(".fancybox").fancybox(
  {
    'hideOnContentClick':false,
    'padding':15,
    'scrolling': 'auto',
    'centerOnScroll':true,
    'transitionIn':'fade',
    'transitionOut':'fade',
    'speedIn':500,
    'speedOut':500,
    'autoDimensions':false,
    'overlayShow':true,
    'autoSize':true,
    'width':$(document).width()
  });

  $(".fancybox_large").fancybox(
  {
    'hideOnContentClick':false,
    'padding':15,
    'scrolling': 'auto',
    'centerOnScroll':true,
    'transitionIn':'fade',
    'transitionOut':'fade',
    'speedIn':500,
    'speedOut':500,
    'autoDimensions':false,
    'overlayShow':true,
    'autoScale': false,
    'autoSize':false,
    'width': 900,
    'height': $(window).height() - 100,
    afterClose: function() {
      var loc = new String(location);
      if(loc.match(/insider/ig)) {
        location.reload();
      }
    }
  });

  $(".fancybox_iframe").fancybox({
    'type':'iframe',
    'autoDimensions':false,
    'autoScale':false,
    'autoSize':false,
    'width': 880,
    'height': $(window).height() - 69,
    afterClose:function () {
      var loc = new String(location);
      if(loc.match(/sidekick/ig)) {
        location =  '/sidekick?iframe=1';
      }
      else {
        location.reload();
      }
    }
  });

  $(".fancybox_iframe_large").fancybox({
    'type':'iframe',
    'autoDimensions':false,
    'autoScale':false,
    'autoSize':false,
    'width': 880,
    'height': $(window).height() - 69,
    'margin': 5,
    'closeClick' : true

  });

  $(".fancybox_iframe_suggestion").fancybox({
    'type':'iframe',
    'autoDimensions':false,
    'autoScale':false,
    'autoSize':false,
    'width': 880,
    'height': $(window).height() - 100,
    'margin': 5,
    'closeClick' : true

  });

  $(".fancybox_loc_iframe").fancybox({
    'type':'iframe',
    'hideOnContentClick':false,
    'padding':15,
    'scrolling': 'auto',
    'centerOnScroll':true,
    'transitionIn':'fade',
    'transitionOut':'fade',
    'speedIn':500,
    'speedOut':500,
    'autoDimensions':false,
    'overlayShow':true,
    'autoSize':true

  });

  $(".fancybox_sidekick_guide").fancybox({
    'width':300,
    'height': screen.height - 300,
    'autoScale':'false',
    afterClose:function () {
      jQuery('#jQueryGuideForm').submit()
    }
  });

  $(".fancybox_mini").fancybox({
    'autoDimensions':false,
    'autoScale':false,
    'autoSize':false,
    'width': 400,
    'height': 400,
    'margin': 15
  });

  $(".sg_post_link_facebook").fancybox({
    'type':'iframe',
    'padding':15,
    'autoDimensions':false,
    'autoSize':false,
    'width': 550,
    'height': 390
  });

  $(".fancybox_iframe_category").fancybox({
    'type':'iframe',
    'autoDimensions':false,
    'autoScale':false,
    'autoSize':false,
    'width': 900,
    'height': $(window).height() - 69,
    'margin': 5,
    'closeClick' : true

  });
  
});