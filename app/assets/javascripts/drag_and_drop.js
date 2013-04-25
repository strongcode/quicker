function allowDrop(ev)
{
  ev.preventDefault();
}

function drag(ev)
{
  ev.dataTransfer.setData("Text",ev.target.id);
}

function drop(ev)
{
  ev.preventDefault();
  var data=ev.dataTransfer.getData("Text");
  var data_obj = document.getElementById(data);
  if(ev.target.nodeName == 'IMG') {
    jQuery(ev.target).closest('div').html(data_obj);
  }
  else {
    jQuery(ev.target).html(data_obj);
  }
}


 
