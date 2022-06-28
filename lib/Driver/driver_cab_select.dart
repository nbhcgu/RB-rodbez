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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rodbez/api/http_service.dart';

import '../map_utils.dart';

class DriverCabSelect extends StatefulWidget {
  DriverCabSelect(
      {required this.searchList,
      required this.start_address,
      required this.start_lat,
      required this.start_long,
      required this.end_address,
      required this.end_lat,
      required this.end_long});

  final List<dynamic> searchList;
  final String start_address;
  final String start_lat;
  final String start_long;
  final String end_address;
  final String end_lat;
  final String end_long;

  @override
  DriverCabSelectState createState() => DriverCabSelectState();
}

class DriverCabSelectState extends State<DriverCabSelect> {
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
  }

  getDetails() async {
    if(cabIndex==-1){
      Fluttertoast.showToast(
          msg: "Please select cab",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }else
    {
      EasyLoading.show();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String id = prefs.getString('id') ?? "0";
      String idL = prefs.getString('user_login_token') ?? "0";
      print("user_id-" + id);
      print("user_login_token-" + idL);
      API.searchRideDetails(id, idL, widget.searchList[cabIndex]["ride_id"].toString()).then((response) {
        EasyLoading.dismiss();
        print(response.body);
        var jVar = jsonDecode(response.body);
        print(jVar);
        if (jVar["status"] == 200) {
          if(json.decode(response.body)['chk']==1) {
            var searchList = json.decode(response.body)['data'];
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DriverAcceptRidePage(searchList: searchList)));
          }
        }else{
          Fluttertoast.showToast(
              msg: "No Data",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
      });
    }
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
                getPos();
                getEPos();
              },
            ),
            // markers.clear();
            //
            //     // markers.add(Marker(markerId: MarkerId('currentLocation'),position: LatLng(position.latitude, position.longitude)));

            //online offline driver Container

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
                  // height: media.height / 1,
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
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "One-Way Ride",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text("Confirm Ride",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                  ))
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
                      SingleChildScrollView(
                        child: Container(
                          height: 300,
                          // height: 360,
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: widget.searchList.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        cabIndex = index;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        // height: MediaQuery.of(context).size.height/5,
                                        width: MediaQuery.of(context)
                                                .size
                                                .width /
                                            1.2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child: SizedBox(
                                                    child: widget
                                                            .searchList[
                                                                index][
                                                                "cab_icon"]
                                                            .toString()
                                                            .isEmpty
                                                        ? Image.asset(
                                                            'assets/non veg.png',
                                                            alignment:
                                                                Alignment
                                                                    .bottomRight,
                                                            height:
                                                                70.0,
                                                            width: 70.0,
                                                          )
                                                        : Image.network(
                                                            widget.searchList[
                                                                    0][
                                                                "cab_icon"],
                                                            height: 70,
                                                            width: 70,
                                                          ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        widget.searchList[
                                                                index][
                                                            "cab_type"],
                                                        textAlign:
                                                            TextAlign
                                                                .left,
                                                        style: TextStyle(
                                                            fontSize:
                                                                16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        widget.searchList[
                                                                index][
                                                            "display_date"],
                                                        textAlign:
                                                            TextAlign
                                                                .left,
                                                        style: TextStyle(
                                                            fontSize:
                                                                14,
                                                            color: Colors
                                                                .grey),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment
                                                                .center,
                                                        child: Text(
                                                          '₹ ' +
                                                              widget.searchList[
                                                                      index]
                                                                  [
                                                                  "amount"],
                                                          textAlign:
                                                              TextAlign
                                                                  .center,
                                                          style:
                                                              TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                            fontSize:
                                                                16,
                                                          ),
                                                        ),
                                                      ),
                                                      cabIndex == index
                                                          ? Container(
                                                              height:
                                                                  24.0,
                                                              width:
                                                                  24.0,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 7),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .black,
                                                                borderRadius:
                                                                    BorderRadius.circular(30.0),
                                                                // border: Border.all(width: 2.0, color: Colors.grey[300]),
                                                              ),
                                                              child:
                                                                  Icon(
                                                                Icons
                                                                    .check,
                                                                size:
                                                                    20.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )
                                                          : SizedBox(
                                                              height:
                                                                  24,
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Padding(
                                                padding: const EdgeInsets.all(0),
                                                child: Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 1.2,
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Icon(
                                                            Icons.circle,
                                                            color: Colors.black,
                                                            size: 15,
                                                          ),
                                                          // Container(
                                                          //     height: 20,
                                                          //     child: VerticalDivider(
                                                          //       width: 1,
                                                          //       color: Colors.grey,
                                                          //     )),
                                                          // Icon(
                                                          //   Icons.circle,
                                                          //   color: Colors.red,
                                                          //   size: 10,
                                                          // ),
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
                                                                    padding:
                                                                    const EdgeInsets.fromLTRB(
                                                                        20, 0, 0, 0),
                                                                    child: Text(
                                                                      widget
                                                                          .searchList[index]["place_caption"]
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize: 16.0,
                                                                          color: Colors.grey,
                                                                        fontWeight: FontWeight.w300,),
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
                                            // Padding(
                                            //   padding: const EdgeInsets.all(8.0),
                                            //   child: Container(
                                            //     decoration: BoxDecoration(
                                            //       borderRadius: BorderRadius.circular(10),
                                            //       color: Colors.white,
                                            //       boxShadow: [
                                            //         BoxShadow(
                                            //           spreadRadius: 0.0,
                                            //           blurRadius: 0.0,
                                            //           color: Colors.black54,
                                            //           offset: Offset(0.0, 0.0),
                                            //         ),
                                            //       ],
                                            //     ),
                                            //     child:
                                            //     widget.searchList[index][
                                            //             "place_caption_status"]
                                            //         ?
                                            //     Text(
                                            //             widget.searchList[
                                            //                     index][
                                            //                 "place_caption"],
                                            //             style: TextStyle(
                                            //                 color: Colors
                                            //                     .black,
                                            //                 fontSize: 14),
                                            //           )
                                            //         : SizedBox(),
                                            //   ),
                                            // )
                                          ],
                                        ),
                                        // constraints: BoxConstraints(minWidth: 100, maxHeight: 200),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(
                                                  cabIndex == index
                                                      ? 10.0
                                                      : 0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: cabIndex == index
                                                  ? Colors.grey
                                                  : Colors.white,
                                              offset: Offset(0.0, 0.0),
                                              blurRadius:
                                                  cabIndex == index
                                                      ? 3.0
                                                      : 0.0,
                                              spreadRadius: 1.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 8, left: 24, right: 24),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: RaisedButton(
                            child: Text(
                              "Review Booking",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            color: Colors.black,
                            elevation: 5,
                            textColor: Colors.white,
                            onPressed: () {
                              getDetails();
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
