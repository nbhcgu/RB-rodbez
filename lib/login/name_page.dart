import 'dart:convert';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rodbez/Customer/cus_home_page.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:rodbez/login/otp_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:rodbez/page/search_page.dart';

import '../customAppBar.dart';
enum LoginScreen{
  SHOW_MOBILE_ENTER_WIDGET,
  SHOW_OTP_FORM_WIDGET
}
class NamePage extends StatefulWidget {
  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {

  TextEditingController  nameController = TextEditingController();
  Future<void> setName() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    print("user_id-"+id);
    API.nameSet(id,
        nameController.text.trim())
        .then((response) {
      print(response.body);
      var jVar = jsonDecode(response.body);
      print(jVar["status"]);
      if (jVar["status"] == 200) {
        print("Loggin Google");
        EasyLoading.dismiss();
        if (jVar["chk"] == 1) {
        prefs.setString('user_name', jVar['data']['user_name']);
        prefs.setString('is_login', jVar['data']['is_login']);
        Fluttertoast.showToast(
            msg: jVar['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerHomePage()));
        }else{
          Fluttertoast.showToast(
              msg: jVar['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController  phoneController = TextEditingController();
    TextEditingController  otpController = TextEditingController();
    LoginScreen currentState = LoginScreen.SHOW_MOBILE_ENTER_WIDGET;
    FirebaseAuth _auth = FirebaseAuth.instance;
    String verificationID = "";
    String phnumber = '';
    return Scaffold(
      appBar: PreferredSize(
        // backgroundColor: Colors.white,
          child: ClipPath(
            clipper: OvalBottomBorderClipper(),
            child: Container(color: Colors.black, child: Column( mainAxisAlignment: MainAxisAlignment.center ,children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(58.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Enter Your' , style: TextStyle(color: Colors.white70, fontSize: 14),),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,0),
                      child: Row(
                        children: [
                          Text('Good Name' , style: TextStyle(color: Colors.white, fontSize: 22),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Image.asset('assets/Small logo.png',  height: 90.3, width: 90.3,),
            ],),),

          ),
          preferredSize: Size.fromHeight(kToolbarHeight + 240)),
      // centerTitle: true,

      // toolbarHeight: 200,
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              padding: EdgeInsets.only(left: 20,right: 20),
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(00,10,0,0),
                      child: TextField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        inputFormatters: [new FilteringTextInputFormatter(RegExp("[a-z A-Z]"), allow: true),],
                        cursorColor: Colors.black,
                        // controller: nameTextEditingController,
                        decoration: new InputDecoration.collapsed(
                          hintText: "Enter Your Good Name",
                          hintStyle: TextStyle(
                            color: Colors.black54,
                            fontSize:16.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: ()
                    {
                      if(nameController.text.isEmpty){
                        Fluttertoast.showToast(
                            msg: "Enter your name",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }else{
                        setName();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,0),
                      child: Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(30.0),
                          // border: Border.all(width: 2.0, color: Colors.grey[300]),
                        ),
                        child: Icon(Icons.arrow_forward, size: 16.0,color: Colors.white,),
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
            margin: EdgeInsets.fromLTRB(24,70,24,0),
          ),
        ],
      ),
    );
  }
}
