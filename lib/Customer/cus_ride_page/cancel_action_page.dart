import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rodbez/Customer/cus_home_page.dart';
import 'package:rodbez/Driver/driver_home_page.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'accept_widget.dart';

class CancelActionPage extends StatefulWidget
{
  CancelActionPage(
      {required this.id,required this.rideId,required this.isUser,required this.request_type});
  final String id;
  final String rideId;
  final String request_type;
  final bool isUser;

  @override
  CancelActionPageState createState() => CancelActionPageState();
}
class CancelActionPageState extends State<CancelActionPage> {
  double _userRating = 0.0;
  IconData? _selectedIcon;
  TextEditingController  reviewController = TextEditingController();
  bool cancellation_fee_display = false;
  String cancellation_fee = "";
   int _site = -1;
  var actions = [];

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ac = prefs.getString('driver_ride_cancel_options') ?? "";
    if(widget.isUser){
      ac = prefs.getString('user_ride_cancel_options') ?? "";
    }
    setState((){
      cancellation_fee_display = prefs.getBool('cancellation_fee_display') ?? false;
      actions = jsonDecode(ac);
    });
  }
  setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String idL = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    print("user_login_token-" + idL);
    String u_type = "driver";
    if(widget.isUser){
      u_type = "user";
    }
    API.rideCancel(id, idL, widget.id,actions[_site]["id"],reviewController.text.toString(),u_type,widget.request_type).then((response) {
      setState(() {
        print(response.body);
        var jVar = jsonDecode(response.body);
        print(jVar);
        Fluttertoast.showToast(
            msg: jVar["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        if(widget.isUser){
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => new CustomerHomePage()),
                  (Route<dynamic> route) => false);
        }else{
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => new DriverPage()),
                  (Route<dynamic> route) => false);
        }
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("iiiiiii"+widget.id);
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 40, 0, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap:(){
                      Navigator.pop(context);
                    },
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
                      child: Icon(
                        Icons.arrow_back,
                        size: 22.0,
                        color: Colors.black,
                      ),
                      // ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Cancel Ride",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),Text(
                            "Ride Id "+widget.rideId,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,),
                          ),
                        ],
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Divider(
                height: 1,
                color: Colors.grey,
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: actions.length,
                itemBuilder: (context, index) {
          return  Padding(
              padding: EdgeInsets.all(0),
              child: RadioListTile(
                value: index,
                groupValue: _site,
                onChanged: (ind) => setState((){
                  _site = index;
                  cancellation_fee = actions[index]["cancellation_charge"];
                }),
                title: Text(actions[index]["reasons"]),
              ),
            );}),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child:
              Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: 150,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: reviewController,
                          keyboardType: TextInputType.text,
                          maxLines: 8,
                          decoration: new InputDecoration.collapsed(
                            hintText: "Enter your comment",
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize:18.0,
                            ),
                          ),
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
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
            ),
            SizedBox(
              height: 20.0,
            ),
            cancellation_fee_display && cancellation_fee.isNotEmpty?Text("Cancellation Fee : ₹"+cancellation_fee):SizedBox(),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: double.infinity,
                child: RaisedButton(
                  child: Text("Done"),
                  color: Colors.black,
                  elevation: 5,
                  textColor: Colors.white,
                  onPressed: () {
                    setData();
                  },
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
