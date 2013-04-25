var zoom = 10;
var geocoder = new google.maps.Geocoder();

var Google_Map = {

  map: '',
  default_marker: null,
  markers: new Array(),
  rectangle: new google.maps.Rectangle(),
  gm_ids: new Array(),
  infowindow: null,
  favorite_markers: new Array(),
  lat_lng_obj: '',
  passionate_marker: '',
  passionate_marker_arr : new Array(),
  curious_markers : new Array(),

  init: function(lat, lng) {
    var latlng = new google.maps.LatLng(lat, lng);
    var options = {
      zoom: zoom,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }

    Google_Map.map = new google.maps.Map(document.getElementById("map-container"), options);

    this.infowindow = new google.maps.InfoWindow({
      content: "Holding..."
    });
    
  },

  set_map_center: function(lat, lng ) {
    var new_lat_lng = new google.maps.LatLng(lat, lng);
    this.map.setCenter(new_lat_lng);
  },
  
  get_bounded_locations: function(lat, lng, url) {
    var zoom = Google_Map.map.getZoom();
    var ne= '';
    var sw = '';
    // Get the current bounds, which reflect the bounds before the zoom.
    var rectOptions = {
      map: Google_Map.map,
      visible: false,
      bounds: Google_Map.map.getBounds()
    };
    Google_Map.rectangle.setOptions(rectOptions);
    ne = rectOptions.bounds.getNorthEast();
    sw = rectOptions.bounds.getSouthWest();
    //console.log(ne);
    // Ajax call
    jQuery.ajax({
      url: url,
      data: 'location[lat]='+lat+'&location[lng]='+lng+'&ne[lat]='+ne.lat()+'&ne[lng]='+ne.lng()+'&sw[lat]='+sw.lat()+'&sw[lng]='+sw.lng()+'&zoom='+zoom,
      method: 'GET'
    });

  },

  passionate_location_around: function(lat, lng, url)
  {
    var zoom = Google_Map.map.getZoom();
    var ne= '';
    var sw = '';
    // Get the current bounds, which reflect the bounds before the zoom.
    var rectOptions = {
      map: Google_Map.map,
      visible: false,
      bounds: Google_Map.map.getBounds()
    };
    Google_Map.rectangle.setOptions(rectOptions);
    ne = rectOptions.bounds.getNorthEast();
    sw = rectOptions.bounds.getSouthWest();
    //console.log(ne);
    // Ajax call
    jQuery.ajax({
      url: url,
      data: 'location[lat]='+lat+'&location[lng]='+lng+'&ne[lat]='+ne.lat()+'&ne[lng]='+ne.lng()+'&sw[lat]='+sw.lat()+'&sw[lng]='+sw.lng()+'&zoom='+zoom,
      method: 'GET'
    });
  },

  curious_marker : function(lat, lng, name, location_id) {
    var new_lat_lng = new google.maps.LatLng(lat, lng);
    this.default_marker = new google.maps.Marker({
      position: new_lat_lng,
      map: Google_Map.map,
      title: name,
      icon: '/assets/curious_pin.png'
    });
    Google_Map.curious_markers = [];
    this.default_marker.location_id = location_id;
    Google_Map.curious_markers.push(this.default_marker);
  },

  curious_marker_click: function(latitude, longitude, city, state, street_address, name, short_name, location_id ) {
    var i = 0;
    var id = 0;
    var link = '';
    for( i = 0 ; i < Google_Map.curious_markers.length ; i++) {
      id = Google_Map.curious_markers[i].location_id;
      //console.log(id);
      if($('a#marker-link-event-'+id).length > 0) {
        console.log("marker is present...");
        $('a#marker-link-event-'+id).attr('href','/curious_reviews?location_id='+id+'&location[latitude]='+latitude+'&location[longitude]='+longitude+'&location[city]='+city+'&location[state]='+state+'&location[street_address]='+street_address+'&location[name]='+name);
        //link.setAttribute('class', 'fancybox_iframe fancybox.iframe');
        //link.setAttribute('style', 'display:none;');
      }
      else {
        console.log("marker is NOT present...")
        link = document.createElement("a");
        link.setAttribute('href','curious_reviews?location_id='+id+'&location[latitude]='+latitude+'&location[longitude]='+longitude+'&location[city]='+city+'&location[state]='+state+'&location[street_address]='+street_address+'&location[name]='+name);
        link.setAttribute('id', 'marker-link-event-'+Google_Map.curious_markers[i].location_id);
        link.setAttribute('class', 'fancybox_iframe fancybox.iframe');
        link.setAttribute('style', 'display:none;');
        document.body.appendChild(link);
      }
    }
    
    console.log(Google_Map.curious_markers.length);
    for(i = 0 ; i < Google_Map.curious_markers.length ; i++) {
      //id = Google_Map.markers[i].location_id;
      console.log(Google_Map.curious_markers[0]);
      google.maps.event.clearListeners(Google_Map.curious_markers[0], 'click');
      google.maps.event.addListener(Google_Map.curious_markers[0], 'click', function(){
        jQuery('a#marker-link-event-'+this.location_id).click();
      });

    }

  },

  passionate_mark : function(lat, lng, passionate_loc_name, location_id , full_address, phone) {
    var new_lat_lng = new google.maps.LatLng(lat, lng);
    this.passionate_marker = new google.maps.Marker({
      position: new_lat_lng,
      map: Google_Map.map,
      title: passionate_loc_name,
      icon: '/assets/social_images/passionates_pin.png'
    });

    this.passionate_marker.location_id = location_id
    this.passionate_marker.full_address = full_address
    this.passionate_marker.phone = phone
    Google_Map.passionate_marker_arr = [];
    Google_Map.passionate_marker_arr.push(this.passionate_marker);

  },
  
  location_autocomplete: function(element, lat, lng) {
    
    var input = document.getElementById(element);
    var autocomplete = new google.maps.places.Autocomplete(input);

    autocomplete.bindTo('bounds', Google_Map.map);
    google.maps.event.addListener(autocomplete, 'place_changed', function() {
      var place = autocomplete.getPlace();
      if(lat.length > 0 && lng.length > 0) {
        $(lat).val(place.geometry.location.lat());
        $(lng).val(place.geometry.location.lng());
        if($('.jQueryCuriousName').length > 0) {
          $('.jQueryCuriousName').val(input.value);
        }
      }
      
    });
    
  },

  location_marker: function(lat, lng, name, category, location_id, address, friends_belongs, phone_number, review_count, owner_or_not, user_id, passionate, suggestion, location_list_id) {
    category = category.toLowerCase();
    var num1, num2, num3, num4;
    var new_lat_lng;
    var status = 'false';
    num2 = Math.round(lat * 10000) / 10000;
    num4 = Math.round(lng * 10000) / 10000;
    
    for(var i=0; i< this.markers.length;i++) {
      num1 = Math.round(this.markers[i].position.lat() * 10000) / 10000;
      num3 = Math.round(this.markers[i].position.lng() * 10000) / 10000;

      if( (num1 == num2) && (num3 == num4) ) {
        status = "true";
        break;
      }
      else {
        status = "false";
      }
    }
      
    if(status == "false")
    {
      new_lat_lng = new google.maps.LatLng(lat, lng);
      if(category == 'dining') {
        category = 'food'
      }
      
      if(passionate == 'true') {
        this.default_marker = new google.maps.Marker({
          position: new_lat_lng,
          map: Google_Map.map,
          icon: '/assets/social_images/passionates_pin.png',
          title: name
        });

      }

      else if(parseInt(suggestion) != 0) {
        this.default_marker = new google.maps.Marker({
          position: new_lat_lng,
          map: Google_Map.map,
          icon: '/assets/social_images/suggestion_pin.png',
          title: name
        });
      }
      
      else {
        
        this.default_marker = new google.maps.Marker({
          position: new_lat_lng,
          map: Google_Map.map,
          icon: '/assets/social_images/'+category.split(' ')[0]+'_pin.png',
          title: name
        });
      }



      //console.log(category);
      this.default_marker.category = category.split(' ')[0];
      this.default_marker.location_name = name.split(',')[0];
      this.default_marker.location_id = location_id;
      this.default_marker.address = address;
      this.default_marker.status = friends_belongs;
      this.default_marker.phone = phone_number;
      this.default_marker.review_count = review_count;
      this.default_marker.owner_or_not = owner_or_not
      this.default_marker.passionate = passionate
      this.default_marker.suggestion = suggestion
      this.default_marker.location_list_id = location_list_id


      this.markers.push(this.default_marker);
      
    }

  },

  fit_bounds: function(address){
    var latlngbounds = new google.maps.LatLngBounds();
    //console.log(this.favorite_markers.length);
    console.log("locations present"+Google_Map.markers.length);
    if(Google_Map.passionate_marker_arr.length > 0) {
      Google_Map.markers.push(Google_Map.passionate_marker_arr[0]);
    }
    
    if(Google_Map.markers.length > 0) {
      for(var i = 0; i < this.markers.length; i++) {
        var new_lat_lng = new google.maps.LatLng(parseFloat(this.markers[i].position.lat()), parseFloat(this.markers[i].position.lng()));
        latlngbounds.extend(new_lat_lng);
      }

      Google_Map.map.setCenter(latlngbounds.getCenter());
      Google_Map.map.fitBounds(latlngbounds);
      if(this.markers.length == 1) {
        Google_Map.map.setZoom(Google_Map.map.getZoom() - 2);
      }
    }
    
    else {
      Google_Map.geocoder_search(address);
      latlngbounds.extend(Google_Map.lat_lng_obj);
      Google_Map.map.setCenter(latlngbounds.getCenter());
      Google_Map.map.fitBounds(latlngbounds);
      Google_Map.map.setZoom(Google_Map.map.getZoom() - 10);
    }


  },

  marker_click_event: function() {
    var id = 0;
    var suggestion = 0;
    for( var i = 0 ; i < Google_Map.markers.length ; i++) {
      id = Google_Map.markers[i].location_id;
      suggestion = parseInt(Google_Map.markers[i].suggestion);
      if($('a#marker-link-event-'+id).length <= 0) {
        var link = document.createElement("a");
        if(Google_Map.markers[i].passionate != "true" && suggestion != 0) {
          link.setAttribute('href','/insider/suggestions/'+suggestion+'/edit');
        }
        else {
          link.setAttribute('href','/sidekick/locations/'+id+'/review/details?location_list_id='+Google_Map.markers[i].location_list_id);
        }

        link.setAttribute('id', 'marker-link-event-'+id);
        link.setAttribute('class', 'fancybox_iframe fancybox.iframe');
        link.setAttribute('style', 'display:none;');
        
        document.body.appendChild(link);
      }
    }

    for(var i = 0 ; i < Google_Map.markers.length ; i++) {
      //id = Google_Map.markers[i].location_id;
      google.maps.event.clearListeners(Google_Map.markers[i], 'click');
      google.maps.event.addListener(Google_Map.markers[i], 'click', function(){
        jQuery('a#marker-link-event-'+this.location_id).click();
      });

    }

  },

  passionate_marker_click_event: function() {
    if(Google_Map.passionate_marker != '' ) {
      if($('a#passionate-marker-link-'+Google_Map.passionate_marker.location_id).length <= 0) {
        alert(Google_Map.passionate_marker);
        var link = document.createElement("a");
        link.setAttribute('href','/sidekick/locations/'+Google_Map.passionate_marker.location_id+'/reviews');

        link.setAttribute('id', 'passionate-marker-link-'+Google_Map.passionate_marker.location_id);
        link.setAttribute('class', 'fancybox_iframe fancybox.iframe');
        link.setAttribute('style', 'display:none;');
        document.body.appendChild(link);
      }
      google.maps.event.clearListeners(Google_Map.passionate_marker, 'click');
      google.maps.event.addListener(Google_Map.passionate_marker, 'click', function(){
        jQuery('a#passionate-marker-link-'+Google_Map.passionate_marker.location_id).click();
      });
    }
  },

  custom_info_window: function(name, address, phone, reviews) {
    var cnt_str;
    for(var i = 0; i < Google_Map.markers.length; i++) {
      if(Google_Map.markers[i].owner_or_not == "yes") {
        cnt_str = '<a href="/sidekick/locations/'+Google_Map.markers[i].location_id+'/archive" >Archive Location</a>';
      }
      else {
        cnt_str = '';
      }
      google.maps.event.addListener(Google_Map.markers[i], 'click', function() {
        var contentString = '<div style="width:450px;height:auto"><div>'+name+'- '+this.location_name+'</div>' +
        '<div style="margin-top:8px;">'+address+' - '+this.address+'</div></div>' +
        '<div style="margin-top:8px;">'+phone+' - '+this.phone+'</div></div>' +
        '<div style="margin-top:8px;">'+reviews+' - '+this.review_count+'</div></div>' +
        '<div style="margin-top:8px;"><a href="/sidekick/locations/'+this.location_id+'/reviews" style="text-decoration:underline">More</a></div></div>' + cnt_str ;

        Google_Map.infowindow.setContent(contentString);
        Google_Map.infowindow.open(Google_Map.map, this);
      });
    }
    
  },

  update_location_status: function() {
    for(var i = 0; i < Google_Map.markers.length; i++) {
      //console.log(Google_Map.markers[i].location_id);
      //$('#'+Google_Map.markers[i].location_id).attr('class', '');
      $('#'+Google_Map.markers[i].location_id).addClass(Google_Map.markers[i].status);
    }
  },

  street_view_service: function(lat, lng, location_id, location_list_id){
    var lat_lng = new google.maps.LatLng(lat, lng);
    var streetviewService = new google.maps.StreetViewService();
    streetviewService.getPanoramaByLocation(lat_lng, 50, function(result, status) {
      if ( status == google.maps.StreetViewStatus.OK ) {
        console.log(result);
        var image_src = "http://maps.googleapis.com/maps/api/streetview?size=90x90&location="+lat+','+lng+"&sensor=false";
        if(location_list_id == '') {
          jQuery("#location-"+location_id).attr('src', image_src);
        }
        else {
          jQuery("#location-"+location_id+"-list-"+location_list_id).attr('src', image_src);
        }
      }
      else {
        if(location_list_id == '') {
          jQuery("#location-"+location_id).remove();
        }
        else {
          jQuery("#location-"+location_id+"-list-"+location_list_id).remove();
        }
      }
    });
  },

  clear_fit_bounds_map: function() {
    while(Google_Map.markers[0]){
      Google_Map.markers.pop().setMap(null);
    }
  },

  create_custom_button: function(content_0) {
    var element = document.createElement('div');
    //element.style.paddingLeft = '0px';
    element.style.marginRight = '8px'
    element.style.marginBottom = '5px'
    element.innerHTML = content_0;
    Google_Map.map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(element);
  },

  geocoder_search: function(address) {
    geocoder.geocode({
      'address':address
    },
    function(results, status) {
      if(status == google.maps.GeocoderStatus.OK) {
        Google_Map.lat_lng_obj = new google.maps.LatLng(parseFloat(results[0].geometry.location.lat()), parseFloat(results[0].geometry.location.lng()));
      }
    });
  },

  set_zoom_level: function(zoom) {
    Google_Map.map.setZoom(zoom);
  }
  
} 


