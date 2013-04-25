var WOEID;
var loc_lat = 0.0;
var loc_lng = 0.0;
var loc_name = '';
var loc_street = '';
var loc_city = '';
var loc_state = '';
var loc_full_address = '';
var profile_status;
var status
var location_list_name = '';

function form_submit_or_alert(element1, element2 ) {
  var status = Validate_Element.validate(element1, "presence", 2);
  if(status){
    fancy_box_close();
    $(element2).val( $(element1).val() );
    return true;
  }
  else {
    //event.preventDefault();
    alert("Invalid location");
    return false;
  }

}


function check_for_location(status, element) {

  if(status){
    Location_Add.element = element;
    google.setOnLoadCallback(Location_Add.onLoad(element));
  }
  else {
    alert("Please enter location and continue");
  }
}

function get_location_information(status, element) {

  if(status){
    Location_Add.element = element;
    google.setOnLoadCallback(Location_Add.onLoad(element));
  }
  else {
    alert("Please enter location and continue");
  }
}



Location_List = {
  bounds: '',
  
  create_new_location_list: function() {
    var i = 0;
    Location_List.bounds = Google_Map.map.getBounds();
    for(i = 0; i< Google_Map.markers.length; i++) {
      if(Location_List.bounds.contains(Google_Map.markers[i].getPosition())) {
        if(Google_Map.markers[i].getVisible()) {
          $('.jQueryAddLocIds').append("<input type=hidden name=location_id[] value="+Google_Map.markers[i].location_id+"></input>");
        }
      }
    }
    for(i = 0; i< Google_Map.passionate_marker_arr.length; i++) {
      if(Location_List.bounds.contains(Google_Map.passionate_marker_arr[i].getPosition())) {
        if(Google_Map.passionate_marker_arr[i].getVisible()) {
          $('.jQueryAddLocIds').append("<input type=hidden name=location_id[] value="+Google_Map.passionate_marker_arr[i].location_id+"></input>");
        }
      }
    }
  
  }
  
}

Location_Add = {
  localSearch: '',
  lat: '',
  lng: '',
  name: '',
  street_address: '',
  city: '',
  state: '',
  full_address: '',
  full_address_string: '',
  element: '',
  form_element: '',
  list_id: '',
  
  onLoad: function(element) {
    Location_Add.localSearch = new google.search.LocalSearch();

    Location_Add.localSearch.setSearchCompleteCallback(this, Location_Add.searchComplete, null);

    // Specify search quer(ies)
    Location_Add.localSearch.execute($(element).val());
  },

  // Get location address.
  searchComplete: function() {
    if(Location_Add.localSearch.results) {
      //console.log(Location_Add.localSearch.results[0]);
      for (var i = 0; i <= 0 ; i++) {
        Location_Add.lat = Location_Add.localSearch.results[i].lat;
        Location_Add.lng = Location_Add.localSearch.results[i].lng;
        Location_Add.name = Location_Add.localSearch.results[i].titleNoFormatting.split(',')[0];
        Location_Add.street_address = Location_Add.localSearch.results[i].streetAddress;
        Location_Add.city = Location_Add.localSearch.results[i].city;
        Location_Add.state = Location_Add.localSearch.results[i].region;
        Location_Add.full_address_string = Location_Add.street_address + ', ' + Location_Add.city + ', ' + Location_Add.state;
        Location_Add.full_address = Location_Add.localSearch.results[i].addressLines + "";
        
        $(loc_lat).val(Location_Add.lat);
        $(loc_lng).val(Location_Add.lng);
        $(loc_name).val(Location_Add.name);
        $(loc_street).val(Location_Add.street_address);
        $(loc_city).val(Location_Add.city);
        $(loc_state).val(Location_Add.state);
        $(loc_full_address).val(Location_Add.full_address);

      }
      
      //This api returns WOEID of the location
      if($.browser.msie && window.XDomainRequest) {
        xdr = new XDomainRequest();
        xdr.onload = function() {
          Location_Add.populate_location_attributes(xdr.responseText);
        }
        xdr.onerror = function() {
           console.log("Please try again");
        }
        xdr.open("GET", "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20geo.placefinder%20where%20text%3D%22"+encodeURIComponent(Location_Add.full_address_string)+"%22&format=json");
        xdr.send();

      }
      else {
        jQuery.ajax({
          type: 'GET',
          url: "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20geo.placefinder%20where%20text%3D%22"+encodeURIComponent(Location_Add.full_address_string)+"%22&format=json",
          success: function(result){
            Location_Add.populate_location_attributes(result);
          },
          error: function() {
            alert("Please try again");
          }
        });
      }

    }
    else {
      alert("please try again")
      $('#geocode_autocomplete').val('');
    }
    
  },
  
  populate_location_attributes: function(result) {

    if(jQuery.type(result) === 'string') {
      result = jQuery.parseJSON(result);
    }
    //console.log(result);
    //console.log(result);
    if(jQuery.isArray(result['query']['results']['Result'])) {
      WOEID = result['query']['results']['Result'][0]['woeid']
      var user_street = result['query']['results']['Result'][0]['street']
      var user_city = result['query']['results']['Result'][0]['city']
      Location_Add.state = result['query']['results']['Result'][0]['state']
      var user_zipcode = result['query']['results']['Result'][0]['uzip']
    }
    else {
      WOEID = result['query']['results']['Result']['woeid']
      var user_street = result['query']['results']['Result']['street']
      var user_city = result['query']['results']['Result']['city']
      Location_Add.state = result['query']['results']['Result']['state']
      var user_zipcode = result['query']['results']['Result']['uzip']
    }

    $(loc_state).val(Location_Add.state);
    if($(Location_Add.form_element).length > 0){
      $("input[type='hidden'][name='user_profile[woe_id]']").val(WOEID)
      $("input[type='hidden'][name='user_profile[location_street]']").val(Location_Add.street_address)
      $("input[type='hidden'][name='user_profile[location_city]']").val(Location_Add.city);
      $("input[type='hidden'][name='user_profile[location_state]']").val(Location_Add.state);
      $("input[type='hidden'][name='user_profile[location_zipcode]']").val(user_zipcode);
      $("input[type='hidden'][name='user_profile[location_latitude]']").val(Location_Add.lat);
      $("input[type='hidden'][name='user_profile[location_longitude]']").val(Location_Add.lng);
      $("input[type='hidden'][name='user_profile[name]']").val(Location_Add.name);
      $(Location_Add.form_element).submit();
    }

    else{
      $("input[name='location[WOEID]']").val(WOEID);
      jQuery.ajax({
        type: 'POST',
        url: Location_Add.url,
        data: 'location[name]='+Location_Add.name+'&location[WOEID]='+WOEID+'&location[street_address]='+Location_Add.street_address+'&location[full_address]='+Location_Add.full_address+'&location[latitude]='+Location_Add.lat+'&location[longitude]='+Location_Add.lng+'&location[city]='+Location_Add.city+'&location[state]='+Location_Add.state+'&location[zip_code]='+user_zipcode+'&location[location_state]='+Location_Add.state+'&location_list_id='+Location_Add.list_id+'&location_list_name='+location_list_name,
        error: function(xhr, data, status){
          alert(xhr);
        }
      });
    }
  }
  
}

