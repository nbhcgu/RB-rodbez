import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'dart:io';

// import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lct;
import 'package:rodbez/Customer/cus_ride_page/cancel_action_page.dart';
import 'package:rodbez/Customer/cus_search_page.dart';
import 'package:rodbez/Driver/driver_cab_select.dart';
import 'package:rodbez/Driver/driver_drop_off.dart';
import 'package:rodbez/Driver/driver_search_city.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:rodbez/login/login_page.dart';
import 'package:rodbez/map_utils.dart';
import 'package:rodbez/utils/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'home_page.dart';
class DriverRideConfirmedPage extends StatefulWidget {
  static const String idScreen = "SearchPage";
  DriverRideConfirmedPage({required this.searchList, required this.status_type});
  var searchList;
  final int status_type;
  @override
  DriverRideConfirmedPageState createState() => DriverRideConfirmedPageState();
}

class DriverRideConfirmedPageState extends State<DriverRideConfirmedPage>
    with SingleTickerProviderStateMixin {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController googleMapController;
  Map<PolylineId, Polyline> polylines = {};
  bool can_cancel = false;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  late lct.Location location;
  late BitmapDescriptor icon;
  late String address = "";
  late String lat = "";
  late String lan = "";
  late String ulat = "";
  late String ulan = "";
  late String dlat = "";
  late String dlan = "";
  DateTime _dateTime = DateTime.now();
  List data = [];
  var details;
  int indexChk = 0;
  String btnText = "You Have Arrived";
  bool show_driver_km = false,isStart=false;
  late StreamSubscription driverSub;
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
  late BitmapDescriptor driverLocationIcon,userLocationIcon;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.7041, 77.1025),
    zoom: 15,
  );

  Future<void> openMap(
      ) async{
    if(indexChk<2){
      String googleMapUrl = "https://www.google.com/maps/dir/?api=1&origin=${dlat},${dlan}&destination=${ulat},${ulan}&travelmode=driving&dir_action=navigate";

      if(await canLaunch(googleMapUrl)){
        await launch(googleMapUrl);
      }else{
        throw 'Could not open the Map';
      }
    } else{
      String googleMapUrl = "https://www.google.com/maps/dir/?api=1&origin=${dlat},${dlan}&destination=${details["destination_lat"]},${details["destination_long"]}&travelmode=driving&dir_action=navigate";

      if(await canLaunch(googleMapUrl)){
        await launch(googleMapUrl);
      }else{
        throw 'Could not open the Map';
      }
    }
  }

  void setCustomMapPin() async {
    driverLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/car.png');
    userLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/marker.png');
  }

  arrivedRide() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String idL = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    print("user_login_token-" + idL);
    API.driverArrivedRide(
        id, idL, details["new_ride_id"].toString(),lat,lan).then((
        response) {
      EasyLoading.dismiss();
      print(response.body);
      var jVar = jsonDecode(response.body);
      print(jVar);
      if (jVar["status"] == 200) {
        if (json.decode(response.body)['chk'] == 1) {
          var searchList = json.decode(response.body)['data'];
          setState((){
             btnText = "Start Trip";
             details["status_text"] = searchList["status_text"];
            indexChk++;
          });
          Fluttertoast.showToast(
              msg: details["status_text"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
          )
          ;
        }
      } else {
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
  startRide() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String idL = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    print("user_login_token-" + idL);
    API.driverStartRide(
        id, idL, details["new_ride_id"].toString(),lat,lan).then((
        response) {
      EasyLoading.dismiss();
      print(response.body);
      var jVar = jsonDecode(response.body);
      print(jVar);
      if (jVar["status"] == 200) {
        if (json.decode(response.body)['chk'] == 1) {
          var searchList = json.decode(response.body)['data'];
          show_driver_km = searchList["show_driver_km"];
          setState((){
            isStart = true;
            btnText = "End Trip";
            details["status_text"] = searchList["status_text"];
            indexChk++;
            getEPos(details["destination_lat"], details["destination_long"], "2");
          });
          Fluttertoast.showToast(
              msg: details["status_text"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
          )
          ;
        }
      } else {
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
 getTrack() async {
    print("rrr567"+details["user_id"]);
   //  userSub = FirebaseDatabase.instance
   //     .ref()
   //     .child('users_loc')
   //     .child("uid" + details["user_id"])
   //     .onChildChanged
   //     .listen((event) {
   //    if(!isStart) {
   //      var data = event.snapshot.value;
   //      var key = event.snapshot.key;
   //      if (key == "lat") {
   //        ulat = data.toString();
   //      } else if (key == "long") {
   //        ulan = data.toString();
   //      }
   //      getEPos(ulat, ulan, "2");
   //      _addPolyLine();
   //      print("eventValue");
   //      print(data);
   //      print(key);
   //    }
   // });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    driverSub = FirebaseDatabase.instance
       .ref()
       .child('users_loc')
       .child("uid" + id)
       .onChildChanged
       .listen((event) {
        var data = event.snapshot.value;
        var key = event.snapshot.key;
        if(key=="lat"){
          dlat=data.toString();
        }else if(key=="long"){
          dlan=data.toString();
        }
        getEPos(dlat, dlan, "1");
        _addPolyLine();
        print("eventValue");
        print(data);
        print(key);
   });
    print("users_loc/""uid" + details["user_id"]);
    DatabaseReference ub = FirebaseDatabase.instance
        .ref()
        .child('users_loc')
        .child("uid" + details["user_id"]);
    DataSnapshot event = await ub.get();
    print(event.value);
   // if(!isStart){getUB(event);}
    print("users_loc/""did" + id);
    DatabaseReference db = FirebaseDatabase.instance
        .ref()
        .child('users_loc')
        .child("uid" + id);
    event = await db.get();
    getDB(event);

 }
  getUB(DataSnapshot event){
    var list = jsonDecode(jsonEncode(event.value));
    ulat=list["lat"].toString();
    ulan=list["long"].toString();
    getEPos(ulat, ulan, "2");
    print("eventValue");
    print(list);
  }
  getDB(DataSnapshot event){
    var list = jsonDecode(jsonEncode(event.value));
    dlat=list["lat"].toString();
    dlan=list["long"].toString();
    getEPos(dlat, dlan, "1");
    _addPolyLine();
    print("eventValue");
    print(list);
  }
  @override
  dispose(){
    driverSub.cancel();
    //userSub.cancel();
  }
  @override
  void initState() {
    setCustomMapPin();
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    details = widget.searchList;
    ulat= details["origin_lat"];
    ulan = details["origin_long"];
    if(widget.status_type==5){
      setState((){
        indexChk++;
        btnText = "Start Trip";
      });
    }
    if(widget.status_type==6){
      setState((){
        ulat= details["destination_lat"];
        ulan = details["destination_long"];
        isStart=true;
        indexChk++;
        indexChk++;
        btnText = "End Trip";
      });
    }

    getEPos(ulat, ulan, "2");
    getRiderSelf();
    getPos();
    getTrack();
    print("chk_status"+widget.status_type.toString());

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
      setState(() {
        controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
      });
    });
  }
  Future<void> getEPos(String lat, String lan, String mk) async {
    print("curPos");
    final GoogleMapController controller = await _controllerGoogleMap.future;
    var markerIdVal = mk;
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER
    final Marker marker = mk=="1"?Marker(
        markerId: markerId,
        icon: driverLocationIcon,
        position: LatLng(double.parse(lat),double.parse(lan))
    ):isStart?Marker(
        markerId: markerId,
        position: LatLng(double.parse(lat),double.parse(lan))
    ):Marker(
        markerId: markerId,
        position: LatLng(double.parse(lat),double.parse(lan))
    );
    _kGooglePlex = CameraPosition(
      target: LatLng(double.parse(lat),double.parse(lan)),
      zoom: 15,
    );
    setState(() {
      markers[markerId] = marker;
      if(mk=="1" && isFirst){
        isFirst = false;
        controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
      }
    });
  }
  bool isFirst = true;
  var geoLocator = Geolocator();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDriverAvailable = true;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(25.5941, 85.1376), zoom: 15);
  _addPolyLine() {
   if(indexChk<2){
     List<LatLng> polylineCoordinates = [];
     polylineCoordinates.add(new LatLng(double.parse(dlat), double.parse(dlan)));
     polylineCoordinates.add(new LatLng(double.parse(ulat), double.parse(ulan)));
     PolylineId id = PolylineId("poly");
     Polyline polyline = Polyline(
         polylineId: id,
         color: Colors.black,
         points: polylineCoordinates,
         width: 2);
     setState(() {
       polylines[id] = polyline;
     });
   }else{
     List<LatLng> polylineCoordinates = [];
     polylineCoordinates.add(new LatLng(double.parse(dlat), double.parse(dlan)));
     polylineCoordinates.add(new LatLng(double.parse(details["destination_lat"]), double.parse(details["destination_long"])));
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
  }
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        child: Stack(
          children: [
            GoogleMap(
              //mapType: MapType.hybrid,
              polylines: Set<Polyline>.of(polylines.values),
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
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
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
                  child: SingleChildScrollView(
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
                            child: Text(details["status_text"], style: TextStyle(color: Colors.green,fontSize: 16,fontWeight: FontWeight.bold),)),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(details["display_id"], style: TextStyle(color: Colors.grey,fontSize: 16),)),
                        SizedBox(height: 20,),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.grey[50]
                          ),
                          child: Column(
                            children: [
                              Row(children: [
                                Expanded(
                                  flex: 1,
                                  child:
                                  Align(alignment: Alignment.topLeft,child:
                                  SizedBox(
                                    child: details["user_image"].toString().isEmpty? Icon(Icons.account_circle_rounded,color: Colors.black,size: 50,):
                                    CircleAvatar(radius: 25,backgroundImage: NetworkImage(details["user_image"].toString()),),),),
                                ),
                                Text(details["user_name"].toString(), style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),)
                              ],),
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
                                                        padding:
                                                        const EdgeInsets.fromLTRB(
                                                            20, 0, 0, 0),
                                                        child: Text(
                                                          details["start_location"].toString(),
                                                          style: TextStyle(
                                                              fontSize: 18.0,
                                                              color: Colors.grey,
                                                              overflow: TextOverflow.ellipsis),maxLines: 2,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 20.0, top: 10, bottom: 10),
                                                  child: Divider(),
                                                ),
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
                                                          details["end_location"].toString(),
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              color: Colors.grey,
                                                          overflow: TextOverflow.ellipsis),maxLines: 2,
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
                              GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
                                              child: Icon(Icons.calendar_month,
                                                  color: Colors.black, size: 24.0),
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.fromLTRB(0, 05, 10, 0),
                                                child: Text(
                                                  details["ride_date"].toString(),
                                                  style: TextStyle(
                                                      fontSize: 14.0, color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          final Uri launchUri = Uri(
                                            scheme: 'tel',
                                            path: details["user_mobile"].toString(),
                                          );
                                          launchUrl(launchUri);
                                        },
                                        child: Container(
                                          height: 40,
                                          // width: 150,
                                          margin: EdgeInsets.only(top: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(50.0),
                                            border: Border.all(
                                                width: 1.0,
                                                color: Colors.green),
                                            boxShadow: [
                                              BoxShadow(
                                                spreadRadius: 0.1,
                                                blurRadius: 2.0,
                                                color: Colors.grey,
                                                offset: Offset(0.5, 0.5),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  // color: Colors.green,
                                                  // borderRadius:
                                                  // BorderRadius.circular(50.0),
                                                  // border: Border.all(
                                                  //     width: 1.0,
                                                  //     color: Colors.white),
                                                  // boxShadow: [
                                                  //   BoxShadow(
                                                  //     spreadRadius: 0.1,
                                                  //     blurRadius: 2.0,
                                                  //     // color: Colors.grey,
                                                  //     offset: Offset(0.5, 0.5),
                                                  //   ),
                                                  // ],
                                                ),
                                                margin: EdgeInsets.only(
                                                    left: 5, right: 10),
                                                child: SizedBox(
                                                    child: Icon(
                                                      Icons.call,
                                                      color: Colors.green,
                                                      size: 30,
                                                    )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 12.0),
                                                child: Text(
                                                  "Call Rider",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            // height: MediaQuery.of(context).size.height/8,
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            details["cab_type"].toString(),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            details["cab_type_caption"].toString(),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w300,
                                              ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        child: details["cab_icon"].toString().isEmpty?Image.asset('assets/non veg.png', alignment: Alignment.bottomRight, height: 50.0, width: 50.0,):
                                        Image.network(details["cab_icon"].toString(),width: 50,height: 50,),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // constraints: BoxConstraints(minWidth: 100, maxHeight: 200),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        details["fare_details"]["fare_heading"],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: FittedBox(
                                          child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text(
                                              '₹ ' + details["fare_details"]["fare_amount"].toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        details["fare_details"]["fare_caption"].toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        details["fare_details"]["base_fare_text"],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: FittedBox(
                                            child: Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                '₹ ' + details["fare_details"]["base_fare_amount"].toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[800],
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                details["fare_details"]["tax_status"]?  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        details["fare_details"]["tax_text"],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: FittedBox(
                                            child: Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                '₹ ' + details["fare_details"]["tax_amount"].toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[800],
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ):SizedBox(),
                              ],
                            ),
                          ),
                          // constraints: BoxConstraints(minWidth: 100, maxHeight: 200),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: Text(
                                    'Your captain for this ride',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            details["executive_name"].toString(),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          GestureDetector(
                                            onTap: () {
                                              final Uri launchUri = Uri(
                                                scheme: 'tel',
                                                path: details["executive_number"].toString(),
                                              );
                                              launchUrl(launchUri);
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 150,
                                              margin: EdgeInsets.only(top: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.circular(50.0),
                                                border: Border.all(
                                                    width: 1.0,
                                                    color: Colors.black),
                                                boxShadow: [
                                                  BoxShadow(
                                                    spreadRadius: 0.1,
                                                    blurRadius: 2.0,
                                                    color: Colors.grey,
                                                    offset: Offset(0.5, 0.5),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                      BorderRadius.circular(50.0),
                                                      border: Border.all(
                                                          width: 1.0,
                                                          color: Colors.black),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          spreadRadius: 0.1,
                                                          blurRadius: 2.0,
                                                          color: Colors.grey,
                                                          offset: Offset(0.5, 0.5),
                                                        ),
                                                      ],
                                                    ),
                                                    margin: EdgeInsets.only(
                                                        left: 5, right: 10),
                                                    child: SizedBox(
                                                        child: Icon(
                                                          Icons.call,
                                                          color: Colors.yellow,
                                                          size: 30,
                                                        )),
                                                  ),
                                                  Text(
                                                    "Call Captain",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: SizedBox(
                                        child: details["executive_image"].toString().isEmpty?Icon(Icons.account_circle_rounded,color: Colors.black,size: 50,):
                                        CircleAvatar(radius: 25,backgroundImage: NetworkImage(details["executive_image"].toString()),),),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        can_cancel ?GestureDetector(
                          onTap: () async {
                            bool chk = await  Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CancelActionPage(id: details["ride_id"],rideId: details["display_id"],isUser: false,request_type:details["request_type"])));
                            if(chk!=null){
                              if(chk){
                                setState((){
                                  can_cancel = false;
                                });
                              }
                            }
                          },
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                                border: Border.all(color: Colors.grey, width: 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 24),
                                    child: Text(
                                      'Cancel Ride',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 16.0),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 20.0,
                                  width: 20.0,
                                  margin: EdgeInsets.only(right: 24),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(30.0),
                                    // border: Border.all(width: 2.0, color: Colors.grey[300]),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    size: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ):SizedBox(),
                        SizedBox(
                          height: 20.0,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 8,bottom: 8,left: 0,right: 0),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            child: RaisedButton(
                              child: Text(btnText, style: TextStyle(fontSize: 16,color: Colors.white),),
                              color: Colors.black,
                              elevation: 5,
                              textColor: Colors.white,
                              onPressed: () {
                                if(indexChk==0){
                                  arrivedRide();
                                }else if(indexChk==1){
                                  startRide();
                                }else{
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DriverDropOff(searchList: details, show_driver_km: show_driver_km,)));
                                };
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
              child: Container(

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
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
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 45.0,
                child: Row(
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
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20,right: 10),
                                child: Icon(
                                  Icons.circle,
                                  color: Colors.green,
                                  size: 10,
                                ),
                              ),
                              Text(address.length>25?address.substring(0,25)+"...":address,maxLines: 1,
                                softWrap: false, overflow: TextOverflow.fade,style: TextStyle(fontSize: 16,color: Colors.black),),
                            ],
                          ),
                          GestureDetector(
                            onTap: (){
                              openMap();
                            },
                            child: Icon(
                              Icons.navigation,
                              color: Colors.red,
                              size: 30,
                            ),
                          )
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
    );
  }
}
