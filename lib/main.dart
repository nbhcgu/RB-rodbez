
// import 'package:device_preview/device_preview.dart';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rodbez/Customer/cus_ride_page/complete_page.dart';
import 'package:rodbez/Driver/driver_publish_page.dart';
import 'package:rodbez/Driver/driver_ride_cancel_details_page.dart';
import 'package:rodbez/Driver/driver_ride_complete_details_page.dart';
import 'package:rodbez/Driver/driver_ride_confirmed.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:screen_size_test/screen_size_test.dart';
import 'package:rodbez/Customer/call_driver_page.dart';
import 'package:rodbez/Customer/cus_search_page.dart';
import 'package:rodbez/Customer/cus_home_page.dart';
import 'package:rodbez/Customer/cus_schedule_page.dart';
import 'package:rodbez/Customer/menu/cus_profile_setting.dart';
import 'package:rodbez/functions/bearer.dart';
import 'package:rodbez/functions/functions.dart';
import 'package:rodbez/login.dart';
import 'package:rodbez/login/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Customer/cus_cancel_status_page.dart';
import 'Customer/cus_ride_page/assign_page.dart';
import 'Customer/cus_ride_page/gotit.dart';
import 'Customer/cus_ride_page/pending_page.dart';
import 'Customer/cus_home_page.dart';
import 'Customer/menu/cus_your_ride_page.dart';
import 'login/login_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await FirebaseAppCheck.instance.activate(
  //   webRecaptchaSiteKey: "recaptcha-v3-site-key",
  // );
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId("c4d0b512-47ad-4467-9510-35ffb269a87c");
// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  runApp(
      // DevicePreview(
        // enabled: !kReleaseMode,
      // builder: (context)=>
          MyApp(),
  // ),
  );
}

class MyApp extends StatelessWidget {

  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  setOneSignal(BuildContext context){
    OneSignal.shared.setNotificationOpenedHandler(
            (OSNotificationOpenedResult result) async {
          print("Onsignle result");
          print(result.notification.additionalData);
          var one = result.notification.additionalData;
          if(one!=null) {
            if(one["target_id"]!=0) {
              print("Onsignle result");
              print(result.notification.additionalData);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String user_type = prefs.getString('user_type') ?? "user";
              if(one["user_type"]=="user"){
                if(one["type"].toString()=="1" || one["type"].toString()=="2"){
                  print("Onsignle type");
                  navigatorKey.currentState?.push(
                    MaterialPageRoute(
                      builder: (context) => CustomerPendingPage(id:one["target_id"].toString(),type:one["type"].toString(),list_type:one["list_type"].toString()),
                    ),
                  );
                }
                else if(one["type"].toString()=="0"||one["type"].toString()=="5"||one["type"].toString()=="6"){
                  navigatorKey.currentState?.push(
                      MaterialPageRoute(
                          builder: (context) =>
                              CustomerAssignPage(id:one["target_id"].toString(),list_type:one["list_type"].toString(),
                              is_started: one["type"].toString()=="6"?true:false,)));
                }
                else if(one["type"].toString()=="3"){
                  navigatorKey.currentState?.push(
                      MaterialPageRoute(
                          builder: (context) =>
                              CustomerCancelPage(id:one["target_id"].toString(),list_type:one["list_type"].toString())));
                }
                else if(one["type"].toString()=="4"){
                  navigatorKey.currentState?.push(
                      MaterialPageRoute(
                          builder: (context) =>
                              CustomerCompletePage(id:one["target_id"].toString(),list_type:one["list_type"].toString())));
                }
              }else{
                _getDtails(one["target_id"].toString(),one["list_type"].toString(), one["type"].toString(),context);
              }
            }
          }
        });
  }

  _getDtails(String rideId, String req, String type,BuildContext context) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String idL = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    print("user_login_token-" + idL);
    API.rideDetails(id, idL, rideId,req).then((response) {
      EasyLoading.dismiss();
        print(type);
        print(response.body);
        var jVar = jsonDecode(response.body);
        if (jVar["status"] == 200) {
          var kVar = jVar['data'];
          if(type=="0"||type=="1"||type=="5"||type=="6"){
            navigatorKey.currentState?.push(
                MaterialPageRoute(
                    builder: (context) =>
                        DriverRideConfirmedPage(searchList: kVar,status_type: int.parse(type),)));
          }else if(type=="2"){
            navigatorKey.currentState?.push(
                MaterialPageRoute(
                    builder: (context) =>
                        DriverPublishPage(message: "widget.message",
                            caption: "widget.caption",
                            start_lat: "",
                            start_long:"",
                            start_address: kVar["start_location"].toString(),
                            end_lat:kVar["destination_lat"],
                            end_long: kVar["destination_long"],
                            end_address: kVar["end_location"].toString(),
                            cab_icon: kVar["cab_icon"],
                            cab_type: kVar["cab_type"],
                            date:kVar["ride_date"],
                            driver_publish_page_msg_heading_status:kVar["driver_publish_page_msg_heading_status"],
                            driver_publish_page_msg_heading:kVar["driver_publish_page_msg_heading"],
                            driver_publish_page_msg:kVar["driver_publish_page_msg"],
                            ride_id:kVar["ride_id"],
                            display_id:kVar["display_id"]
                        )));
          }else if(type=="3"){
            navigatorKey.currentState?.push(
                MaterialPageRoute(
                    builder: (context) =>
                        DriverRideCanceDetailsPage(id:rideId,list_type:req)));
          }else if(type=="4"){
            navigatorKey.currentState?.push(
                MaterialPageRoute(
                    builder: (context) =>
                        DriverRideCompleteDetailsPage(id:rideId,list_type:req)));
          }
        }
    });
  }
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    setOneSignal(context);
    return MaterialApp(
      builder: EasyLoading.init(),
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: SplashScreen(),
    );
  }

}