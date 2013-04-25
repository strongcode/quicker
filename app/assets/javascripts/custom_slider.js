jQuery(function(){
  // Slider
  $('#slider1').slider({
    range: "min",
    min: 0,
    max: 100,
    slide: function(event, ui ) {
      $( "#user_slider_1" ).val( ui.value );
    }
  });
  
  //slider2
  $('#slider2').slider({
    range: "min",
    value: 0,
    min: 0,
    max: 100,
    slide: function(event, ui ) {
      $( "#user_slider_2" ).val( ui.value );
    }
  });
  //slider3
  $('#slider3').slider({
    range: "min",
    value: 0,
    min: 0,
    max: 100,
    slide: function(event, ui ) {
      $( "#user_slider_3" ).val( ui.value );
    }
  });
  
  $('#slider4').slider({
    range: "min",
    value: 0,
    min: 0,
    max: 100,
    slide: function(event, ui ) {
      $( "#user_profile_question_3" ).val( ui.value );
    }
  });
  
  $('#slider5').slider({
    range: "min",
    value: 0,
    min: 0,
    max: 100,
    slide: function(event, ui ) {
      $( "#user_profile_question_4" ).val( ui.value );
    }
  });
  
  $('#slider6').slider({
    range: "min",
    value: 0,
    min: 0,
    max: 100,
    slide: function(event, ui ) {
      $( "#user_profile_question_5" ).val( ui.value );
    }
  });
});
