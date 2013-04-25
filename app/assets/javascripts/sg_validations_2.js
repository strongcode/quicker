Validate_Element = {
  status: "false",
   
  validate: function(element, type, min_length) {
    console.log(element);
    switch(type) {
      case "presence":
        if(element.length > 0) {
          if(element.val().length < min_length){
            return false;
          }
          else {
            return true;
          }
        }
        break;
      case "other":
        break;
    }
  }
}
