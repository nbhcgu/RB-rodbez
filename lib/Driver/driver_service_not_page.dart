import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rodbez/Driver/driver_publish_page.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DriverServiceNotPage extends StatefulWidget {
  DriverServiceNotPage({required this.message,required this.caption,required this.start_address,required this.start_lat,required this.start_long,
    required this.end_address,required this.end_lat,required this.end_long,required this.cab_icon,required this.cab_type,required this.date});
  final String message;
  final String caption;
  final String start_address;
  final String start_lat;
  final String start_long;
  final String end_address;
  final String end_lat;
  final String end_long;
  final String cab_icon;
  final String cab_type;
  final String date;
  @override
  DriverServiceNotPageState createState() => DriverServiceNotPageState();
}

class DriverServiceNotPageState extends State<DriverServiceNotPage> {
  late CameraPosition _initialPosition;
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  var geoLocator = Geolocator();
  String driverStatusText = "Inactive ";
  late BitmapDescriptor pinLocationIcon;

  Color driverStatusColor = Colors.red;
  final DatabaseReference help = FirebaseDatabase.instance.reference();

  bool isDriverAvailable = true;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  DateTime _dateTime = DateTime.now();
  @override
  void initState() {
    setCustomMapPin();
    // TODO: implement initState
    super.initState();
  }
  void onMapCreated(GoogleMapController controller) {
    // _controller.complete(controller);
    controller.setMapStyle('''
    
    ''');
  }
  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/car.png');
  }

  rideRequest( ) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String idL = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    print("user_login_token-" + idL);
    API.rideRequest(id, idL, widget.start_address,widget.start_lat,widget.start_long,widget.end_address,
        widget.end_lat,widget.end_long,widget.date)
        .then((response) {
      EasyLoading.dismiss();
      print(response.body);
      var jVar = jsonDecode(response.body);
      print(jVar);
      if (jVar["status"] == 200) {
        if (json.decode(response.body)['chk'] == 1) {
          var searchList = json.decode(response.body)['data'];
          Fluttertoast.showToast(
              msg: searchList["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DriverPublishPage(message: widget.message,
                        caption: widget.caption,
                        start_lat: widget.start_lat,
                        start_long: widget.start_long,
                        start_address: widget.start_address,
                        end_lat: widget.end_lat,
                        end_long: widget.end_long,
                        end_address: widget.end_address,
                        cab_icon: widget.cab_icon,
                        cab_type: widget.cab_type,
                        date: widget.date,
                          driver_publish_page_msg_heading_status:searchList["driver_publish_page_msg_heading_status"],
                          driver_publish_page_msg_heading:searchList["driver_publish_page_msg_heading"],
                          driver_publish_page_msg:searchList["driver_publish_page_msg"],
                          ride_id:searchList["ride_id"],
                          display_id:searchList["display_id"]
                      )));
        }
      } else {
        Fluttertoast.showToast(
            msg: "Try Again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
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
        zoom: 10,
      );
      final GoogleMapController controller = await _controllerGoogleMap.future;
      var markerIdVal = "1";
      final MarkerId markerId = MarkerId(markerIdVal);

      // creating a new MARKER
      final Marker marker = Marker(
          markerId: markerId,
          icon: pinLocationIcon,
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,150),
              child: GoogleMap(
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
          "color": "#959595"
        }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
        {
          "color": "#959595"
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
                getPos();
                getEPos();
                },
              ),
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
                        blurRadius: 3.0,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.message, style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold),),
                              SizedBox(height: 3,),
                              Text(widget.caption, style: TextStyle(color: Colors.black, fontSize: 16,)),
                              SizedBox(height: 10,),
                              Divider(),
                              SizedBox(height: 10,),
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 1.2,
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Icon(
                                                Icons.circle,
                                                color: Colors.green,
                                                size: 10,
                                              ),
                                              Container(
                                                  height: 50,
                                                  child: VerticalDivider(
                                                    width: 1,
                                                    color: Colors.grey,
                                                  )),
                                              Icon(
                                                Icons.circle,
                                                color: Colors.red,
                                                size: 10,
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: <Widget>[
                                                     Flexible(
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                              .fromLTRB(20, 0, 0, 0),
                                                          child: Text(
                                                            widget.start_address,
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                color: Colors.grey,overflow: TextOverflow.ellipsis),
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 20.0,
                                                      top: 10,
                                                      bottom: 10),
                                                  child: Divider(),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Flexible(
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                              .fromLTRB(20, 0, 0, 0),
                                                          child: Text(
                                                            widget.end_address,
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                color: Colors.grey,overflow: TextOverflow.ellipsis),
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(0, 5, 10, 0),
                                      child: Icon(Icons.calendar_month,
                                          color: Colors.black, size: 24.0),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 05, 10, 0),
                                        child: Text(
                                          widget.date,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Divider(),
                              // GestureDetector(
                              //   onTap: () {},
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(20),
                              //     child: Container(
                              //       // height: MediaQuery.of(context).size.height/8,
                              //       width: MediaQuery.of(context).size.width / 1.2,
                              //       child: Column(
                              //         mainAxisAlignment: MainAxisAlignment.start,
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           Row(
                              //             mainAxisAlignment: MainAxisAlignment.start,
                              //             children: <Widget>[
                              //               Expanded(
                              //                 flex: 2,
                              //                 child: Column(
                              //                   mainAxisAlignment:
                              //                   MainAxisAlignment.start,
                              //                   crossAxisAlignment:
                              //                   CrossAxisAlignment.start,
                              //                   children: [
                              //                     Text(
                              //                       widget.cab_type,
                              //                       textAlign: TextAlign.left,
                              //                       style: TextStyle(
                              //                         fontWeight: FontWeight.bold,
                              //                         fontSize: 20,
                              //                       ),
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              //               Expanded(
                              //                 flex: 1,
                              //                 child: SizedBox(
                              //                   child: widget.cab_icon.isEmpty?Icon(Icons.account_circle_rounded,color: Colors.black,size: 50,):
                              //                   Image.network(widget.cab_icon,width: 50,height: 50,),
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ],
                              //       ),
                              //       // constraints: BoxConstraints(minWidth: 100, maxHeight: 200),
                              //       decoration: BoxDecoration(
                              //         color: Colors.white,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.only(top: 8,bottom: 8,left: 24,right: 24),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: RaisedButton(
                            child: Text("Request for ride", style: TextStyle(fontSize: 16,color: Colors.white),),
                            color: Colors.black,
                            elevation: 5,
                            textColor: Colors.white,
                            onPressed: () {
                              rideRequest();
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
