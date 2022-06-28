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
import 'package:rodbez/Customer/cus_offer_page.dart';
import 'package:selectable_container/selectable_container.dart';
import 'package:rodbez/Customer/cus_search_page.dart';

import '../map_utils.dart';
import 'cus_schedule_page.dart';

// import 'accept_widget.dart';

class CustomerCabSelectPage extends StatefulWidget {
  CustomerCabSelectPage({required this.searchList,required this.exclusive_offers,required this.start_address,required this.start_lat,required this.start_long,
    required this.end_address,required this.end_lat,required this.end_long});
  final List<dynamic> searchList;
  var exclusive_offers;
  final String start_address;
  final String start_lat;
  final String start_long;
  final String end_address;
  final String end_lat;
  final String end_long;
  @override
  CustomerCabSelectPageState createState() => CustomerCabSelectPageState();
}

class CustomerCabSelectPageState extends State<CustomerCabSelectPage> {
  late CameraPosition _initialPosition;
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  var geoLocator = Geolocator();
  late BitmapDescriptor pinLocationIcon;
  String driverStatusText = "Inactive ";

  bool rClicked = false;
  bool wClicked = false;
  bool qClicked = false;
  bool tClicked = false;
  int cabIndex = -1;
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
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/marker.png');
  }

  static const colorizeColors = [
    // Colors.green,
    Colors.black,
    Colors.red,
    Colors.grey,
    Colors.white,
    Colors.red,
  ];

  static const colorizeTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'Horizon',
    overflow: TextOverflow.ellipsis
  );
  late CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.7041, 77.1025),
    zoom: 10,
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
              padding: const EdgeInsets.fromLTRB(0,0,0,320),
              child: GoogleMap(
                polylines: Set<Polyline>.of(polylines.values),
                initialCameraPosition: CameraPosition(target: LatLng(25.5941, 85.1376), zoom: 10),
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
          "color": "#959595"
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
                  // height: MediaQuery.of(context).size.height/1.69,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("One-Way Ride", style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold),),
                              Text("Get drop off", style: TextStyle(color: Colors.black, fontSize: 16,))
                            ],),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 10,right: 10),
                          child: Divider(height: 10,color: Colors.grey,)),
                      widget.exclusive_offers["has_offer"]?Padding(
                        padding: const EdgeInsets.only(top: 8,bottom: 8,left: 16,right: 16),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomerOfferPage (exclusive_offers: widget.exclusive_offers,
                                      origin_place: widget.start_address,origin_lat: widget.start_lat,origin_long: widget.start_long,
                                      destination_place: widget.end_address,destination_lat: widget.end_lat,destination_long: widget.end_long,)));

                          },
                          child: Container(
                            height: 55,
                            // width: MediaQuery.of(context).size.width/1.0,
                            decoration: BoxDecoration(
                              color:Colors.green[100],
                              borderRadius: BorderRadius.circular(5.0),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.grey,
                              //     offset: Offset(0.0,0.0),
                              //     blurRadius: 3.0,
                              //     spreadRadius: 1.0,
                              //   ),
                              // ],
                            ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20,0,0,0),
                                child: Row(
                                  children: [
                                    Image.asset("assets/offer.png", width: 45,height:45),
                                    SizedBox(width: 5,),
                                    Flexible(
                                      child: AnimatedTextKit(
                                        animatedTexts: [
                                          ColorizeAnimatedText(widget.exclusive_offers["offer_text"],
                                            textStyle: colorizeTextStyle,
                                            colors: colorizeColors,
                                          ),
                                        ],
                                        isRepeatingAnimation: true,
                                      ),
                                    ),
                                    SizedBox(width: 20,),
                                    Icon(Icons.arrow_forward_ios_sharp),
                                  ],
                                ),
                              ),
                              // textColor: Colors.black,color: Colors.white,
                          ),
                        ),
                      ):SizedBox(),
                      Container(
                        height: (media.height/2)-170,
                        // height: 360,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Container(
                              // height: 360,
                              // height: requestRideContainerHeight,
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) => RequestPage()));
                                        // resetApp();
                                      },
                                      child: SizedBox(
                                        width: 350.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    widget.searchList[0]!=null? GestureDetector(
                                      onTap: ()
                                      {
                                        setState(() {
                                          rClicked = !rClicked;
                                          wClicked = false;
                                          qClicked = false;
                                          cabIndex = 0;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Container(
                                          height: 85,
                                          width: MediaQuery.of(context).size.width/1.1,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 1,
                                                    child: SizedBox(
                                                      child: Image.network(
                                                        widget.searchList[0]["cab_icon"],
                                                        height: 50,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          widget.searchList[0]["cab_type"],
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                        Text(
                                                          widget.searchList[0]["luggage_text"],
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.grey,
                                                            fontWeight: FontWeight.w300,
                                                          ),
                                                        ),
                                                        Text(
                                                          widget.searchList[0]["available_text"],
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: widget.searchList[0]["available_status"]?Colors.green:Colors.red,
                                                            fontWeight: FontWeight.w300,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment.center,
                                                          child: Text(
                                                            '₹ '+widget.searchList[0]["cost"],
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                        rClicked? Container(
                                                          height: 24.0,
                                                          width: 24.0,
                                                          margin: EdgeInsets.only(top:7),
                                                          decoration: BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius: BorderRadius.circular(30.0),
                                                            // border: Border.all(width: 2.0, color: Colors.grey[300]),
                                                          ),
                                                          child: Icon(Icons.check, size: 20.0,color: Colors.white,),
                                                          // child: RaisedButton(
                                                          //   shape: new RoundedRectangleBorder(
                                                          //     borderRadius: new BorderRadius.circular(24.0),
                                                          //   ),
                                                          //   onPressed: (){
                                                          //     Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPage()));
                                                          //   },
                                                          //
                                                          // ),
                                                        ):SizedBox(height: 24,),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          // constraints: BoxConstraints(minWidth: 100, maxHeight: 200),
                                          decoration: BoxDecoration(
                                            color:Colors.white,
                                            borderRadius: BorderRadius.circular(rClicked?7.0:0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: rClicked?Colors.grey:Colors.white,
                                                offset: Offset(0.5,0.5),
                                                blurRadius: rClicked?1.0:0.0,
                                                spreadRadius: 0.5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ):SizedBox(),
                                    SizedBox(
                                      height: 15.0,
                                    ),

                                    widget.searchList[1]!=null? GestureDetector(
                                      onTap: ()
                                      {
                                        setState(() {
                                          rClicked = false;
                                          wClicked = !wClicked;
                                          qClicked = false;
                                          cabIndex = 1;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Container(
                                          height: 85,
                                          width: MediaQuery.of(context).size.width/1.1,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 1,
                                                    child: SizedBox(
                                                      child: Image.network(
                                                        widget.searchList[1]["cab_icon"],
                                                        height: 50,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          widget.searchList[1]["cab_type"],
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                        Text(
                                                          widget.searchList[1]["luggage_text"],
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.grey,
                                                            fontWeight: FontWeight.w300,
                                                          ),
                                                        ),
                                                        Text(
                                                          widget.searchList[1]["available_text"],
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: widget.searchList[1]["available_status"]?Colors.green:Colors.red,
                                                            fontWeight: FontWeight.w300,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment.center,
                                                          child: Text(
                                                            '₹ '+widget.searchList[1]["cost"],
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                        wClicked?Container(
                                                          height: 24.0,
                                                          width: 24.0,
                                                          margin: EdgeInsets.only(top:7),
                                                          decoration: BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius: BorderRadius.circular(30.0),
                                                            // border: Border.all(width: 2.0, color: Colors.grey[300]),
                                                          ),
                                                          child: Icon(Icons.check, size: 20.0,color: Colors.white,),
                                                          // child: RaisedButton(
                                                          //   shape: new RoundedRectangleBorder(
                                                          //     borderRadius: new BorderRadius.circular(24.0),
                                                          //   ),
                                                          //   onPressed: (){
                                                          //     Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPage()));
                                                          //   },
                                                          //
                                                          // ),
                                                        ):SizedBox(height: 24,),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          // constraints: BoxConstraints(minWidth: 100, maxHeight: 200),
                                          decoration: BoxDecoration(
                                            color:Colors.white,
                                            borderRadius: BorderRadius.circular(wClicked?10.0:0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: wClicked?Colors.grey:Colors.white,
                                                offset: Offset(0.0,0.0),
                                                blurRadius: wClicked? 1.0:0.0,
                                                spreadRadius: 0.5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ):SizedBox(),
                                    SizedBox(
                                      height: 15.0,
                                    ),

                                    widget.searchList[2]!=null? GestureDetector(
                                      onTap: ()
                                      {
                                        setState(() {
                                          rClicked = false;
                                          wClicked = false;
                                          qClicked = !qClicked;
                                          cabIndex = 2;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Container(
                                          height: 85,
                                          width: MediaQuery.of(context).size.width/1.1,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 1,
                                                    child: SizedBox(
                                                      child: Image.network(
                                                        widget.searchList[2]["cab_icon"],
                                                        height: 50,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          widget.searchList[2]["cab_type"],
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                        Text(
                                                          widget.searchList[2]["luggage_text"],
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.grey,fontWeight: FontWeight.w300,
                                                          ),
                                                        ),
                                                        Text(
                                                          widget.searchList[2]["available_text"],
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: widget.searchList[2]["available_status"]?Colors.green:Colors.red,
                                                            fontWeight: FontWeight.w300,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment.center,
                                                          child: Text(
                                                            '₹ '+widget.searchList[2]["cost"],
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                        qClicked?Container(
                                                          height: 24.0,
                                                          width: 24.0,
                                                          margin: EdgeInsets.only(top:7),
                                                          decoration: BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius: BorderRadius.circular(30.0),
                                                            // border: Border.all(width: 2.0, color: Colors.grey[300]),
                                                          ),
                                                          child: Icon(Icons.check, size: 20.0,color: Colors.white,),
                                                          // child: RaisedButton(
                                                          //   shape: new RoundedRectangleBorder(
                                                          //     borderRadius: new BorderRadius.circular(24.0),
                                                          //   ),
                                                          //   onPressed: (){
                                                          //     Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPage()));
                                                          //   },
                                                          //
                                                          // ),
                                                        ):SizedBox(height: 20,),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          // constraints: BoxConstraints(minWidth: 100, maxHeight: 200),
                                          decoration: BoxDecoration(
                                            color:Colors.white,
                                            borderRadius: BorderRadius.circular(qClicked?10.0:0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: qClicked?Colors.grey:Colors.white,
                                                offset: Offset(0.0,0.0),
                                                blurRadius: qClicked?1.0:0.0,
                                                spreadRadius: 0.5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ):SizedBox(),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    // Container(
                                    //   width: double.infinity,
                                    //   child: Text("Cancel Ride", textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0),),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8,bottom: 8,left: 24,right: 24),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: RaisedButton(
                            child: Text("Review Booking", style: TextStyle(fontSize: 16,color: Colors.white),),
                            color: Colors.black,
                            elevation: 5,
                            textColor: Colors.white,
                            onPressed: () {
                              if(rClicked || wClicked || qClicked){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CustomerSchedulePage (searchList:widget.searchList,cabIndex: cabIndex,start_address: widget.start_address,
                                          start_lat: widget.start_lat,start_long: widget.start_long,end_lat: widget.end_lat,end_long: widget.end_long,
                                          end_address: widget.end_address,)));
                              }else{
                                Fluttertoast.showToast(
                                    msg: "Please select cab",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }

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