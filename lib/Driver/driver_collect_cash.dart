import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rodbez/Customer/cus_ride_page/review_page.dart';
import 'package:rodbez/Driver/driver_home_page.dart';
import 'package:rodbez/Driver/driver_ride_confirmed.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverCollectCashPage extends StatefulWidget {
  DriverCollectCashPage({required this.searchList});

  var searchList;
  static const String idScreen = "login";
  @override
  DriverCollectCashPageState createState() => DriverCollectCashPageState();
}

class DriverCollectCashPageState extends State<DriverCollectCashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  collectCash() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String idL = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    print("user_login_token-" + idL);
    API.driverCollectCash(id, idL, widget.searchList["new_ride_id"].toString())
        .then((response) {
      EasyLoading.dismiss();
      print(response.body);
      var jVar = jsonDecode(response.body);
      print(jVar);
      if (jVar["status"] == 200) {
        if (json.decode(response.body)['chk'] == 1) {
          var searchList = json.decode(response.body)['data'];
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                content: Container(
                  height: 280,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/happy.png", width: 120,height:120),
                      SizedBox(height: 15,),
                      Text(jVar["message"], style:TextStyle(color:Colors.black, fontSize:20,fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 8, left: 24, right: 24),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: RaisedButton(
                            child: Text(
                              "Done",
                              style:
                              TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            color: Colors.black,
                            elevation: 5,
                            textColor: Colors.white,
                            onPressed: () {
                              if (searchList["rating_status"]){
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (BuildContext context) => new ReviewPage(id: id, rideId: widget.searchList["new_ride_id"].toString(),
                                      user_type: "driver",type: 1,)),
                                        (Route<dynamic> route) => false);
                              } else {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (BuildContext context) => new DriverPage()),
                                        (Route<dynamic> route) => false);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          );
        }
      } else {
        Fluttertoast.showToast(
            msg: "Try Again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0.0),
                  topRight: Radius.circular(0.0),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 0.2,
                    blurRadius: 9.0,
                    color: Colors.black54,
                    offset: Offset(0.9, 0.9),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 40, 0, 0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
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
                                    "One-Way Trip",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Ride ID " + widget.searchList["display_id"],
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
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
                    SizedBox(
                      height: 10.0,
                    ),

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
                                                widget.searchList["start_location"],
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.grey,overflow: TextOverflow.ellipsis),maxLines: 2,
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
                                                widget.searchList["end_location"],
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.grey,overflow: TextOverflow.ellipsis),
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

                                  widget.searchList["ride_date"],
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Divider(),

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
                                        widget.searchList["cab_type"],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        widget.searchList["cab_type_caption"],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        widget.searchList["cab_luggage_text"],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16,
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
                                    child: widget.searchList["cab_icon"].toString().isEmpty?Image.asset('assets/non veg.png', alignment: Alignment.bottomRight, height: 50.0, width: 50.0,):
                                    Image.network(widget.searchList["cab_icon"].toString(),width: 50,height: 50,),
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
                      // height: MediaQuery.of(context).size.height/8,
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    widget.searchList["fare_details"]["fare_heading"],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        '₹ '+widget.searchList["fare_details"]["fare_amount"],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.red
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
                                    widget.searchList["fare_details"]["fare_caption"],
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
                                    widget.searchList["fare_details"]["base_fare_text"],
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
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        '₹ '+widget.searchList["fare_details"]["base_fare_amount"],
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
                              ],
                            ),
                            widget.searchList["fare_details"]["extra_km_status"] ?Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    widget.searchList["fare_details"]["extra_km_text"].toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Expanded(flex: 2, child: Container()),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        '₹ '+ widget.searchList["fare_details"]["extra_km_fare"].toString(),
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
                              ],
                            ):SizedBox(),
                            widget.searchList["fare_details"]["extra_time_status"]?Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    widget.searchList["fare_details"]["extra_time_text"].toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                Expanded(flex: 1, child: Container()),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        '₹ '+widget.searchList["fare_details"]["extra_time_charge"].toString(),
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
                              ],
                            ):SizedBox(),
                            widget.searchList["fare_details"]["tax_status"]?Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    widget.searchList["fare_details"]["tax_text"],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                Expanded(flex: 1, child: Container()),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        '₹ '+widget.searchList["fare_details"]["tax_amount"].toString(),
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
                              ],
                            ):SizedBox(),
                            Divider(),
                            widget.searchList["fare_details"]["round_off_status"]?Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    widget.searchList["fare_details"]["round_off_text"],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                Expanded(flex: 1, child: Container()),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        '₹ '+widget.searchList["fare_details"]["round_off_amount"].toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ):SizedBox(),
                            Divider(),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Payout',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                Expanded(flex: 1, child: Container()),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        '₹ '+widget.searchList["fare_details"]["fare_amount"].toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        String mob = prefs.getString('support_number') ?? "";
                        final Uri launchUri = Uri(
                          scheme: 'tel',
                          path: mob,
                        );
                        launchUrl(launchUri);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8,bottom: 8,left: 14,right: 14),
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
                                    'Support',
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
                                  size: 15.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8,bottom: 8,left: 14,right: 14),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: RaisedButton(
                          child: Text("Collect Cash", style: TextStyle(fontSize: 16,color: Colors.white),),
                          color: Colors.black,
                          elevation: 5,
                          textColor: Colors.white,
                          onPressed: () {
                            collectCash();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
