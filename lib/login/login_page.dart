import 'dart:convert';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:rodbez/Customer/cus_home_page.dart';
import 'package:rodbez/Driver/driver_home_page.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:rodbez/login/name_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:rodbez/page/search_page.dart';

import '../customAppBar.dart';
import '../login.dart';
import 'otp_page.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _controller = TextEditingController();
  late String deviceId = "";
  late String verificationId = "";
  late String phoneCode = "+91";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          // backgroundColor: Colors.white,
          child: ClipPath(
            clipper: OvalBottomBorderClipper(),
            child: Container(
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 70, 150, 0),
                    child: Column(
                      children: [
                        new Image.asset(
                          'assets/welcome image.png',
                          // height: 00,
                        ),
                        // Text(
                        //   'Welcome to',
                        //   style: TextStyle(color: Colors.white, fontSize: 25),
                        // ),
                      ],
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(60, 0, 0, 70),
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         'Rod',
                  //         style: TextStyle(color: Colors.white, fontSize: 35),
                  //       ),
                  //       Text(
                  //         'B',
                  //         style: TextStyle(
                  //             color: Colors.orangeAccent, fontSize: 35),
                  //       ),
                  //       Text(
                  //         'ez',
                  //         style: TextStyle(color: Colors.white, fontSize: 35),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.fromLTRB(0, 0, 100, 24),
                  //         child: Column(
                  //           children: [
                  //             Text(
                  //               'TM',
                  //               style:
                  //                   TextStyle(color: Colors.white, fontSize: 6),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Image.asset('assets/Small logo.png',  height: 90.3, width: 90.3,),
                ],
              ),
            ),
          ),
          preferredSize: Size.fromHeight(kToolbarHeight + 240)),
      // centerTitle: true,

      // toolbarHeight: 200,
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0,10,0,0),
                        child: TextField(
                          cursorColor: Colors.black,
                          inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          controller: _controller,
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                            hintText: " Enter your mobile number",
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 16.0,
                            ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                            counter: Text("",style: TextStyle(fontSize: 0),)
                          ),
                          style: TextStyle(fontSize: 18.0, color: Colors.black,letterSpacing: 1.0),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if(_controller.text.length==10){
                          loginUser(
                              phoneCode.trim() + " " + _controller.text.trim(),
                              context);
                        }else{
                          Fluttertoast.showToast(
                              msg: "Enter 10 digit mobile no.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          height: 30.0,
                          width: 30.0,
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
                          // child: RaisedButton(
                          //   shape: new RoundedRectangleBorder(
                          //     borderRadius: new BorderRadius.circular(24.0),
                          //   ),
                          //   onPressed: (){
                          //     Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPage()));
                          //   },
                          //
                          // ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              color: Colors.white,
              margin: EdgeInsets.fromLTRB(24, 70, 24, 0),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loginUser(String phone, BuildContext context) async {
    EasyLoading.show();
    FirebaseAuth _auth = FirebaseAuth.instance;
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          final User? user =
              (await _auth.signInWithCredential(credential)).user;
          if (user != null) {
            EasyLoading.show(status: 'loading...');
            print("swapnil-user Deatils");
            print(user);
            API
                .login(_controller.text.trim(), "user", deviceId, user.uid)
                .then((response) async {
              print(response.body);
              var jVar = jsonDecode(response.body);
              print(jVar["status"]);
              if (jVar["status"] == 200) {
                print("Loggin Google");
                EasyLoading.dismiss();
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
                    jVar["data"]["become_driver"]);
                if (jVar["data"]["user_type"].toString() == "user") {
                  if (jVar["data"]["is_login"].toString() == "1") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerHomePage()));
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NamePage()));
                  }
                } else {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('cab_pic',
                      jVar["data"]["driver_profile_data"]["cab_pic"]);
                  prefs.setString(
                      'dl_pic', jVar["data"]["driver_profile_data"]["dl_pic"]);
                  prefs.setString('aadhar_pic',
                      jVar["data"]["driver_profile_data"]["aadhar_pic"]);
                  prefs.setString('cab_number',
                      jVar["data"]["driver_profile_data"]["cab_number"]);
                  prefs.setString('status', jVar["data"]["driver_status"].toString());
                  if(jVar["data"]["driver_status"].toString()=="pending"){
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => new CustomerHomePage()),(Route<dynamic> route) => false);
                  }else{
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => new DriverPage()),(Route<dynamic> route) => false);
                  }
                }
              }
            });
          } else {
            EasyLoading.dismiss();
            print("Error");
          }
        },
        verificationFailed: (Exception exception) {
          print(exception);
          EasyLoading.dismiss();
        },
        codeSent: (String verificationId, int? resendToken) {
          EasyLoading.dismiss();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => OtpPage(
                        otpId: verificationId,
                        mobileNo:
                            phoneCode.trim() + " " + _controller.text.trim(),
                    resendToken: resendToken,
                      )));
        },
        codeAutoRetrievalTimeout: autoRetrieve);
  }

  @override
  void initState() {
    getInitData();
  }

  Future<void> getInitData() async {
    deviceId = (await PlatformDeviceId.getDeviceId)!;
    print(deviceId + "kkkk");
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
      String is_login,
      bool become_driver) async {
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
