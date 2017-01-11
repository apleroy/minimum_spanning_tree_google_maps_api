
$( document ).ready(function() {

    checkEmptyLocationList();

    $(document).on('click', "#add-place-to-list", function() {
        var formatted_address = $(this).closest("#mst-marker-bubble").find("#formatted-address").text();
        addListContent(formatted_address);
        checkEmptyLocationList();
    });

    $(document).on('click', ".delete-place", function() {
        var address = $(this).closest(".location-address").find(".address-input").text();

        $(this).closest(".location-address").remove();

        $('input[name="minimum_spanning_tree[place_names][]"]').each(function(){
            if ($(this).val() == address) {
                $(this).remove();
            }
        });

        checkEmptyLocationList();
    });



});

function addListContent(formatted_address) {
    var list_content = (
        '<li class="list-group-item location-address" role="alert"><button type="button" class="close delete-place" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>'
        + '<div class="address-input">' + formatted_address + '</div>'
        + '</li>'
    )
    var field = "<input multiple='multiple' type='hidden' name='minimum_spanning_tree[place_names][]' id='minimum_spanning_tree_place_names' value='" + formatted_address + "'</input>";
    var form = $('#minimum_spanning_tree_form');
    form.append(field);
    $("#mst-input-list").append(list_content);
}

function checkEmptyLocationList() {
    var length = $("#mst-input-list > li").length;

    if (length >= 1) {
        $(".js-empty-location-holder").hide();
    } else {
        $(".js-empty-location-holder").show();
    }
}

function initMap() {
    //var bounds = new google.maps.LatLngBounds();
    var map = new google.maps.Map(document.getElementById('map'), {
        center: {lat: 41.85, lng: -87.65},
        zoom: 6
    });

    // setup the autocomplete feature of the map -------------
    var input = /** @type {!HTMLInputElement} */(
        document.getElementById('pac-input'));

    var types = document.getElementById('type-selector');
    map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);
    map.controls[google.maps.ControlPosition.TOP_LEFT].push(types);

    var autocomplete = new google.maps.places.Autocomplete(input);
    autocomplete.bindTo('bounds', map);

    var infowindow = new google.maps.InfoWindow();
    var marker = new google.maps.Marker({
        map: map,
        anchorPoint: new google.maps.Point(0, -29)
    });

    autocomplete.addListener('place_changed', function () {
        infowindow.close();
        marker.setVisible(false);
        var place = autocomplete.getPlace();
        if (!place.geometry) {
            window.alert("Autocomplete's returned place contains no geometry");
            return;
        }

        // If the place has a geometry, then present it on a map.
        if (place.geometry.viewport) {
            map.fitBounds(place.geometry.viewport);
        } else {
            map.setCenter(place.geometry.location);
            map.setZoom(17);  // Why 17? Because it looks good.
        }
        marker.setIcon(/** @type {google.maps.Icon} */({
            url: place.icon,
            size: new google.maps.Size(71, 71),
            origin: new google.maps.Point(0, 0),
            anchor: new google.maps.Point(17, 34),
            scaledSize: new google.maps.Size(35, 35),
            class: 'andy_marker_class'
        }));
        marker.setPosition(place.geometry.location);
        marker.setVisible(true);

        var address = '';
        if (place.address_components) {
            address = [
                (place.address_components[0] && place.address_components[0].short_name || ''),
                (place.address_components[1] && place.address_components[1].short_name || ''),
                (place.address_components[2] && place.address_components[2].short_name || '')
            ].join(' ');
        }


        infowindow.setContent(
            "<div id='mst-marker-bubble' class='outer-infowindow'><div><strong>"
            + place.name + "</strong><br><span id='formatted-address'>"
            + place.formatted_address + "</span></div><button id='add-place-to-list' class='btn btn-primary'>Add To List</button>"
        );
        infowindow.open(map, marker);
    });

    // ---------------------------

    bounds = plotEdges(map);
    if (bounds.length > 0) {
        map.fitBounds(bounds);
        var listener = google.maps.event.addListener(map, "idle", function () {
            if (map.getZoom() > 16) map.setZoom(16);
            google.maps.event.removeListener(listener);
        });
    }
}

function calculateAndDisplayRoute(directionsService, directionsDisplay, origin, destination, map, markers) {

    directionsService.route({
        origin: origin,
        destination: destination,
        travelMode: 'DRIVING'
    }, function(response, status) {
        if (status === 'OK') {
            directionsDisplay.setDirections(response);
            var leg = response.routes[ 0 ].legs[ 0 ];
            markers.push(makeMarker( leg.start_location, map ));
            markers.push(makeMarker( leg.end_location, map ));
        } else {
            window.alert('Directions request failed due to ' + status);
        }
    });

    return markers;
}

function makeMarker( position, map ) {
    var m = new google.maps.Marker({
        position: position,
        map: map,
    });
    return m;
}

function plotEdges(map) {
    var markers = [];
    // foreach edge
    // initialize directionService and directionDisplay
    // pass the nodes of the edge to the service
    for (var i = 0; i < $mst_edges.length; i++) {

        var node1 = $mst_edges[i].name1;
        var node2 = $mst_edges[i].name2;

        var directionsService = new google.maps.DirectionsService;
        var directionsDisplay = new google.maps.DirectionsRenderer({suppressMarkers: true});
        directionsDisplay.setMap(map);
        directionsDisplay.setOptions({
            polylineOptions: {
                strokeWeight: 4,
                strokeOpacity: 1,
                strokeColor: 'red'
            }
        });

        calculateAndDisplayRoute(directionsService, directionsDisplay, node1, node2, map, markers);

    }

    var bounds = new google.maps.LatLngBounds();
    for (var i = 0; i < markers.length; i++) {
        bounds.extend(markers[i].position);
    }

    return bounds;
}





