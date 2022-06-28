import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lct;
import 'package:rodbez/Customer/cus_search_page.dart';
import 'package:rodbez/Driver/driver_cab_select.dart';
import 'package:rodbez/Driver/driver_search_city.dart';
import 'package:rodbez/Driver/driver_service_not_page.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:rodbez/login/login_page.dart';
import 'package:rodbez/utils/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'home_page.dart';

class DriverFindRidePage extends StatefulWidget {
  static const String idScreen = "SearchPage";
  // static const String idScreen = "mainScreen";
       DriverFindRidePage(
      {required this.selected_Place});
  var selected_Place;
  @override
  DriverFindRidePageState createState() => DriverFindRidePageState();
}

class DriverFindRidePageState extends State<DriverFindRidePage>
    with SingleTickerProviderStateMixin {
  final _startSearchFieldController = TextEditingController();
  final _endSearchFieldController = TextEditingController();
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController googleMapController;
  late lct.Location location;
  late BitmapDescriptor icon;
  late String address = "";
  late String lat = "";
  late String lan = "";
  DateTime _dateTime = DateTime.now();
  DateTime _curTime = DateTime.now();
  List data = [];
  var selected_Place;
  bool isActive = true;List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  late BitmapDescriptor pinLocationIcon;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.7041, 77.1025),
    zoom: 15,
  );

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/car.png');
  }

//crear Marker
  Set<Marker> _createMarker() {
    var marker = Set<Marker>();
    marker.add(Marker(
      markerId: MarkerId("MarkerCurrent"),
      // position: currentLocation,
      icon: icon,
      draggable: true,
      // onDragEnd: onDragEnd,
    ));

    return marker;
  }

  late String rider_name = "", rider_contact = "";

  getRiderSelf() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rider_name = prefs.getString('user_name') ?? "";
      rider_contact = prefs.getString('user_mobile') ?? "";
    });
  }

  selfSearch() async {
    if(selected_Place==null){
      Fluttertoast.showToast(
          msg: "Please select place",
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
      API.selfSearchDriver(id, idL, selected_Place["origin_place"],selected_Place["origin_lat"],selected_Place["origin_long"],
          selected_Place["destination_place"],selected_Place["destination_lat"],
          selected_Place["destination_long"],selected_Place["origin_id"],selected_Place["destination_id"],selected_Place["location_type"]).then((response) {
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
                        DriverCabSelect(searchList: searchList,
                          start_lat: selected_Place["origin_lat"],
                          start_long: selected_Place["origin_long"],
                          start_address: selected_Place["origin_place"],
                          end_lat: selected_Place["destination_lat"],
                          end_long: selected_Place["destination_long"],
                          end_address: selected_Place["location_type"],)));
          }else{
            var dt = json.decode(response.body)['data'];
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DriverServiceNotPage(message: dt["message"],
                            caption: dt["caption"],
                            start_lat: selected_Place["origin_lat"],
                            start_long: selected_Place["origin_long"],
                            start_address: selected_Place["origin_place"],
                            end_lat: selected_Place["destination_lat"],
                            end_long: selected_Place["destination_long"],
                            end_address: selected_Place["destination_place"],
                            cab_icon: dt["cab_icon"],
                            cab_type: dt["cab_type"],
                            date: '${_dateTime.day} ${months[_dateTime.month - 1]}, ${_dateTime.hour}:${_dateTime.minute}',
                        )));
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
  @override
  void initState() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    selected_Place = widget.selected_Place;
    getRiderSelf();
    setCustomMapPin();
    getPos();
  }

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
        data = value;
        print(data[2]);
        address = data[2];
        lat = data[0].toString();
        lan = data[1].toString();
      });
      _kGooglePlex = CameraPosition(
        target: LatLng(data[0], data[1]),
        zoom: 15,
      );
      final GoogleMapController controller = await _controllerGoogleMap.future;
      var markerIdVal = "1";
      final MarkerId markerId = MarkerId(markerIdVal);

      // creating a new MARKER
      final Marker marker =
          Marker(markerId: markerId,
              icon: pinLocationIcon,
              position: LatLng(value[0], value[1]));
      setState(() {
        controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
        // adding a new marker to map
        markers[markerId] = marker;
      });
    });
  }

  var geoLocator = Geolocator();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDriverAvailable = true;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(25.5941, 85.1376), zoom: 15);

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,350),
              child: GoogleMap(
                //mapType: MapType.hybrid,
                // trafficEnabled: true,
                initialCameraPosition: _kGooglePlex,
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _controllerGoogleMap.complete(controller);
                  googleMapController = controller;
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
                },
                markers: Set<Marker>.of(markers.values),
              ),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 0.1,
                      blurRadius: 2.0,
                      offset: Offset(0.9, 0.9),
                    ),
                  ],
                ),
                // height: requestRideContainerHeight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15,bottom: 15,right: 24,left: 24),
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
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
                      SizedBox(height: 20,),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text("Find Rider", style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),)),
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: ()  {

                        },
                        child: Container(
                          height: 50,
                          child: Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: Colors.green,
                                size: 15,
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Text(selected_Place==null?"Search Pickup City":selected_Place["origin_place"],
                                    style: TextStyle(fontSize: 16, color: Colors.black45,)
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.search,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                          color: Colors.grey
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> DriverSearchCity(cur_address: address,
                              cur_lat: lat,cur_long: lan)));
                        },
                        child: Container(
                          height: 50,
                          child: Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: Colors.red,
                                size: 15,
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Text(selected_Place==null?"Search Destination City":selected_Place["destination_place"],
                                      style: TextStyle(fontSize: 16, color: Colors.black45,)
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.search,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text("Date and Time", style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),)),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '${_dateTime.day} ${months[_dateTime.month - 1]}, ${_dateTime.hour}:${_dateTime.minute}',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black54),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height/5,
                        child: CupertinoDatePicker(
                            initialDateTime: _dateTime,
                            use24hFormat: false,
                            minuteInterval: 1,
                            onDateTimeChanged: (dateTime) {
                              print(dateTime);
                              setState(() {
                                _dateTime = dateTime;
                              });
                            }),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 8,bottom: 8,left: 5,right: 5),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: RaisedButton(
                            child: Text("Confirm", style: TextStyle(fontSize: 16,color: Colors.white),),
                            color: Colors.black,
                            elevation: 5,
                            textColor: Colors.white,
                            onPressed: () async {
                              if(_dateTime.isAfter(_curTime)){
                                selfSearch();
                              }else{
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                String msg = prefs.getString('date_error_message') ?? "";
                                Fluttertoast.showToast(
                                    msg: msg,
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
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 45.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50.0),
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
                            child: Icon(
                              Icons.arrow_back,
                              size: 30.0,
                              color: Colors.black,
                            ))),
                    // GestureDetector(
                    //   onTap: () {
                    //     setState((){
                    //       isActive = !isActive;
                    //     });
                    //   },
                    //   child: Container(
                    //     padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    //     decoration: BoxDecoration(
                    //       color: isActive?Colors.green:Colors.red,
                    //       borderRadius: BorderRadius.circular(55.0),
                    //       // border: Border.all(width: 2.0, color: Colors.grey[300]),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.grey.shade500,
                    //           offset: Offset(0.0, 0.0),
                    //           blurRadius: 0.0,
                    //           spreadRadius: 0.0,
                    //         ),
                    //       ],
                    //     ),
                    //     child: Text(
                    //      isActive? "Active":"InActive",
                    //       maxLines: 1,
                    //       softWrap: false,
                    //       overflow: TextOverflow.fade,
                    //       style: TextStyle(fontSize: 16, color: Colors.white),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
