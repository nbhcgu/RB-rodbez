import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:selectable_container/selectable_container.dart';
import 'package:rodbez/Customer/cus_search_page.dart';

import '../map_utils.dart';
import 'cus_schedule_page.dart';

// import 'accept_widget.dart';

class CustomerServiceNotPage extends StatefulWidget {
  CustomerServiceNotPage({required this.message,required this.caption,required this.start_address,required this.start_lat,required this.start_long,
    required this.end_address,required this.end_lat,required this.end_long});
  final String message;
  final String caption;
  final String start_address;
  final String start_lat;
  final String start_long;
  final String end_address;
  final String end_lat;
  final String end_long;
  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<CustomerServiceNotPage> {
  late CameraPosition _initialPosition;
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  var geoLocator = Geolocator();
  String driverStatusText = "Inactive ";

  Color driverStatusColor = Colors.red;
  final DatabaseReference help = FirebaseDatabase.instance.reference();

  bool isDriverAvailable = true;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  DateTime _dateTime = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  void onMapCreated(GoogleMapController controller) {
    // _controller.complete(controller);
    controller.setMapStyle('''
    
    ''');
  }

  static const colorizeColors = [
    // Colors.green,
    Colors.white,
    Colors.green,
    Colors.grey,
    Colors.white,
    Colors.green,
  ];

  static const colorizeTextStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'Horizon',
  );
  late CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.7041, 77.1025),
    zoom: 15,
  );
  Future<void> getPos() async {
    print("curPos");
      _kGooglePlex = CameraPosition(
        target: LatLng(double.parse(widget.start_lat),double.parse(widget.start_long)),
        zoom: 15,
      );
      final GoogleMapController controller = await _controllerGoogleMap.future;
      var markerIdVal = "1";
      final MarkerId markerId = MarkerId(markerIdVal);

      // creating a new MARKER
      final Marker marker = Marker(
          markerId: markerId,
          position: LatLng(double.parse(widget.start_lat),double.parse(widget.start_long))
      );
      setState(() {
        controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
        // adding a new marker to map
        markers[markerId] = marker;
      });
  }
  Future<void> getEPos() async {
    print("curPos");
      final GoogleMapController controller = await _controllerGoogleMap.future;
      var markerIdVal = "2";
      final MarkerId markerId = MarkerId(markerIdVal);

      // creating a new MARKER
      final Marker marker = Marker(
          markerId: markerId,
          position: LatLng(double.parse(widget.end_lat),double.parse(widget.end_long))
      );
      setState(() {
        markers[markerId] = marker;
      });
  }
  _addPolyLine() {
    polylineCoordinates.add(new LatLng(double.parse(widget.start_lat), double.parse(widget.start_long)));
    polylineCoordinates.add(new LatLng(double.parse(widget.end_lat), double.parse(widget.end_long)));
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.black,
        points: polylineCoordinates,
        width: 2);
    setState(() {
      polylines[id] = polyline;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            GoogleMap(
              polylines: Set<Polyline>.of(polylines.values),
              initialCameraPosition: CameraPosition(target: LatLng(25.5941, 85.1376), zoom: 15),
              //markers: Set.from(_markers),
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              markers: Set<Marker>.of(markers.values),
              onMapCreated: (GoogleMapController controller)
              { _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              controller.setMapStyle('''
    [
  {
    "elementType": "geometry",
    "stylers": [
        {
          "color": "#f5f5f5"
        }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
        {
          "visibility": "off"
        }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
        {
          "color": "#616161"
        }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
        {
          "color": "#f5f5f5"
        }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
        {
          "color": "#bdbdbd"
        }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
        {
          "color": "#eeeeee"
        }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
        {
          "color": "#757575"
        }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
        {
          "color": "#e5e5e5"
        }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
        {
          "color": "#9e9e9e"
        }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
        {
          "color": "#ffffff"
        }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
        {
          "color": "#757575"
        }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
        {
          "color": "#fdeebc"
        }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
        {
          "color": "#616161"
        }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
        {
          "color": "#9e9e9e"
        }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
        {
          "color": "#e5e5e5"
        }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
        {
          "color": "#eeeeee"
        }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
        {
          "color": "#b1dcfa"
        }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
        {
          "color": "#b1dcfa"
        }
    ]
  }
]
    ''');
              _addPolyLine();
              getPos();getEPos();
              },
            ),
            Container(
              height: 140.0,
              width: double.infinity,
              // color: Colors.black87,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 40, 0, 0),
                child: Container(
                  height: 45.0,
                  width: 45.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    // border: Border.all(width: 2.0, color: Colors.grey[300]),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade500,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 5.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  // child: RaisedButton(
                  //   color: Colors.white,
                  //   shape: new RoundedRectangleBorder(
                  //     borderRadius: new BorderRadius.circular(5.0),
                  //   ),
                  //   onPressed: () {
                  //   },
                  child: Icon(
                    Icons.arrow_back,
                    size: 22.0,
                    color: Colors.black,
                  ),
                  // ),
                ),
              ),
            ),


            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: media.height/3,
                  // width: media.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 0.5,
                        blurRadius: 16.0,
                        color: Colors.black54,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: 70,
                        height: 7,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),)
                        ),
                      ),
                      SizedBox(
                        width: 350.0,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(widget.message, style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold),),
                              Text(widget.caption, style: TextStyle(color: Colors.black, fontSize: 16,))
                            ],),
                        ),
                      ),
                      SizedBox(height: 60,),
                      Padding(
                        padding: const EdgeInsets.only(top: 8,bottom: 8,left: 24,right: 24),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: RaisedButton(
                            child: Text("Update Route", style: TextStyle(fontSize: 16,color: Colors.white),),
                            color: Colors.black,
                            elevation: 5,
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ],),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
