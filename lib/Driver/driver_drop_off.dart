import 'dart:async';
import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rodbez/Driver/driver_accept_ride.dart';
import 'package:rodbez/Driver/driver_collect_cash.dart';
import 'package:rodbez/Driver/driver_ride_confirmed.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:rodbez/utils/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../map_utils.dart';

class DriverDropOff extends StatefulWidget {
  DriverDropOff({required this.searchList, required this.show_driver_km});

  var searchList;
  bool show_driver_km;

  @override
  DriverDropOffState createState() => DriverDropOffState();
}

class DriverDropOffState extends State<DriverDropOff> {
  TextEditingController disanceController = TextEditingController();
  TextEditingController tollOpController = TextEditingController();
  TextEditingController tollCompController = TextEditingController();
  late CameraPosition _initialPosition;
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  var geoLocator = Geolocator();
  String driverStatusText = "Inactive ";
  int cabIndex = -1;
  Color driverStatusColor = Colors.red;
  final DatabaseReference help = FirebaseDatabase.instance.reference();

  bool isDriverAvailable = true;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  DateTime _dateTime = DateTime.now();

  endTrip(String toll) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String idL = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    print("user_login_token-" + idL);
    API
        .driverEndRide(id, idL, widget.searchList["new_ride_id"].toString(),
            lat, lan, disanceController.text, toll)
        .then((response) {
      EasyLoading.dismiss();
      print(response.body);
      var jVar = jsonDecode(response.body);
      print(jVar);
      if (jVar["status"] == 200) {
        if (json.decode(response.body)['chk'] == 1) {
          var searchList = json.decode(response.body)['data'];
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DriverCollectCashPage(searchList: searchList,)));
        }
      } else {
        Fluttertoast.showToast(
            msg: "No Data",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPos();
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

  late String lat = "";
  late String lan = "";

  Future<void> getPos() async {
    print("curPos");
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    }
    LOCATION().getCountryName().then((value) async {
      String con = value[2];
      print(value);
      setState(() {
        lat = value[0].toString();
        lan = value[1].toString();
      });
    });
  }

  Future<void> getEPos() async {
    print("curPos");
    final GoogleMapController controller = await _controllerGoogleMap.future;
    var markerIdVal = "2";
    final MarkerId markerId = MarkerId(markerIdVal);
  }

  _addPolyLine() {
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
              initialCameraPosition:
                  CameraPosition(target: LatLng(25.5941, 85.1376), zoom: 15),
              //markers: Set.from(_markers),
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              markers: Set<Marker>.of(markers.values),
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
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
                  // height: MediaQuery.of(context).size.height/2.8,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                              bottomRight: Radius.circular(20.0),
                            )),
                      ),
                      SizedBox(
                        width: 350.0,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0,10,10,10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Drop Off",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Divider(
                            height: 10,
                            color: Colors.grey,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child:
                       widget.show_driver_km? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              "Travel  Distance",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            )),
                            Expanded(
                              child: TextField(
                                controller: disanceController,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.number,
                                decoration: new InputDecoration.collapsed(
                                  hintText: "Enter Distance",
                                  hintStyle: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 18.0,
                                  ),
                                ),
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.black),
                              ),
                            )
                          ],
                        ):SizedBox(),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Divider(
                            height: 10,
                            color: Colors.grey,
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30,10,10,10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Text(
                                  "Toll/Parking",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                Text(
                                  "(Optinal)",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                              ],
                            )),
                            Expanded(
                              child: TextField(
                                controller: tollOpController,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.number,
                                decoration: new InputDecoration.collapsed(
                                  hintText: "Enter Amount",
                                  hintStyle: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 18.0,
                                  ),
                                ),
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Divider(
                            height: 10,
                            color: Colors.grey,
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30,10,10,10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Text(
                                  "Toll/Parking",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                Text(
                                  "(Confirm)",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                              ],
                            )),
                            Expanded(
                              child: TextField(
                                controller: tollCompController,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.number,
                                decoration: new InputDecoration.collapsed(
                                  hintText: "Enter Amount",
                                  hintStyle: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 18.0,
                                  ),
                                ),
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 8, left: 24, right: 24),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: RaisedButton(
                            child: Text(
                              "Confirm",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            color: Colors.black,
                            elevation: 5,
                            textColor: Colors.white,
                            onPressed: () {
                              if (tollOpController.text.toString() !=
                                      tollCompController.text.toString()) {
                                Fluttertoast.showToast(
                                    msg: "Please fill amount",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                if (tollOpController.text.isEmpty) {
                                  endTrip("0");
                                } else {
                                  endTrip(tollOpController.text);
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
