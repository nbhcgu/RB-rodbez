import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'dart:io';

// import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lct;
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rodbez/Customer/cus_home_page.dart';
import 'package:rodbez/Driver/driver_find_ride_page.dart';
import 'package:rodbez/Driver/driver_offers_page.dart';
import 'package:rodbez/Driver/driver_profile_setting.dart';
import 'package:rodbez/Driver/driver_search_city.dart';
import 'package:rodbez/Driver/driver_your_ride_page.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:rodbez/login/login_page.dart';
import 'package:rodbez/utils/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'home_page.dart';

class DriverPage extends StatefulWidget {
  static const String idScreen = "SearchPage";

  // static const String idScreen = "mainScreen";
  @override
  DriverPageState createState() => DriverPageState();
}

class DriverPageState extends State<DriverPage>
    with SingleTickerProviderStateMixin {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController googleMapController;
  late lct.Location location;
  late BitmapDescriptor icon;
  late String address = "";
  late String lat = "";
  late String lan = "";
  late String clat = "";
  late String clan = "";
  List data = [];
  bool isActive = true;
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
  late String rider_name="",rider_contact="",rider_img="",user_type="",bannerImg = "",uId = "",status = "",cab_number="";
  getRiderSelf() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      uId = prefs.getString('id') ?? "0";
      rider_name = prefs.getString('user_name') ?? "";
      rider_contact = prefs.getString('user_mobile') ?? "";
      cab_number = prefs.getString('cab_number') ?? "";
      rider_img = prefs.getString('disp_image') ?? "";
      bannerImg = prefs.getString('banner_img') ?? "";
      user_type = prefs.getString('user_type') ?? "";
      status = prefs.getString('status') ?? "";
      if(status=="pending"){
        setState((){isActive=false;});
      }
    });
  }
  @override
  void initState() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    setCustomMapPin();
    getRiderSelf();
    getPos();
    getData();
  }

  Future<void> getLoc() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    DatabaseReference ub = FirebaseDatabase.instance
        .ref()
        .child('users_loc').child("app_setting").child("date");
    DatabaseEvent event = await ub.once();
    String dtVal = event.snapshot.value.toString();
    print(dtVal);
    location.onLocationChanged.listen((LocationData currentLocation) async {
      print("longitude1: ${currentLocation.longitude} ${currentLocation.latitude}");
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      print("longitude2: ${currentLocation.longitude} ${currentLocation.latitude}");
      if(clat != currentLocation.latitude.toString() && clan != currentLocation.longitude.toString()){
        clat = currentLocation.latitude.toString();
        clan = currentLocation.longitude.toString();
        ref.child('users_loc').child(dtVal)
            .child("uid" + uId).set({"lat": currentLocation.latitude, "long": currentLocation.longitude, "timestamp": DateTime.now().millisecondsSinceEpoch}).onError((error, stackTrace) => print(error));
        ref.child('users_loc')
            .child("uid" + uId).set({"lat": currentLocation.latitude, "long": currentLocation.longitude, "timestamp": DateTime.now().millisecondsSinceEpoch}).onError((error, stackTrace) => print(error));
      }
      });
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
    getLoc();
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
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Container(
            color: Colors.black,
            // width: 255.0,
            child: Drawer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DrawerHeader(
                        decoration: BoxDecoration(color: Colors.grey[800]),
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border:
                                    Border.all(color: Colors.white, width: 1),
                              ),
                              child: rider_img.isEmpty?Image.asset('assets/user.png',  height: 50, width: 50,color: Colors.white,):
                              CircleAvatar(radius:25,backgroundImage: NetworkImage(rider_img)),
                            ),
                            Flexible(
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        rider_name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        rider_contact,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        cab_number,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> DriverYourRidePage()));
                        },
                        child: ListTile(
                          leading: Icon(Icons.history),
                          title: Text(
                            "Your Ride",
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: ()
                        async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String mob = prefs.getString('support_number') ?? "";
                          final Uri launchUri = Uri(
                            scheme: 'tel',
                            path: mob,
                          );
                          launchUrl(launchUri);
                        },
                        child:  Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,0),
                          child: ListTile(
                            leading: Icon(Icons.support),
                            title: Text("Support", style: TextStyle(fontSize: 15.0),),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: ()
                        async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String url = prefs.getString('privacy_policy_url') ?? "";
                          if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
                        },
                        child:  ListTile(
                          leading: Icon(Icons.policy),
                          title: Text("Privacy Policy", style: TextStyle(fontSize: 15.0),),
                        ),
                      ),

                      GestureDetector(
                        onTap: ()
                        async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String url = prefs.getString('terms_condition_url') ?? "";
                          if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
                        },
                        child:  ListTile(
                          leading: Icon(Icons.miscellaneous_services),
                          title: Text("Terms of Service", style: TextStyle(fontSize: 15.0),),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                         await  Navigator.push(context, MaterialPageRoute(builder: (context)=> DriverProfileSetting()));
                        getRiderSelf();
                         },
                        child: ListTile(
                          leading: Icon(Icons.settings),
                          title: Text(
                            "Profile Setting",
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> DriverOffersPage()));
                        },
                        child: ListTile(
                          leading: Icon(Icons.local_offer),
                          title: Text(
                            "Offers & Update",
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                      ),
                      user_type=="driver"? GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> CustomerHomePage()),
                                  (Route<dynamic> route) => false);
                        },
                        child:  ListTile(
                          leading: Icon(Icons.swap_horizontal_circle,color: Colors.green,),
                          title: Text("User Mode", style: TextStyle(fontSize: 15.0,color: Colors.green),),
                        ),
                      ):SizedBox(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Expanded(
                      //   flex: 1,
                      //   child: Center(
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Image.asset(
                      //             'assets/Small logo png.png',
                      //             width: 150,height:150
                      //           // height: 300,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () async {
                            FirebaseAuth.instance.signOut();
                            final pref = await SharedPreferences.getInstance();
                            await pref.clear();
                            OneSignal.shared.removeExternalUserId();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new LoginPage()),
                                (Route<dynamic> route) => false);
                          },
                          child: ListTile(
                            leading: Icon(Icons.exit_to_app),
                            title: Text(
                              "Sign Out",
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black,fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            GoogleMap(
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
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                // height: MediaQuery.of(context).size.height/2.5,
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
                  padding: const EdgeInsets.fromLTRB(20,30,20,20),
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      isActive?GestureDetector(
                        onTap: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context)=> DriverSearchCity(cur_address: address, cur_lat: lat, cur_long: lan)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 14,
                            // width: MediaQuery.of(context).size.width*1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(24, 0, 0, 0),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.green,
                                    size: 40.0,
                                  ),
                                ),
                                Flexible(
                                  child: FittedBox(
                                    child: Text(
                                      "Search Ride On Your Route",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      // maxLines: 1,
                                      //       overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // constraints: BoxConstraints(minWidth: 100, maxHeight: 200),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 3.0,
                                  spreadRadius: 1.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ):SizedBox(),
                      !isActive?Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                            child: Text("Your ID Is Inactive.", style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold),),
                          )):SizedBox(),
                      !isActive?Padding(
                        padding: const EdgeInsets.only(top: 8,bottom: 8,left: 10,right: 10),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: RaisedButton(
                            child: Text("Call Support", style: TextStyle(fontSize: 16,color: Colors.white),),
                            color: Colors.black,
                            elevation: 5,
                            textColor: Colors.white,
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              String mob = prefs.getString('support_number') ?? "";
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: mob,
                              );
                              launchUrl(launchUri);
                            },
                          ),
                        ),
                      ):SizedBox(),
                      SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: bannerImg.isEmpty?Image.asset('assets/veg.png', fit: BoxFit.fill,):
                          Image.network(bannerImg, fit: BoxFit.fill,),
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
                          getData();
                          scaffoldKey.currentState?.openDrawer();
                        },
                        child: Container(
                            padding: EdgeInsets.all(5),
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
                            child: Icon(
                              Icons.menu,
                              size: 30.0,
                              color: Colors.black,
                            ))),
                    GestureDetector(
                      onTap: () {
                        setState((){
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                        decoration: BoxDecoration(
                          color: isActive?Colors.green:Colors.red,
                          borderRadius: BorderRadius.circular(55.0),
                          // border: Border.all(width: 2.0, color: Colors.grey[300]),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                        ),
                        child: Text(
                         isActive? "Active":"InActive",
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
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

  Future<void> getData() async {
    print("swapnil-user Deatils");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String idL = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    print("user_login_token-" + idL);
    API.userDetails(id,idL).then((response) async {
      print(response.body);
      var jVar = jsonDecode(response.body);
      print(jVar["status"]);
      if (jVar["status"] == 200) {
        print("Loggin Google");
        OneSignal.shared.setExternalUserId(jVar["data"]["id"].toString());
        addToSF(
            jVar["data"]["id"],
            jVar["data"]["rb_id"],
            jVar["data"]["user_type"],
            jVar["data"]["user_name"],
            jVar["data"]["user_mobile"],
            jVar["data"]["user_email"],
            jVar["data"]["user_pic"],
            jVar["data"]["user_login_token"],
            jVar["data"]["disp_image"],
            jVar["data"]["is_login"].toString(),
            jVar["data"]["become_driver"]
        );
        if (jVar["data"]["user_type"].toString() == "user") {
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('cab_pic', jVar["data"]["driver_profile_data"]["cab_pic"]);
          prefs.setString('dl_pic', jVar["data"]["driver_profile_data"]["dl_pic"]);
          prefs.setString('aadhar_pic', jVar["data"]["driver_profile_data"]["aadhar_pic"]);
          prefs.setString('status', jVar["data"]["driver_status"].toString());
          prefs.setString('cab_number', jVar["data"]["driver_profile_data"]["cab_number"]);
        }
        getRiderSelf();
      }
    });
  }
  addToSF(
      String id,
      String rb_id,
      String user_type,
      String user_name,
      String user_mobile,
      String user_email,
      String user_pic,
      String user_login_token,
      String disp_image,
      String is_login, bool become_driver) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('login', true);
    prefs.setString('id', id);
    prefs.setString('rb_id', rb_id);
    prefs.setString('user_type', user_type);
    prefs.setString('user_name', user_name);
    prefs.setString('user_mobile', user_mobile);
    prefs.setString('user_email', user_email);
    prefs.setString('user_pic', user_pic);
    prefs.setString('user_login_token', user_login_token);
    prefs.setString('disp_image', disp_image);
    prefs.setString('is_login', is_login);
    prefs.setBool('become_driver', become_driver);
    print("sssssssssssssssssssssssss");
  }
}
