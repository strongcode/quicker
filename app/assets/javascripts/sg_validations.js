
var place_holder_img_1 = "/assets/place_holder_1.png"
var place_holder_img_2 = "/assets/place_holder_2.png"
var place_holder_img_3 = "/assets/place_holder_3.png"

var place_holder_1 = "<img src="+place_holder_img_1+ " "+"style='max-width:85px;max-height='85px'>";
var place_holder_2 = "<img src="+place_holder_img_2+ " "+"style='max-width:85px;max-height='85px'>";
var place_holder_3 = "<img src="+place_holder_img_3+ " "+"style='max-width:85px;max-height='85px'>";

var PROFILE_STATUS;
//Fancybox close


$(document).on('click', '.sgImageApply', function(e){
  console.log(DATA_TYPE)
  if(DATA_TYPE == 'category') {
    var first_image = $('div#sgCategoryFirst').html();
    var second_image = $('div#sgCategorySecond').html();
    var third_image = $('div#sgCategoryThird').html();
    
    $('input#user_preference_offer_category_1').val(jQuery(first_image).attr('id'))
    $('#jQuerysgCategoryBox1').html(first_image);
    $('.jQueryCategoryImages').find('.jQueryBox1 > img').attr('src', $(first_image).attr('src'));
    $('.jQueryCategoryImages').find('.jQueryBox1').find('div.progress').show();
      
    $('input#user_preference_offer_category_2').val(jQuery(second_image).attr('id'))
    $('#jQuerysgCategoryBox2').html(second_image);
    $('.jQueryCategoryImages').find('.jQueryBox2 > img').attr('src', $(second_image).attr('src'));
    $('.jQueryCategoryImages').find('.jQueryBox2').find('div.progress').show();
      
    $('input#user_preference_offer_category_3').val(jQuery(third_image).attr('id'))
    $('#jQuerysgCategoryBox3').html(third_image);
    $('.jQueryCategoryImages').find('.jQueryBox3 > img').attr('src', $(third_image).attr('src'));
    $('.jQueryCategoryImages').find('.jQueryBox3').find('div.progress').show();
      
  }

  
  else if(DATA_TYPE == 'suggestion') {
    var first_image = $('div#sgCategoryFirst').html();
    var second_image = $('div#sgCategorySecond').html();
    var third_image = $('div#sgCategoryThird').html();

    $('#jQuerysgSuggestionBox1').html(first_image);
    $('input#user_preference_suggestion_category_1').val(jQuery(first_image).attr('id'))
      
    $('#jQuerysgSuggestionBox2').html(second_image);
    $('input#user_preference_suggestion_category_2').val(jQuery(second_image).attr('id'))


    $('#jQuerysgSuggestionBox3').html(third_image);
    $('input#user_preference_suggestion_category_3').val(jQuery(third_image).attr('id'))
  }

  else if(DATA_TYPE == 'deserve_it') {
    var first_image = $('div#sgCategoryFirst').html();
    $('input#user_preference_you_deserve_it_category').val(jQuery(first_image).attr('id'))
    $('#jQuerysgUDeserveItBox1').html(first_image);
  }
  
});


var status;
var SNAP_GADGET_STATUS = "true";

$('input#login').live('click',function(event){
  if (SNAP_GADGET_STATUS == "true") {
    status = "true";
    status = LoginValidate();
    console.log(status);
    if(status == "false"){
      event.preventDefault();
      return false;
    }
    else {
      return true;
    }
  }
});

$('input#savechagedpassword').live('click',function(event){
  if (SNAP_GADGET_STATUS == "true") {
    status = "true";
    status = PasswordValidate();
    console.log(status);
    if(status == "false"){
      event.preventDefault();
      return false;
    }
    else {
      $('#ChangePasswordConfirmError').show().delay(900000000000000);
      $('#ChangePasswordConfirmError').html('Password changed successfully.');
      return true;
    }
  }
});

