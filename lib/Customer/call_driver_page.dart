import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'arrived_page.dart';
// import 'end_page.dart';

// import 'accept_widget.dart';

class CallDriverPage extends StatefulWidget {
  static const String idScreen = "MainImageWidget";
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(25.5941, 85.1376),
    zoom: 14.4746,
  );
  // static const String idScreen = "mainScreen";
  @override
  _ArrivedPageState createState() => _ArrivedPageState();
}

class _ArrivedPageState extends State<CallDriverPage> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;

  var geoLocator = Geolocator();
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String driverStatusText = "Inactive ";

  Color driverStatusColor = Colors.red;
  void onMapCreated(GoogleMapController controller) {
    // _controller.complete(controller);
    controller.setMapStyle('''
    
    ''');
  }
  bool isDriverAvailable = true;
  DateTime _dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationButtonEnabled: false,
              initialCameraPosition: CallDriverPage._kGooglePlex,
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller)
              {
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
                // locatePosition();
              },
            ),

            //online offline driver Container
            Container(
              height: 140.0,
              width: double.infinity,
              // color: Colors.black87,
            ),

            // Positioned(
            //   top: 30.0,
            //   left: 220.0,
            //   right: 0.0,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [

            Padding(
              padding: const EdgeInsets.fromLTRB(270,0,0,645),
              child: Center(
                // child: Container(
                //   height: 45.0,
                //   width: 110.0,
                //   child: RaisedButton(
                //     shape: new RoundedRectangleBorder(
                //       borderRadius: new BorderRadius.circular(24.0),
                //     ),
                //     onPressed: () {
                //       if (isDriverAvailable != null) {
                //         // makeDriverOnlineNow();
                //         // getLocationLiveUpdates();
                //
                //         setState(() {
                //           driverStatusColor = Colors.green;
                //           driverStatusText = "Active";
                //           isDriverAvailable = true;
                //         });
                //
                //         // displayToastMessage("You are Online Now.", context);
                //       }
                //       else {
                //         // makeDriverOfflineNow();
                //
                //         setState(() {
                //           driverStatusColor = Colors.red;
                //           driverStatusText = "Inactive";
                //           isDriverAvailable = true;
                //         });
                //
                //         // displayToastMessage("You are Offline Now.", context);
                //       }
                //     },
                //     color: driverStatusColor,
                //     child: Padding(
                //       padding: const EdgeInsets.fromLTRB(0,0,0,0),
                //       // child: Row(
                //       //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       //   children: [
                //       child:Text(driverStatusText, style: TextStyle(
                //           fontSize: 15.0,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.white),),
                //       // Icon(Icons.phone_android, color: Colors.white, size: 26.0,),
                //     ),
                //   ),
                // ),
              ),
            ),



            SingleChildScrollView(
              child: Positioned(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0,410,0,0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0),),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 0.2,
                          blurRadius: 9.0,
                          color: Colors.black54,
                          offset: Offset(0.9, 0.9),
                        ),
                      ],
                    ),
                    // child: Padding(
                    //   padding: const EdgeInsets.fromLTRB(0,0,0,0),
                    //   child: Container(
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0),),
                    //   color: Colors.white,
                    //   boxShadow: [
                    //     BoxShadow(
                    //       spreadRadius: 0.5,
                    //       blurRadius: 16.0,
                    //       color: Colors.black54,
                    //       offset: Offset(0.7, 0.7),
                    //     ),
                    //   ],
                    // ),
                    // height: requestRideContainerHeight,


                    child:Column(
                      children: [
                        SizedBox(height: 10.0),
                        Container(
                          height: 13.0,
                          width: 75.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius:
                            BorderRadius.circular(10.0),
                            border: Border.all(
                                width: 1.0,
                                color: Colors.white),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(
                                      0, 0, 0, 10),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(
                                      0, 15, 0, 0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0,20,200,0),
                              child: Text("You Have Arrived ", style: TextStyle(fontSize: 18.0, color: Colors.black,fontWeight: FontWeight.bold),),
                            ),
                            Text("ID RodBez", style: TextStyle(fontSize: 15.0, color: Colors.grey),),
                          ],
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  // color: Colors.blue[900],
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(width: 0.0, color: Colors.grey),
                                  boxShadow: [
                                    BoxShadow(
                                      spreadRadius: 0.1,
                                      blurRadius: 2.0,
                                      color: Colors.grey,
                                      offset: Offset(0.5, 0.5),
                                    ),
                                  ],
                                  // image: DecorationImage( scale: 1,alignment: Alignment.centerLeft,
                                  //   image: AssetImage("assets/pinn.png",),
                                  // ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 200,
                                        // width: 320,
                                        decoration: BoxDecoration(
                                          color: Colors.green[100],
                                          borderRadius: BorderRadius.circular(5.0),
                                          border: Border.all(width: 0.0, color: Colors.white),
                                          // image: DecorationImage( scale: 1,alignment: Alignment.centerLeft,
                                          //   image: AssetImage("assets/pinn.png",),
                                          // ),
                                        ),
                                        child: Column(
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Text("Mini Cab", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),),

                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(20,0,10,0),
                                              child: Column(
                                                children: [
                                                  // Text("Mini Cap", style: TextStyle(fontSize: 23.0, color: Colors.black),),
                                                  // Text("cab id", style: TextStyle(fontSize: 18.0, color: Colors.black45),),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: 80.0,
                                                              width: 80.0,
                                                              decoration: BoxDecoration(
                                                                color: Colors.black,
                                                                borderRadius: BorderRadius.circular(60.0),
                                                                // border: Border.all(width: 2.0, color: Colors.grey[300]),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors.grey.shade500,
                                                                    offset: Offset(0.0,0.0),
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
                                                              // child: Image.asset('assets/pinn.png',  height: 10.3, width: 10.3,),
                                                              child: Padding(
                                                                padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                                                child: Icon(Icons.person, size: 49.0,color: Colors.white,),
                                                              ),
                                                              // ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(40,10,00,0),
                                                        child: Row(
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: <Widget>[
                                                                // Icon(Icons.circle,color: Colors.green,size: 10,),
                                                                Align(
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Padding(
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        0, 0, 0, 0),
                                                                    child: Text(
                                                                      "Anand kumar",textAlign: TextAlign.right,
                                                                      style: TextStyle(
                                                                          fontSize: 18.0,
                                                                          color: Colors
                                                                              .black,fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      10, 0, 0, 0),
                                                                  child: Text(
                                                                    "Your Caption For This Ride",
                                                                    style: TextStyle(
                                                                        fontSize: 16.0,
                                                                        color: Colors
                                                                            .green[100]),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(180,0,0,0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                              child: Container(
                                                                height: 60.0,
                                                                width: 60.0,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.circular(60.0),
                                                                  // border: Border.all(width: 2.0, color: Colors.grey[300]),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors.grey.shade500,
                                                                      offset: Offset(0.0,0.0),
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
                                                                // child: Image.asset('assets/pinn.png',  height: 10.3, width: 10.3,),
                                                                child: Icon(Icons.navigation, size: 30.0,color: Colors.red,),
                                                                // ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(40, 10, 0, 0),
                                                              child: Container(
                                                                height: 60.0,
                                                                width: 60.0,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.circular(60.0),
                                                                  // border: Border.all(width: 2.0, color: Colors.grey[300]),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors.grey.shade500,
                                                                      offset: Offset(0.0,0.0),
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
                                                                // child: Image.asset('assets/pinn.png',  height: 10.3, width: 10.3,),
                                                                // child: Icon(Icons.call, size: 30.0,color: Colors.white,),
                                                                child: IconButton(icon: new Icon(Icons.phone,size: 30,color: Colors.green,),
                                                                  onPressed: ()
                                                                  {
                                                                    setState(() {
                                                                      _makePhoneCall('tel:7004330440');
                                                                    });
                                                                  },
                                                                ),
                                                                // ),
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
                                            // Padding(
                                            //   padding: const EdgeInsets.fromLTRB(130,30,0,0),
                                            //   child: Container(
                                            //     height: 60,
                                            //     width: 230,
                                            //     child: Positioned(
                                            //       bottom: MediaQuery.of(context).viewInsets.bottom,
                                            //       left: 0,
                                            //       right: 30,
                                            //       child: Padding(
                                            //         padding: const EdgeInsets.fromLTRB(30,0,0,0),
                                            //         child: ConfirmationSlider(
                                            //           height: 60,
                                            //           text: 'Call Caption',
                                            //           textStyle: TextStyle(
                                            //             fontWeight: FontWeight.bold,
                                            //             color: Colors.blue[900],
                                            //             fontSize: 16,
                                            //           ),
                                            //           shadow: BoxShadow(
                                            //             color: Colors.black45,
                                            //             // offset: Offset(0,0),
                                            //             blurRadius: 3.0,
                                            //             // spreadRadius: 1.0,
                                            //           ),
                                            //           foregroundColor: Colors.black,
                                            //           onConfirmation: (){
                                            //             // Navigator.push(context,
                                            //             //     MaterialPageRoute(builder: (context) => EndTripPage()));
                                            //           },
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Divider(),
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                      child: Container(
                                        height: 80,
                                        // width: 320,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(5.0),
                                          border: Border.all(width: 0.0, color: Colors.white),
                                          // image: DecorationImage( scale: 1,alignment: Alignment.centerLeft,
                                          //   image: AssetImage("assets/pinn.png",),
                                          // ),
                                        ),
                                        child: Column(
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Text("Mini Cab", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(10,10,00,0),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.circle,color: Colors.green,size: 10,),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .fromLTRB(
                                                        20, 0, 0, 0),
                                                    child: Text(
                                                      "Saharsa Bihar India 852212",
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          color: Colors
                                                              .grey),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(10,0,10,0),
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                                child: Divider(),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(10,0,00,0),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.circle,color: Colors.red,size: 10,),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .fromLTRB(
                                                        20, 0, 0, 0),
                                                    child: Text(
                                                      "Saharsa Bihar India 852212",
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          color: Colors
                                                              .grey),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15,0,0,0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0,5,20,0),
                                      child: Icon(Icons.date_range, color: Colors.black, size: 23.0,),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0,05,50,0),
                                      child: Text(
                                        '${_dateTime.day}/${_dateTime.month}/${_dateTime.year}, ${_dateTime.hour}:${_dateTime.minute}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(height: 10.0,),
                              // Divider(
                              //   // color: Colors.black,
                              // ),
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 220,
                                      // width: 320,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(5.0),
                                        border: Border.all(width: 0.0, color: Colors.grey),
                                        boxShadow: [
                                          BoxShadow(
                                            spreadRadius: 0.1,
                                            blurRadius: 2.0,
                                            color: Colors.grey,
                                            offset: Offset(0.5, 0.5),
                                          ),
                                        ],
                                        // image: DecorationImage( scale: 1,alignment: Alignment.centerLeft,
                                        //   image: AssetImage("assets/pinn.png",),
                                        // ),
                                      ),
                                      child: Column(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Text("Mini Cab", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(10,10,00,0),
                                            child: Row(
                                              children: [
                                                // Icon(Icons.circle,color: Colors.green,size: 10,),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .fromLTRB(
                                                      5, 5, 0, 0),
                                                  child: Text(
                                                    "Estimated Fare",
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors
                                                            .black,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .fromLTRB(
                                                      150, 5, 0, 0),
                                                  child: Text(
                                                    "2000",
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors
                                                            .black,fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(10,0,0,0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .fromLTRB(
                                                      5, 5, 0, 0),
                                                  child: Text(
                                                    "Distance 125 km, Time 4 hr",
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors
                                                          .grey,),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(10,0,00,0),
                                            child: Row(
                                              children: [
                                                // Icon(Icons.circle,color: Colors.red,size: 10,),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .fromLTRB(
                                                      5, 0, 0, 0),
                                                  child: Text(
                                                    "Ride Fare",
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors
                                                            .grey),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .fromLTRB(
                                                      210, 0, 0, 0),
                                                  child: Text(
                                                    "1800",
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors
                                                            .grey),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(10,0,00,0),
                                            child: Row(
                                              children: [
                                                // Icon(Icons.circle,color: Colors.red,size: 10,),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .fromLTRB(
                                                      5, 0, 0, 0),
                                                  child: Text(
                                                    "RodBez Fee",
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors
                                                            .grey),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .fromLTRB(
                                                      200, 0, 0, 0),
                                                  child: Text(
                                                    "100",
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors
                                                            .grey),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(10,0,00,0),
                                            child: Row(
                                              children: [
                                                // Icon(Icons.circle,color: Colors.red,size: 10,),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .fromLTRB(
                                                      5, 0, 0, 0),
                                                  child: Text(
                                                    "Taxes",
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors
                                                            .grey),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .fromLTRB(
                                                      245, 0, 0, 0),
                                                  child: Text(
                                                    "100",
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors
                                                            .grey),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(10,0,00,0),
                                            child: Row(
                                              children: [
                                                // Icon(Icons.circle,color: Colors.red,size: 10,),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .fromLTRB(
                                                      5, 0, 0, 0),
                                                  child: Text(
                                                    "Total Payout",
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors
                                                            .black54),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .fromLTRB(
                                                      190, 0, 0, 0),
                                                  child: Text(
                                                    "2000",
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors
                                                            .black54),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets
                                        .fromLTRB(
                                        15, 0, 0, 0),
                                    child: Text(
                                      "Your Caption",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors
                                              .black,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Padding(
                                padding: EdgeInsets.all(0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 200,
                                      // width: 320,
                                      decoration: BoxDecoration(
                                        color: Colors.blue[50],
                                        borderRadius: BorderRadius.circular(5.0),
                                        border: Border.all(width: 0.0, color: Colors.white),
                                        // image: DecorationImage( scale: 1,alignment: Alignment.centerLeft,
                                        //   image: AssetImage("assets/pinn.png",),
                                        // ),
                                      ),
                                      child: Column(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Text("Mini Cab", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),),

                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(20,0,10,0),
                                            child: Column(
                                              children: [
                                                // Text("Mini Cap", style: TextStyle(fontSize: 23.0, color: Colors.black),),
                                                // Text("cab id", style: TextStyle(fontSize: 18.0, color: Colors.black45),),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height: 80.0,
                                                            width: 80.0,
                                                            decoration: BoxDecoration(
                                                              color: Colors.black,
                                                              borderRadius: BorderRadius.circular(60.0),
                                                              // border: Border.all(width: 2.0, color: Colors.grey[300]),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors.grey.shade500,
                                                                  offset: Offset(0.0,0.0),
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
                                                            // child: Image.asset('assets/pinn.png',  height: 10.3, width: 10.3,),
                                                            child: Padding(
                                                              padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                                              child: Icon(Icons.person, size: 49.0,color: Colors.white,),
                                                            ),
                                                            // ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.fromLTRB(40,10,00,0),
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: <Widget>[
                                                              // Icon(Icons.circle,color: Colors.green,size: 10,),
                                                              Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Padding(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      0, 0, 0, 0),
                                                                  child: Text(
                                                                    "Suraj Meshera",textAlign: TextAlign.right,
                                                                    style: TextStyle(
                                                                        fontSize: 18.0,
                                                                        color: Colors
                                                                            .black,fontWeight: FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    10, 0, 0, 0),
                                                                child: Text(
                                                                  "Your Caption For This Ride",
                                                                  style: TextStyle(
                                                                      fontSize: 16.0,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(180,0,0,0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                            child: Container(
                                                              height: 60.0,
                                                              width: 60.0,
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(60.0),
                                                                // border: Border.all(width: 2.0, color: Colors.grey[300]),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors.grey.shade500,
                                                                    offset: Offset(0.0,0.0),
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
                                                              // child: Image.asset('assets/pinn.png',  height: 10.3, width: 10.3,),
                                                              child: Icon(Icons.message_outlined, size: 30.0,color: Colors.blue,),
                                                              // ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.fromLTRB(40, 10, 0, 0),
                                                            child: Container(
                                                              height: 60.0,
                                                              width: 60.0,
                                                              decoration: BoxDecoration(
                                                                color: Colors.green,
                                                                borderRadius: BorderRadius.circular(60.0),
                                                                // border: Border.all(width: 2.0, color: Colors.grey[300]),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors.grey.shade500,
                                                                    offset: Offset(0.0,0.0),
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
                                                              // child: Image.asset('assets/pinn.png',  height: 10.3, width: 10.3,),
                                                              // child: Icon(Icons.call, size: 30.0,color: Colors.white,),
                                                              child: IconButton(icon: new Icon(Icons.phone,size: 30,color: Colors.white,),
                                                                onPressed: ()
                                                                {
                                                                  setState(() {
                                                                    _makePhoneCall('tel:7004330440');
                                                                  });
                                                                },
                                                              ),
                                                              // ),
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
                                          // Padding(
                                          //   padding: const EdgeInsets.fromLTRB(130,30,0,0),
                                          //   child: Container(
                                          //     height: 60,
                                          //     width: 230,
                                          //     child: Positioned(
                                          //       bottom: MediaQuery.of(context).viewInsets.bottom,
                                          //       left: 0,
                                          //       right: 30,
                                          //       child: Padding(
                                          //         padding: const EdgeInsets.fromLTRB(30,0,0,0),
                                          //         child: ConfirmationSlider(
                                          //           height: 60,
                                          //           text: 'Call Caption',
                                          //           textStyle: TextStyle(
                                          //             fontWeight: FontWeight.bold,
                                          //             color: Colors.blue[900],
                                          //             fontSize: 16,
                                          //           ),
                                          //           shadow: BoxShadow(
                                          //             color: Colors.black45,
                                          //             // offset: Offset(0,0),
                                          //             blurRadius: 3.0,
                                          //             // spreadRadius: 1.0,
                                          //           ),
                                          //           foregroundColor: Colors.black,
                                          //           onConfirmation: (){
                                          //             // Navigator.push(context,
                                          //             //     MaterialPageRoute(builder: (context) => EndTripPage()));
                                          //           },
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 150,)
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
              padding: const EdgeInsets.fromLTRB(0,760,0,0),
              child: Container(
                // bottom: MediaQuery.of(context).viewInsets.bottom,
                // left: 40,
                // right: 50,
                // height: 140,
                alignment: Alignment.bottomCenter,

                color: Colors.black87,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ConfirmationSlider(
                    text: '   Start Trip',
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 20,
                    ),
                    shadow: BoxShadow(
                      color: Colors.black45,
                      // offset: Offset(0,0),
                      blurRadius: 3.0,
                      // spreadRadius: 1.0,
                    ),
                    foregroundColor: Colors.black,
                    onConfirmation: (){
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => EndTripPage()));
                    },
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => ArrivedPage()));
                // cancelRideRequest();
                // resetApp();
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
                        offset: Offset(0.0,0.0),
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
                  child: Icon(Icons.arrow_back, size: 22.0,color: Colors.black,),
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
