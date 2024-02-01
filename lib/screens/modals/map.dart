import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GMap extends StatefulWidget {

  double long = -1;
  double lat = -1;
  List<List<double>> locations = [];

  GMap({super.key});

  GMap.location({super.key, required this.long, required this.lat});
  GMap.locations({super.key,required this.locations});


  @override
  State<GMap> createState() => GMapState();
}

class GMapState extends State<GMap> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();


  // String googleAPiKey = "AIzaSyA965hXFEIXanF8FBPrD5LqVRIK3UR4VUs";
  //
  // Set<Marker> markers = Set(); //markers for google map
  // Map<PolylineId, Polyline> polylines = {}; //polylines to show direction


  static late LocationData locationData;

  
  Set<Marker> markers = {};
  
  @override
  void initState()  {
    // TODO: implement initState
    super.initState();

    // markers.add(Marker( //add start location marker
    //   markerId: MarkerId(startLocation.toString()),
    //   position: startLocation, //position of marker
    //   infoWindow: InfoWindow( //popup info
    //     title: 'Starting Point ',
    //     snippet: 'Start Marker',
    //   ),
    //   icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    // ));
    //
    // markers.add(Marker( //add distination location marker
    //   markerId: MarkerId(endLocation.toString()),
    //   position: endLocation, //position of marker
    //   infoWindow: InfoWindow( //popup info
    //     title: 'Destination Point ',
    //     snippet: 'Destination Marker',
    //   ),
    //   icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    // ));
    //
    // getDirections(); //fetch direction polylines from Google API

  }


  // getDirections() async {
  //   List<LatLng> polylineCoordinates = [];
  //
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     googleAPiKey,
  //     PointLatLng(startLocation.latitude, startLocation.longitude),
  //     PointLatLng(endLocation.latitude, endLocation.longitude),
  //     travelMode: TravelMode.driving,
  //   );
  //
  //   if (result.points.isNotEmpty) {
  //     result.points.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });
  //   } else {
  //     print(result.errorMessage);
  //   }
  //   addPolyLine(polylineCoordinates);
  // }
  //
  // addPolyLine(List<LatLng> polylineCoordinates) {
  //   PolylineId id = PolylineId("poly");
  //   Polyline polyline = Polyline(
  //     polylineId: id,
  //     color: Colors.deepPurpleAccent,
  //     points: polylineCoordinates,
  //     width: 8,
  //   );
  //   polylines[id] = polyline;
  //   setState(() {});
  // }

  static const CameraPosition _Skopje = CameraPosition(
    target: LatLng(42.00430357002759, 21.40871880562107),
    zoom: 14.4746,
  );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<CameraPosition>(
        future:getStartLocation(), builder: (BuildContext context, AsyncSnapshot<CameraPosition> snapshot) {
          if (snapshot.hasData){
   
            return GoogleMap(
              initialCameraPosition: snapshot.data ?? _Skopje,
              onMapCreated: (GoogleMapController controller) {

                _controller.complete(controller);
              },
              markers: markers,

              myLocationEnabled: true,
            );

          }else{
            return Text("Loading");

          }

      },

      )

    );
  }

  Future<CameraPosition> getStartLocation() async{
      await getLocation();
      getMarkers();
      if(widget.long != -1 && widget.lat != -1){
        return CameraPosition(zoom:18, target: LatLng(widget.lat, widget.long),);
      }
      return CameraPosition(zoom:15, target: LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0),);
  }
  
  void getMarkers(){
    markers = {};
    if(widget.long != -1){
        markers.add(Marker(markerId: const MarkerId("1"),position: LatLng(widget.lat,widget.long)));
    }else if(widget.locations.isNotEmpty){
      for(int i = 0; i < widget.locations.length ; i++){
        markers.add(Marker(markerId: MarkerId(i.toString()),position: LatLng(widget.locations[i][0],widget.locations[i][1])));
      }
    }
  }
  static Future<void> getLocation() async {
    Location location = Location();

    late PermissionStatus _permissionGranted;


    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print("servisot ne e pushten");
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print("nemam permisii");

        return;
      }
    }

    locationData = await location.getLocation();



  }
}