$('input#changedpw').live('click',function(event){
  if (SNAP_GADGET_STATUS == "true") {
    status = "true";
    status = ConfirmpasswordValidate();
    console.log(status);
    if(status == "false"){
      event.preventDefault();
      return false;
    }
    else {
      return true;
    }
  }
});
$('input#reset').live('click',function(event){

  if (SNAP_GADGET_STATUS == "true") {
    status = "true";
    status = forgotpwvalidate();
    console.log(status);
    if(status == "false"){
      event.preventDefault();
      return false;
    }
    else {
      return true;
    }
  }
});
$('input#locationsave').live('click',function(event){

  if (SNAP_GADGET_STATUS == "true") {
    status = "true";
    status = locationvalidate();
    console.log(status);
    if(status == "false"){
      event.preventDefault();
      return false;
    }
    else {
      return true;
    }
  }
});
//$('input#passionatesave').live('click',function(event){
//
//  if (SNAP_GADGET_STATUS == "true") {
//    status = "true";
//    status = passionatevalidate();
//    console.log(status);
//    if(status == "false"){
//      event.preventDefault();
//      return false;
//    }
//    else {
//      return;
//    }
//  }
//});
$('input#invite_frnd').live('click',function(event){

  if (SNAP_GADGET_STATUS == "true") {
    status = "true";
    status = friendsvalidate();
    console.log(status);
    if(status == "false"){
      event.preventDefault();
      return false;
    }
    else {
      return true;
    }
  }
});
$('input#share_btn').live('click',function(event){

  if (SNAP_GADGET_STATUS == "true") {
    status = "true";
    status = Commentvalidate();
    console.log(status);
    if(status == "false"){
      event.preventDefault();
      return false;
    }
    else {
      return true;
    }
  }
});

$('input#location_share_btn').live('click',function(event){

  if (SNAP_GADGET_STATUS == "true") {
    status = "true";
    status = Commentvalidate();
    console.log(status);
    if(status == "false"){
      event.preventDefault();
      return false;
    }
    else {
      return true;
    }
  }
});
$('input#contact_send').live('click',function(event){

  if (SNAP_GADGET_STATUS == "true") {
    status = "true";
    status = contact_validate();
    console.log(status);
    if(status == "false"){
      event.preventDefault();
      return false;
    }
    else {
      $('#MessageError').show();
      $('#MessageError').html('Mail sent successfully to snapgadget team');
      return true;
    }
  }
});
$('input#advertise_send').live('click',function(event){

  if (SNAP_GADGET_STATUS == "true") {
    status = "true";
    status = advertise_validate();
    console.log(status);
    if(status == "false"){
      event.preventDefault();
      return false;
    }
    else {
      $('#MessageError').show();
      $('#MessageError').html('Mail sent successfully to snapgadget team');
      return true;
        
    }
  }
});
function advertise_validate()
{
  var Email = $("#advertise_email").val();
  var FirstName = $("#advertise_first_name").val();
  var LastName = $("#advertise_last_name").val();
  var Message = $("#advertise_message").val();
  var email_status = validateEmail(Email);
  var Firstname_status = validateUsername(FirstName);
  var Latstname_status = validateUsername(LastName);
  var Firstname_status2 = validateUsernames(FirstName);
  var Latstname_status2 = validateUsernames(LastName);

  if(Email == '') {
    $('#EmailError').show();
    $('#EmailError').html('Please enter Email Id.');
    status = "false";
  }

  else if(email_status == "false") {
    $('#EmailError').show();
    $('#EmailError').html('Please enter valid Email.');
    status = "false";
  }
  else {
    $('#EmailError').hide();
  }
  if(Message == '') {
    $('#MessageError').show();
    $('#MessageError').html('Message is required.');
    status = "false";
  }
  else {
    $('#MessageError').hide();
  }

  if(FirstName == '')
  {
    $('#FnameError').show();
    $('#FnameError').html("First Name is required. ")
    status = "false";

  }
  else if(FirstName.length < 2)
  {
    $('#FnameError').show();
    $('#FnameError').html("First Name should have atleast two characters. ")
    status = "false";

  }
  else if(FirstName != '' && Firstname_status =='false' )
  {
    $('#FnameError').show();
    $('#FnameError').html("First Name doesnot accept only special characters or numbers.")
    status = "false";

  }
  else if(FirstName != '' && Firstname_status2 =='false' )
  {
    $('#FnameError').show();
    $('#FnameError').html("First Name doesnot accept more than three consecutive characters.")
    status = "false";

  }
  else
  {
    $('#FnameError').hide();
  }
  if(LastName == '')
  {
    $('#LnameError').show();
    $('#LnameError').html("Last Name is required. ")
    status = "false";

  }
  else if(LastName.length < 2)
  {
    $('#LnameError').show();
    $('#LnameError').html("Last Name should have atleast two characters. ")
    status = "false";

  }
  else if(FirstName != '' && LastName != '' && FirstName == LastName )
  {
    $('#LnameError').show();
    $('#LnameError').html("First name and Last name could not be same.")
    status = "false";
  }
  else if(LastName != '' && Latstname_status =='false' )
  {
    $('#LnameError').show();
    $('#LnameError').html("Last Name doesnot accept only special characters or numbers.")
    status = "false";

  }
  else if(LastName != '' && Latstname_status2 =='false' )
  {
    $('#LnameError').show();
    $('#LnameError').html("Last Name doesnot accept more than three consecutive characters.")
    status = "false";

  }
  else
  {
    $('#LnameError').hide();
  }

  return status;
}

