         $(document).ready(function(){

  $('a.delete').on('click',function(e){
    e.preventDefault();
    imageID = $(this).closest('.image')[0].id;
    alert('Now deleting "'+imageID+'"');
    $(this).closest('.image')
      .fadeTo(300,0,function(){
        $(this)
          .animate({width:0},200,function(){
            $(this)
              .remove();
          });
      });
  });

});