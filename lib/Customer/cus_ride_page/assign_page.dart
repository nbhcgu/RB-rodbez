import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rodbez/Customer/cus_ride_page/cancel_action_page.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:rodbez/Customer/cus_home_page.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'accept_widget.dart';

class CustomerAssignPage extends StatefulWidget {
  static const String idScreen = "MainImageWidget";
  late GoogleMapController googleMapController;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(25.5941, 85.1376),
    zoom: 16.4746,
  );
  CustomerAssignPage(
      {required this.id,required this.list_type, required this.is_started});
  final String id;
  final String list_type;
  final bool is_started;
  // static const String idScreen = "mainScreen";
  @override
  _ArrivedPageState createState() => _ArrivedPageState();
}

class _ArrivedPageState extends State<CustomerAssignPage> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;
  late GoogleMapController googleMapController;
  late BitmapDescriptor driverLocationIcon,userLocationIcon;

  var geoLocator = Geolocator();

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  String id = "",rideId="",sPlace="",ePlace="",date="",cab="",cab_icon="",cabData="",cabSeat="",fare="",baseFare="",taxes="",status="",
      msg="",serEx="",serExImg="",serExNo="",fare_caption="",driver_heading_text="",driver_icon="",driver_name="",rating_text="",
      cab_number="",driver_number="",tax_text="",fare_heading="",base_fare_text="",request_type="";
  var rules=[], inc=[];
  bool can_cancel = false,tax_status=false;
  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idu = prefs.getString('id') ?? "0";
    String idL = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + idu);
    print("user_login_token-" + idL);
    API.rideDetails(idu, idL, widget.id,widget.list_type).then((response) {
      setState(() {
        var jVar = jsonDecode(response.body);
        print("kkkkk3"+response.body);
        if (jVar["status"] == 200) {
          var data = jVar["data"];
          getTrack(data["driver_details"]["driver_id"]);
          setState((){
            id = data["ride_id"].toString();
            print("iiiiiii"+id);
            if(widget.is_started){
              dlat= data["destination_lat"];
              dlan = data["destination_long"];
              getEPos(dlat, dlan, "1");
             // _addPolyLine();
            }
            driver_heading_text = data["driver_details"]["driver_heading_text"].toString();
            driver_icon = data["driver_details"]["driver_icon"].toString();
            driver_name = data["driver_details"]["driver_name"].toString();
            rating_text = data["driver_details"]["rating_text"].toString();
            cab_number = data["driver_details"]["cab_number"].toString();
            driver_number = data["driver_details"]["driver_number"].toString();
            rideId = data["display_id"].toString();
            request_type = data["request_type"].toString();
            sPlace = data["start_location"].toString();
            ePlace = data["end_location"].toString();
            date = data["ride_date"].toString();
            cab = data["cab_type"].toString();
            status = data["status"].toString();
            cab_icon = data["cab_icon"].toString();
            cabData = data["cab_type_caption"].toString();
            cabSeat = data["cab_luggage_text"].toString();
            fare = data["fare_details"]["fare_amount"].toString();
            fare_caption = data["fare_details"]["fare_caption"].toString();
            baseFare = data["fare_details"]["base_fare_amount"].toString();
            taxes = data["fare_details"]["tax_amount"].toString();
            tax_text = data["fare_details"]["tax_text"].toString();
            fare_heading = data["fare_details"]["fare_heading"].toString();
            base_fare_text = data["fare_details"]["base_fare_text"].toString();
            tax_status = data["fare_details"]["tax_status"];
            msg = data["status_message"].toString();
            serEx = data["executive_name"].toString();
            serExNo = data["executive_number"].toString();
            serExImg = data["executive_image"].toString();
            rules = data["rules_contents"];
            inc = data["inclusion_contents"];
            can_cancel = data["can_cancel"];
          });
        }
      });
    });
  }
  bool isFirst = true;
  late CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.7041, 77.1025),
    zoom: 15,
  );
  @override
  void initState() {
    print("999999");
    setCustomMapPin();
    _getData();
  }
  String driverStatusText = "Inactive ";

  Color driverStatusColor = Colors.red;

  void onMapCreated(GoogleMapController controller) {
    // _controller.complete(controller);
    controller.setMapStyle('''
    
   ''');
  }
  void setCustomMapPin() async {

    driverLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/car.png');
    userLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/marker.png');
  }
  @override
  dispose(){
    driverSub.cancel();
    userSub.cancel();
  }

  late String ulat = "";
  late String ulan = "";
  late String dlat = "";
  late String dlan = "";
  late StreamSubscription userSub,driverSub;
  bool isDriverAvailable = true;
  DateTime _dateTime = DateTime.now();
  getTrack(String did) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  String id = prefs.getString('id') ?? "0";
    userSub = FirebaseDatabase.instance
        .ref()
        .child('users_loc')
        .child("uid" + id)
        .onChildChanged
        .listen((event) {
      var data = event.snapshot.value;
      var key = event.snapshot.key;
      if(key=="lat"){
        ulat=data.toString();
      }else if(key=="long"){
        ulan=data.toString();
      }
      getEPos(ulat, ulan, "2");
      _addPolyLine();
      print("eventValue");
      print(data);
      print(key);
    });

    driverSub = FirebaseDatabase.instance
        .ref()
        .child('users_loc')
        .child("uid" + did)
        .onChildChanged
        .listen((event) {
      var data = event.snapshot.value;
      var key = event.snapshot.key;
      if(!widget.is_started){
        if(key=="lat"){
          print("eventValue666");
          print(data);
          dlat=data.toString();
        }else if(key=="long"){
          dlan=data.toString();
        }
        getEPos(dlat, dlan, "1");
        _addPolyLine();
        print(key);
      }
    });
    print("users_loc/""uid" + id);
    DatabaseReference ub = FirebaseDatabase.instance
        .ref()
        .child('users_loc')
        .child("uid" + id);
    DataSnapshot event = await ub.get();
    print(event.value);
    getUB(event);
    print("users_loc/""did" + did);
    DatabaseReference db = FirebaseDatabase.instance
        .ref()
        .child('users_loc')
        .child("uid" + did);
    event = await db.get();
    if(!widget.is_started){
      getDB(event);
    }
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
  _addPolyLine() {
      List<LatLng> polylineCoordinates = [];
      print("Poly:"+"{"+dlat+"}"+"{"+dlan+"}");
      print("Poly:"+"{"+ulat+"}"+"{"+ulan+"}");
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
  }
  Map<PolylineId, Polyline> polylines = {};
  Future<void> getEPos(String lat, String lan, String mk) async {
    print("curPos");
    final GoogleMapController controller = await _controllerGoogleMap.future;
    var markerIdVal = mk;
    final MarkerId markerId = MarkerId(markerIdVal);
    // creating a new MARKER
    final Marker marker = mk=="2" ?Marker(
        markerId: markerId,
        icon: userLocationIcon,
        position: LatLng(double.parse(lat),double.parse(lan))
    ):widget.is_started?Marker(
        markerId: markerId,
        position: LatLng(double.parse(lat),double.parse(lan))
    ):Marker(
        markerId: markerId,
        icon: driverLocationIcon,
        position: LatLng(double.parse(lat),double.parse(lan))
    );
    _kGooglePlex = CameraPosition(
      target: LatLng(double.parse(lat),double.parse(lan)),
      zoom: 14,
    );
    setState(() {
      markers[markerId] = marker;
      if(mk=="2" && isFirst){
        isFirst = false;
        controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
      }
    });
  }
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            GoogleMap(
              //mapType: MapType.hybrid,
              polylines: Set<Polyline>.of(polylines.values),
              // trafficEnabled: true,
              initialCameraPosition: _kGooglePlex,
              myLocationButtonEnabled: false,
              // myLocationEnabled: true,
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
              bottom: 0,
              left:0,right:0,
              top:500,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 0.2,
                          blurRadius: 5.0,
                          color: Colors.black54,
                          offset: Offset(0.9, 0.9),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.0),
                        Center(
                          child: Container(
                            height: 13.0,
                            width: 75.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10.0),
                              border:
                                  Border.all(width: 1.0, color: Colors.white),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 20, 20, 0),
                              child: Text(
                                driver_heading_text,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "Ride ID "+rideId,
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      spreadRadius: 0.1,
                                      blurRadius: 3.0,
                                      color: Colors.grey,
                                      offset: Offset(0.9, 0.9),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 240,
                                        // width: 320,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          border: Border.all(
                                              width: 0.0, color: Colors.white),
                                          // image: DecorationImage( scale: 1,alignment: Alignment.centerLeft,
                                          //   image: AssetImage("assets/pinn.png",),
                                          // ),
                                        ),
                                        child: Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding:EdgeInsets.only(left: 10,top: 20),
                                                  child: Center(
                                                      child: driver_icon.isEmpty?Icon(Icons.account_circle_rounded,color: Colors.black,size: 80,):
                                                          CircleAvatar(radius:30,backgroundImage: NetworkImage(driver_icon))
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left:8.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                    SizedBox(height: 20,),
                                                    Text(driver_name, style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black)),
                                                    SizedBox(height: 10,),
                                                    Text("Rating- "+rating_text, style:TextStyle(fontSize: 18,color: Colors.black45)),
                                                    SizedBox(height: 10,),
                                                      GestureDetector(
                                                        onTap: (){
                                                          final Uri launchUri = Uri(
                                                            scheme: 'tel',
                                                            path: driver_number,
                                                          );
                                                          launchUrl(launchUri);
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          margin: EdgeInsets.only(top:5),
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(50.0),
                                                            border: Border.all(width: 1.0, color: Colors.black),
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
                                                                width:50,height:30,
                                                                // decoration: BoxDecoration(
                                                                //   color: Colors.white,
                                                                //   borderRadius: BorderRadius.circular(0.0),
                                                                // ),
                                                                margin: EdgeInsets.only(left:0,right:0),
                                                                child: SizedBox(
                                                                    child: Icon(Icons.call,color: Colors.green,size: 20,)
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(right:15.0),
                                                                child: Text("Call Driver", style: TextStyle(color: Colors.black, fontSize: 16),),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 20,),
                                                  ],),
                                                )
                                              ],
                                            ),
                                            Column(
                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: SizedBox(
                                                      child: cab_icon.isEmpty?Image.asset("assets/non veg.png",width: 70,height: 70):
                                                      Image.network(cab_icon,width: 70,height: 70,),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right:8.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                    SizedBox(height: 20,),
                                                    Text(cab, style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black)),
                                                    SizedBox(height: 10,),
                                                    Text(cab_number, style:TextStyle(fontSize: 18,color: Colors.black45)),
                                                    SizedBox(height: 80,),
                                                  ],),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 24.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5.0,0,0,0),
                                    child: Text(
                                      'Your Captain for this Ride',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
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
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  serEx,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(height: 10,),
                                                GestureDetector(
                                                  onTap: (){
                                                    final Uri launchUri = Uri(
                                                      scheme: 'tel',
                                                      path: serExNo,
                                                    );
                                                    launchUrl(launchUri);
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: 150,
                                                    margin: EdgeInsets.only(top:5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(50.0),
                                                      border: Border.all(width: 1.0, color: Colors.black),
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
                                                          width:30,height:30,
                                                          decoration: BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius: BorderRadius.circular(50.0),
                                                          ),
                                                          margin: EdgeInsets.only(left:5,right:10),
                                                          child: SizedBox(
                                                              child: Icon(Icons.call,color: Colors.yellow,size: 20,)
                                                          ),
                                                        ),
                                                        Flexible(child: FittedBox(child: Text("Call Captain", style: TextStyle(color: Colors.black, fontSize: 16),)))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: serExImg.isEmpty?Icon(Icons.account_circle_rounded,color: Colors.black,size: 80,):
                                            CircleAvatar(radius:30,backgroundImage: NetworkImage(serExImg)),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              Container(
                                // height: MediaQuery.of(context).size.height/8,
                                width: MediaQuery.of(context).size.width / 1.1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              fare_heading,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                '₹ '+fare,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 16,
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
                                              fare_caption,
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
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              base_fare_text,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[800],
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                '₹ '+baseFare,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[800],
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                     tax_status? Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              tax_text,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[800],
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                '₹ '+taxes,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[800],
                                                  fontWeight: FontWeight.w300,
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
                                height: 30,
                              ),
                              can_cancel?GestureDetector(
                                onTap: () async {
                                  print("iiiiiii"+id);
                                  bool chk = await  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CancelActionPage(id: id,rideId: rideId,isUser: true,request_type:request_type)));
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
                                  width: MediaQuery.of(context).size.width/1.1,
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
                                          padding: EdgeInsets.only(left: 20),
                                          child: Text(
                                            'Cancel Ride',
                                            style: TextStyle(
                                                color: Colors.black, fontSize: 16.0),
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
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomerHomePage()));
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
          ],
        ),
      ),
    );
  }
}