function contact_validate()
{
  var Email = $("#contact_email").val();
  var FirstName = $("#contact_first_name").val();
  var LastName = $("#contact_last_name").val();
  var Message = $("#contact_message").val();
  var email_status = validateEmail(Email);
  var Firstname_status = validateUsername(FirstName);
  var Latstname_status = validateUsername(LastName);
  var Firstname_status2 = validateUsernames(FirstName);
  var Latstname_status2 = validateUsernames(LastName);

  if(Email == '') {
    $('#EmailError').show();
    $('#EmailError').html('Please enter Email Id.');
    status = "false";
  }

  else if(email_status == "false") {
    $('#EmailError').show();
    $('#EmailError').html('Please enter valid Email.');
    status = "false";
  }
  else {
    $('#EmailError').hide();
  }
  if(Message == '') {
    $('#MessageError').show();
    $('#MessageError').html('Message is required.');
    status = "false";
  }
  else {
    $('#MessageError').hide();
  }

  if(FirstName == '')
  {
    $('#FnameError').show();
    $('#FnameError').html("First Name is required. ")
    status = "false";

  }
  else if(FirstName.length < 2)
  {
    $('#FnameError').show();
    $('#FnameError').html("First Name should have atleast two characters. ")
    status = "false";

  }
  else if(FirstName != '' && Firstname_status =='false' )
  {
    $('#FnameError').show();
    $('#FnameError').html("First Name doesnot accept only special characters or numbers.")
    status = "false";

  }
  else if(FirstName != '' && Firstname_status2 =='false' )
  {
    $('#FnameError').show();
    $('#FnameError').html("First Name doesnot accept more than three consecutive characters.")
    status = "false";

  }
  else
  {
    $('#FnameError').hide();
  }
  if(LastName == '')
  {
    $('#LnameError').show();
    $('#LnameError').html("Last Name is required. ")
    status = "false";

  }
  else if(LastName.length < 2)
  {
    $('#LnameError').show();
    $('#LnameError').html("Last Name should have atleast two characters. ")
    status = "false";

  }
  else if(FirstName != '' && LastName != '' && FirstName == LastName )
  {
    $('#LnameError').show();
    $('#LnameError').html("First name and Last name could not be same.")
    status = "false";
  }
  else if(LastName != '' && Latstname_status =='false' )
  {
    $('#LnameError').show();
    $('#LnameError').html("Last Name doesnot accept only special characters or numbers.")
    status = "false";

  }
  else if(LastName != '' && Latstname_status2 =='false' )
  {
    $('#LnameError').show();
    $('#LnameError').html("Last Name doesnot accept more than three consecutive characters.")
    status = "false";

  }
  else
  {
    $('#LnameError').hide();
  }

  return status;
}

