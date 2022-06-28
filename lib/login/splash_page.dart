import 'dart:async';
import 'dart:convert';

// import 'package:driver_app/tabsPages/homeTabPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rodbez/Customer/cus_cancel_status_page.dart';
import 'package:rodbez/Customer/cus_home_page.dart';
import 'package:rodbez/Customer/cus_ride_page/assign_page.dart';
import 'package:rodbez/Customer/cus_ride_page/complete_page.dart';
import 'package:rodbez/Customer/cus_ride_page/pending_page.dart';
import 'package:rodbez/Driver/driver_home_page.dart';
import 'package:rodbez/Driver/driver_ride_cancel_details_page.dart';
import 'package:rodbez/Driver/driver_ride_complete_details_page.dart';
import 'package:rodbez/Driver/driver_ride_confirmed.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:rodbez/login/name_page.dart';
import 'package:rodbez/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:rodbez/page/search_page.dart';

// import 'mainscreen.dart';

class SplashScreen extends StatefulWidget {
  static const String idScreen = "SplashScreen";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () {
      getSetting();
    });
  }
  getSetting() async {
      API.appSetting().then((response) async {
        var jVar = jsonDecode(response.body);
        print(jVar);
        if (jVar["status"] == 200) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('banner_img', jVar["data"]["banner"][0]["img_url"]);
          prefs.setString('support_number', jVar["data"]["support_number"]);
          prefs.setString('user_inactive_message', jVar["data"]["user_inactive_message"]);
          prefs.setString('privacy_policy_url', jVar["data"]["privacy_policy_url"]);
          prefs.setString('terms_condition_url', jVar["data"]["terms_condition_url"]);
          prefs.setString('cancellation_policy_url', jVar["data"]["cancellation_policy_url"]);
          prefs.setBool('cancellation_fee_display', jVar["data"]["cancellation_fee_display"]);
          prefs.setString('user_ride_cancel_options',jsonEncode(jVar["data"]["user_ride_cancel_options"]));
          prefs.setString('driver_ride_cancel_options',jsonEncode(jVar["data"]["driver_ride_cancel_options"]));
          prefs.setString('offers',jsonEncode(jVar["data"]["offers"]));
          prefs.setString('updates',jsonEncode(jVar["data"]["updates"]));
          prefs.setString('date_error_message',jsonEncode(jVar["data"]["date_error_message"]));
          String id = prefs.getString('user_type') ?? "user";
          print(id);
          //prefs.setBool('login', true);
          //prefs.setString('id', "6");
          getLoginSF().then((value) async {
            if (value) {
              getProfile().then((value) async {
                if (value=="1") {
                  if(id=="user"){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> CustomerHomePage()),
                              (Route<dynamic> route) => false);
                  }else{
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new DriverPage()),(Route<dynamic> route) => false);
                  }
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => new NamePage()),(Route<dynamic> route) => false);
                }
              });
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => new LoginPage()),(Route<dynamic> route) => false);
            }
          });
        }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo here
            Image.asset(
              'assets/Splash screen.gif',
                width: 350,height:350
              // height: 300,
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            )
          ],
        ),
      ),
    );
  }
  Future<bool> getLoginSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool boolValue = prefs.getBool('login') ?? false;
    return boolValue;
  }
  Future<String> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('is_login') ?? "0";
  }
}