// Document ready function
jQuery(document).ready(function($){
  $('#geocode_autocomplete, #curious_autocomplete, #jQueryCityAutocomplete').keydown(function(event){
    if(event.keyCode == 13) {
      event.preventDefault();
    }

  });

  $('.jQuery-sg-sidekick-check-for-loc').click(function(){
    var element = $('#geocode_autocomplete');
    Location_Add.list_id = $('.jQueryShowMy').val();
    Location_Add.url = '/sidekick/check'
    var status = Validate_Element.validate(element, "presence", 2);
    check_for_location(status, element);
    
  });

  $('.jQuery-sg-check-for-loc').click(function(ev){
    ev.preventDefault();
    Location_Add.list_id = $('.jQueryShowMy').val();
    location_list_name = jQuery('input#location_list_name').val();
    var element = $('.jQuery-sg-loc-section').find('input[type=text]');
    var status = Validate_Element.validate(element, "presence", 2);
    Location_Add.url = '/list/location_lists/check';
    check_for_location(status, element);
  });

  //Location list add button
  //
  $('.jQuery-Location-Add').click(function() {
    var element = $(this).closest('.jquery-row-fluid').find('input[type=text]');
    var status = Validate_Element.validate(element, "presence", 2);
    var container = $(this).closest('div.collapse1');
    Location_Add.list_id = $(container).attr('id').split('_')[1];
    Location_Add.url = '/list/location_lists/check';
    check_for_location(status, element);
  });
  
  $('.jQuery-Suggestion-Loc-Add').click(function(ev){
    ev.preventDefault();
    var element = $('#geocode_autocomplete');
    var status = Validate_Element.validate(element, "presence", 2);
    Location_Add.url = '/insider/suggestions/check';
    check_for_location(status, element);
  });

  $('#passionatesave').click(function(ev){
    var element = $('#geocode_autocomplete');
    if($(element).val() != '') {
      ev.preventDefault();
      //var index = $(this).attr('data-loc-ref');
      var status = Validate_Element.validate(element, "presence", 2);
      Location_Add.url = '/sidekick/passionate/check';
      check_for_location(status, element);
    }
    else {
      $('#passionate_location_id').val('');
      return true;
    }

  });
  
  $('input#Create').live('click',function(event){
    event.preventDefault();
    var element = $('#jQueryCityAutocomplete');
    Location_Add.form_element = $('#signup_form');
    var status = SignUpValidate();
    if(status == "false"){
      return false;
    }
    else {
      if(($('input.terms-chk').is(':checked'))) {
        check_for_location(true, element);
      }
      else {
        alert("Please confirm acceptance of Terms and Policy");
      }
    }

  });

  var select_friends = $('.jQuerySelectFriends').find('select');
  var select_friends_option = $('.jQuerySelectFriends').find('select option:first');
  $(select_friends).val($(select_friends_option).val());

  loc_lat = $('#jQueryLocationForm').find("input[name='location[latitude]']");
  loc_lng = $('#jQueryLocationForm').find("input[name='location[longitude]']");
  loc_name = $('#jQueryLocationForm').find("input[name='location[name]']");
  loc_street = $('#jQueryLocationForm').find("input[name='location[street_address]']");
  loc_city = $('#jQueryLocationForm').find("input[name='location[city]']");
  loc_state = $('#jQueryLocationForm').find("input[name='location[location_state]']");
  loc_full_address = $('#jQueryLocationForm').find("input[name='location[full_address]']");

  // For user profile saving
  $('#saveprofile').click(function(event){
    PROFILE_STATUS = "true";
    UserProfileValidate();
    if(PROFILE_STATUS == "false"){
      event.preventDefault();
    }
    else {
      event.preventDefault();
      var element = $('#jQueryCityAutocomplete');
      var status = Validate_Element.validate(element, "presence", 2);
      Location_Add.form_element = $('.sg_user_profile_form');
      check_for_location(status, element);
    }
  });

  $('.jQueryCuriousLoc').click(function(event){
    event.preventDefault();
    var element = $('#curious_autocomplete');
    var status = Validate_Element.validate(element, "presence", 2);
    Location_Add.form_element = $('#jQueryCuriousForm');
    check_for_location(status, element);
  });
  
});