function locationvalidate()
{
  var list_name = $("#location_list_name").val();
  //var location_name1=$("#geocode_autocomplete_1").val();
  //var location_name2=$("#geocode_autocomplete_2").val();
  //var location_name3=$("#geocode_autocomplete_3").val();
  if(list_name == '')
  {
    $('#LocationError').show();
    $('#LocationError').html("Location list can't be blank.");
    status = "false";
  }
  else {
    $('#LocationError').hide();
  }
  //  if(location_name1 == '' && location_name2 == '' && location_name3 == '')
  //  {
  //    $('#LocationnameError').show();
  //    $('#LocationnameError').html("Atleast add one locations to continue.");
  //    status = "false";
  //  }
  //  else {
  //    $('#LocationnameError').hide();
  //  }
  return status;
}
function Commentvalidate()
{
  var share_comment = $("#share_comment").val();

  if(share_comment == '')
  {
    $('#share_commentError').show();
    $('#share_commentError').html("Comment can't be blank.");
    status = "false";
  }
  else {
    $('#share_commentError').hide();
  }
  return status;
}
function passionatevalidate()
{
  var passionate_name = $("#passionate_name").val();
 
  if(passionate_name == '')
  {
    $('#passionate_nameError').show();
    $('#passionate_nameError').html("Passionate name can't be blank.");
    status = "false";
  }
  else {
    $('#passionate_nameError').hide();
  }
  return status;
}
function friendsvalidate()
{

  var friends_search = $("#friends-search").val();

  if(friends_search == '')
  {
    $('#friends_searchError').show();
    $('#friends_searchError').html("Friend name can't be blank.");
    status = "false";
  }
  else {
    $('#friends_searchError').hide();
  }
  return status;
}
function forgotpwvalidate()
{
  var Email = $("#user_email").val();
  if(Email == '') {
    $('#EmailError').show();
    $('#EmailError').html("Email can't be blank.");
    status = "false";
  }
  else {
    $('#EmailError').hide();
  }
  return status;
}
function ConfirmpasswordValidate()
{
  var newpassword = $("#user_password").val();
  var newconfirmpassword = $("#user_password_confirmation").val();
    
  if (newpassword == '')
  {
    $('#NewPasswordError').show();
    $('#NewPasswordError').html('Please enter password.');
    status = "false";
  }
  else if(newpassword != '' && newpassword.length < 6)
  {
    $('#NewPasswordError').show();
    $('#NewPasswordError').html('Password is too short.');
    status = "false";
  }
  else
  {
    $('#NewPasswordError').hide();
  }
  if(newconfirmpassword == '')
  {
    $('#NewConfirmPasswordError').show();
    $('#NewConfirmPasswordError').html('Please enter new password.');
    status = "false";
  }
  else if(newpassword != '' &&  newconfirmpassword != ''  &&  newpassword != newconfirmpassword)
  {
    $('#NewConfirmPasswordError').show();
    $('#NewConfirmPasswordError').html('Re-enter password new and confirm new are not same.');
    status = "false";
  }
  else if(newpassword != ''&& newpassword.length < 6)
  {
    $('#NewConfirmPasswordError').show();
    $('#NewConfirmPasswordError').html('Password is too short.');
    status = "false";
  }
  else
  {
    $('#NewConfirmPasswordError').hide();
  }
  

  return status;

}
function SignUpValidate()
{
  status = "true";
  var Email = $("#user_email").val();
  var Password = $("#user_password").val();
  var FirstName = $("#user_first_name").val();
  var chk = $("#Terms").val();
  var LastName = $("#user_last_name").val();
  var Location = $("#jQueryCityAutocomplete");
  var pioneer_code = $('#user_pioneer_code').val();
  var email_status = validateEmail(Email);
  var Firstname_status = validateUsername(FirstName);
  var Latstname_status = validateUsername(LastName);
  var Firstname_status2 = validateUsernames(FirstName);
  var Latstname_status2 = validateUsernames(LastName);
  var Location_Status = Validate_Element.validate(Location, "presence", 2);
  
  if(pioneer_code == '') {
    $('#PioneerCodeError').show();
    $('#PioneerCodeError').html('Please enter Pioneer Code to register.');
    status = "false";
  }
  else {
    $('#PioneerCodeError').val('').hide();
  }

  if(Location_Status) {
    $('#LocationError').hide();
  }
  else {
    $('#LocationError').html('Please enter a location and continue.');
    $('#LocationError').show();
    status = "false";
  }
  
  if(Email == '') {
    $('#EmailError').show();
    $('#EmailError').html('Please enter Email Id to register.');
    status = "false";
  }

  else if(email_status == "false") {
    $('#EmailError').show();
    $('#EmailError').html('Please enter valid Email to register.');
    status = "false";
  }
  else {
    $('#EmailError').hide();
  }
  if(chk == '') {
    $('#chkError').show();
    $('#chkError').html('Please check it.');
    status = "false";
  }

  else {
    $('#chkError').hide();
  }

  if (Password == ''){
    $('#PasswordError').show();
    $('#PasswordError').html('Please enter Password to register.');
    status = "false";
  }
  else if(Password.length < 6 )
  {
    $('#PasswordError').show();
    $('#PasswordError').html('Password is too short.');
    status = "false";
  }
  else {
    $('#PasswordError').hide();
  }

  if(FirstName == '')
  {
    $('#FnameError').show();
    $('#FnameError').html("First Name is required. ")
    status = "false";

  }
  else if(FirstName.length < 2)
  {
    $('#FnameError').show();
    $('#FnameError').html("First Name should have atleast two characters. ")
    status = "false";

  }
  else if(FirstName != '' && Firstname_status =='false' )
  {
    $('#FnameError').show();
    $('#FnameError').html("First Name doesnot accept only special characters or numbers.")
    status = "false";

  }
  else if(FirstName != '' && Firstname_status2 =='false' )
  {
    $('#FnameError').show();
    $('#FnameError').html("First Name doesnot accept more than three consecutive characters.")
    status = "false";

  }
  else
  {
    $('#FnameError').hide();
  }
  if(LastName == '')
  {
    $('#LnameError').show();
    $('#LnameError').html("Last Name is required. ")
    status = "false";

  }
  else if(LastName.length < 2)
  {
    $('#LnameError').show();
    $('#LnameError').html("Last Name should have atleast two characters. ")
    status = "false";

  }
  else if(FirstName != '' && LastName != '' && FirstName == LastName )
  {
    $('#LnameError').show();
    $('#LnameError').html("First name and Last name could not be same.")
    status = "false";
  }
  else if(LastName != '' && Latstname_status =='false' )
  {
    $('#LnameError').show();
    $('#LnameError').html("Last Name doesnot accept only special characters or numbers.")
    status = "false";

  }
  else if(LastName != '' && Latstname_status2 =='false' )
  {
    $('#LnameError').show();
    $('#LnameError').html("Last Name doesnot accept more than three consecutive characters.")
    status = "false";

  }
  else
  {
    $('#LnameError').hide();
  }

  return status;
}


