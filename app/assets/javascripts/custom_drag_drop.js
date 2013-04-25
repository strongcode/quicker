function category_drag(ev)
{
  ev.dataTransfer.effectAllowed = "copy";
  ev.dataTransfer.setData("Text", jQuery(ev.target).closest('div').attr('id'));
}


function drag_calender(ev)
{
  ev.dataTransfer.setData("Text",ev.target.id + "-" + jQuery(ev.target).closest('div#jQueryAdvPreferenceBoards').attr('id'));
}

function drop_calender(ev) {
  ev.preventDefault();

  var data = ev.dataTransfer.getData("Text");
  var new_data = data.split('-')[0]
  var src = data.split('-')[1]
  //console.log(data);
  //console.log(src);
  
  var data_obj = document.getElementById(new_data);
  
  if(ev.target.nodeName != 'IMG' && src != jQuery(ev.target).closest('#jQueryAdvPreferenceBoards').attr('id')) {
    $(data_obj).removeAttr('data-allow-drop');
    jQuery(ev.target).html(data_obj);

    var first_image = $('div#div1').find('img');
    var second_image = $('div#div2').find('img');
    var third_image = $('#div3').find('img');

    //console.log($(first_image).attr('id'))  ;
    //console.log($(second_image).attr('id'));
    //console.log($(third_image).attr('id'));

    if($(first_image).is('img')) {
      $('input#offer_order_1').val($(first_image).attr('id'));
    }
    else {
      $('input#offer_order_1').val('');
    }

    if($(second_image).is('img')) {
      $('input#offer_order_2').val($(second_image).attr('id'));
    }
    else {
      $('input#offer_order_2').val('');
    }

    if($(third_image).is('img')) {
      $('input#offer_order_3').val($(third_image).attr('id'));
    }
    else {
      $('input#offer_order_3').val('');
    }
  }
}

function drop_normal(ev) {
  drop(ev);
}

function drop_swap(ev) {
  ev.preventDefault();
  
  var data = ev.dataTransfer.getData("Text");
  var data_obj = jQuery('div#'+data).find('img');
  
  var images = $(ev.target).closest('div.jQueryProfileCategories').find('img');
  var image_ids = new Array();
  images.each(function(){
    image_ids.push($(this).attr('data-category-id'));
  });

  if(jQuery.inArray($(data_obj).attr('data-category-id'), image_ids) == -1) {
    var new_image = $(document.createElement('img'));
    $(new_image).attr('src', $(data_obj).attr('src'));
    $(new_image).attr('title', $(data_obj).attr('title'));
    $(new_image).attr('class', $(data_obj).attr('class'));
    $(new_image).attr('data-category-id', $(data_obj).attr('data-category-id'));
    $(new_image).attr('ondragstart', $(data_obj).attr('ondragstart'));
    $(new_image).attr('draggable', $(data_obj).attr('draggable'));

    if(ev.target.nodeName == 'IMG') {
      jQuery(ev.target).closest('div').html(new_image);
    }
    else {
      jQuery(ev.target).html(new_image);
    }
  }

}


  

function recycle_bin(ev) {
  ev.preventDefault();
  var data = ev.dataTransfer.getData("Text");

  var parent_element = jQuery('div#'+data);
  var data_attribute = parent_element[0].getAttribute("data-default-img");
  var data_obj = $(parent_element).find('img');
  console.log(data_obj);
  var dustbin_drop = data_obj[0].getAttribute('data-dustbin-drop')
  if (dustbin_drop != 'false') {
    $(data_obj).attr('src','/assets/d'+data_attribute+'.png');
    $(data_obj).removeAttr('ondragstart', '').removeAttr('draggable', 'false').removeAttr('data-category-id');
  }
  

}