function LoginValidate(){
  var Email = $("#user_email").val();
  var Password = $("#user_password").val();
  var email_status = validateEmail(Email);

  if(Email == '') {
    $('#LoginEmailError').show();
    $('#LoginEmailError').html('Please enter Email.');
    status = "false";
  }

  else if(email_status == "false") {
    $('#LoginEmailError').show();
    $('#LoginEmailError').html('Please enter valid Email.');
    status = "false";
  }
  else {
    $('#LoginEmailError').hide();
  }

  if (Password == ''){
    $('#LoginPasswordError').show();
    $('#LoginPasswordError').html('Please enter Password.');
    status = "false";
  }
    
  else {
    $('#LoginPasswordError').hide();
  }
  return status;
}

function PasswordValidate(){
  var oldpassword = $("#user_current_password").val();
  var newpassword = $("#user_password").val();
  var newconfirmpassword = $("#user_password_confirmation").val();


  if (oldpassword == ''){
    $('#OldPasswordError').show();
    $('#OldPasswordError').html('Please enter password.');
    status = "false";
  }
  else
  {
    $('#OldPasswordError').hide();
  }
  if(newpassword == '')
  {
    $('#ChangePasswordError').show();
    $('#ChangePasswordError').html('Please enter new password.');
    status = "false";
  }
  else if(newpassword != ''  && newpassword.length<6)
  {
    $('#ChangePasswordError').show();
    $('#ChangePasswordError').html('Password is too short.');
    status = "false";
  }
  else if(oldpassword != '' &&  newpassword != ''  &&  oldpassword == newpassword)
  {
    $('#ChangePasswordError').show();
    $('#ChangePasswordError').html('Re-enter password old and new are same.');
    status = "false";
  }
  else
  {
    $('#ChangePasswordError').hide();
  }
  if(newconfirmpassword == '')
  {
    $('#ChangePasswordConfirmError').show();
    $('#ChangePasswordConfirmError').html('Please enter new again password.');
    status = "false";
  }
  else if( newpassword != ''  &&  newconfirmpassword != ''  &&  newpassword != newconfirmpassword)
  {
    $('#ChangePasswordConfirmError').show();
    $('#ChangePasswordConfirmError').html('New and new, again does not match.');
    status = "false";
  }
    
  else
  {
    $('#ChangePasswordConfirmError').hide();
  }
    
    
  return status;

}
function UserProfileValidate()
{
  var email = $("#user_email").val();
  var email_status= validateEmail(email);
  var FirstName = $("#user_profile_first_name").val();
  var LastName = $("#user_profile_last_name").val();
  var Firstname_status = validateUsername(FirstName);
  var Latstname_status = validateUsername(LastName);
  var Firstname_status2 = validateUsernames(FirstName);
  var Latstname_status2 = validateUsernames(LastName);
  var default_location = $("#jQueryCityAutocomplete").val();
  var default_location_status = validateUsername(default_location);
  var default_location_status2 = validateUsernames(default_location);

  if(email== '')
  {
    $('#EmailError').show();
    $('#EmailError').html("Email is required. ")
    PROFILE_STATUS = "false";
  }
  else if(email!= '' && email_status == 'false')
  {
    $('#EmailError').show();
    $('#EmailError').html("Please enter valid email id. ")
    PROFILE_STATUS = "false";
  }
  else
  {
    $('#EmailError').hide();
  }
  if(FirstName == '')
  {
    $('#FnameError').show();
    $('#FnameError').html("First Name is required. ")
    PROFILE_STATUS = "false";

  }
  else if(FirstName.length < 2)
  {
    $('#FnameError').show();
    $('#FnameError').html("First Name should have atleast two characters. ")
    PROFILE_STATUS = "false";

  }
  else if(FirstName != '' && Firstname_status =='false' )
  {
    $('#FnameError').show();
    $('#FnameError').html("First Name doesnot accept only special characters or numbers.")
    PROFILE_STATUS = "false";

  }
  else if(FirstName != '' && Firstname_status2 =='false' )
  {
    $('#FnameError').show();
    $('#FnameError').html("First Name doesnot accept more than three consecutive characters.")
    PROFILE_STATUS = "false";

  }
  else
  {
    $('#FnameError').hide();
  }
  if(LastName == '')
  {
    $('#LnameError').show();
    $('#LnameError').html("Last Name is required. ")
    PROFILE_STATUS = "false";

  }
  else if(LastName.length < 2)
  {
    $('#LnameError').show();
    $('#LnameError').html("Last Name should have atleast two characters. ")
    PROFILE_STATUS = "false";

  }
  else if(FirstName != '' && LastName != '' && FirstName ==  LastName)
  {
    $('#LnameError').show();
    $('#LnameError').html("First Name and Last Name could not be same.")
    PROFILE_STATUS = "false";

  }
  else if(LastName != '' && Latstname_status =='false' )
  {
    $('#LnameError').show();
    $('#LnameError').html("Last Name doesnot accept only special characters or numbers.")
    PROFILE_STATUS = "false";

  }
  else if(LastName != '' && Latstname_status2 =='false' )
  {
    $('#LnameError').show();
    $('#LnameError').html("Last Name doesnot accept more than three consecutive characters.")
    PROFILE_STATUS = "false";

  }
  else
  {
    $('#LnameError').hide();
  }
    
     
  if(default_location == '' )
  {
    $('#locationError').show();
    $('#locationError').html("Location is required.")
    PROFILE_STATUS = "false";

  }
  else if(default_location != '' && default_location.length < 4)
  {
    $('#locationError').show();
    $('#locationError').html("Location  should have atleast four characters. ")
    PROFILE_STATUS = "false";

  }
  else
  {
    $('#locationError').hide();
  }

//return status;
}
function validateUsernames(Username){
  var f = /(\w)\1{2,}/;
  if(f.test(Username)){

    return "false";
  }
  else{
    return "true";
  }
}

function validateUsername(Username){
  var f = /[a-zA-Z]{1,}/;
  if(f.test(Username)){
    return "true";
  }
  else{
    return "false";
  }
}
function validateEmail(email){
  var filter = /^((\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*?)\s*;?\s*)+/;
  if(filter.test(email)){
    return "true";
  }
  else{
    return "false";
  }
}

