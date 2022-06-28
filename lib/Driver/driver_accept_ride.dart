import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rodbez/Driver/driver_ride_confirmed.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:rodbez/utils/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverAcceptRidePage extends StatefulWidget {
  static const String idScreen = "login";

  DriverAcceptRidePage({required this.searchList});

  var searchList;

  @override
  DriverAcceptRidePageState createState() => DriverAcceptRidePageState();
}


class DriverAcceptRidePageState extends State<DriverAcceptRidePage> {

  var rules = [];
  String lat = "";
  String lan = "";

  Future<void> getPos() async {
    print("curPos");
    LOCATION().getCountryName().then((value) async {
      String con = value[2];
      print(value);
      setState(() {
        lat = value[0].toString();
        lan = value[1].toString();
      });
    });
  }

  acceptRide() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String idL = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    print("user_login_token-" + idL);
    API.driverAcceptRide(
        id, idL, widget.searchList["ride_id"].toString(),lat,lan).then((
        response) {
      EasyLoading.dismiss();
      print(response.body);
      var jVar = jsonDecode(response.body);
      print(jVar);
      if (jVar["status"] == 200) {
        if (json.decode(response.body)['chk'] == 1) {
          var searchList = json.decode(response.body)['data'];
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DriverRideConfirmedPage(searchList: searchList,status_type: 0,)));
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   getPos();
    rules.add("Exclude toll cost");
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery
        .of(context)
        .size;
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
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Ride ID " + widget.searchList["display_id"]
                                        .toString(),
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
                        thickness: 2,
                        color: Colors.grey[200],
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
                            width: MediaQuery
                                .of(context)
                                .size
                                .width / 1.2,
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
                                                widget
                                                    .searchList["start_location"]
                                                    .toString(),
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
                                                widget
                                                    .searchList["end_location"]
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.grey,overflow: TextOverflow.ellipsis),maxLines: 2,
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
                                  widget.searchList["ride_date"].toString(),
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black),
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
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 1.2,
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
                                        widget.searchList["cab_type"]
                                            .toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        widget.searchList["cab_type_caption"]
                                            .toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        widget.searchList["cab_luggage_text"]
                                            .toString(),
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
                                    child: widget.searchList["cab_icon"]
                                        .toString()
                                        .isEmpty ? Image.asset(
                                      'assets/non veg.png',
                                      alignment: Alignment.bottomRight,
                                      height: 50.0,
                                      width: 50.0,) :
                                    Image.network(
                                      widget.searchList["cab_icon"].toString(),
                                      height: 50, width: 50,),
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 1.1,
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
                                    widget.searchList["fare_details"]["fare_heading"],
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
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        '₹ ' + widget
                                            .searchList["fare_details"]["fare_amount"]
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
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
                                    widget
                                        .searchList["fare_details"]["fare_caption"]
                                        .toString(),
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
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        '₹ ' + widget
                                            .searchList["fare_details"]["base_fare_amount"]
                                            .toString(),
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
                            widget.searchList["fare_details"]["tax_status"]?   Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                  child: SizedBox(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: FittedBox(
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            '₹ ' + widget
                                                .searchList["fare_details"]["tax_amount"]
                                                .toString(),
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
                        borderRadius: BorderRadius.circular(15.0),
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
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.searchList["executive_name"]
                                            .toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          final Uri launchUri = Uri(
                                            scheme: 'tel',
                                            path: widget
                                                .searchList["executive_number"]
                                                .toString(),
                                          );
                                          launchUrl(launchUri);
                                        },
                                        child: Container(
                                          height: 40,
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
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
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
                                                margin: EdgeInsets.only(
                                                    left: 5, right: 10),
                                                child: SizedBox(
                                                    child: Icon(
                                                      Icons.call,
                                                      color: Colors.white,
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
                                  child: Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      child: widget
                                          .searchList["executive_image"]
                                          .toString()
                                          .isEmpty ? Icon(
                                        Icons.account_circle_rounded,
                                        color: Colors.black, size: 50,) :
                                      CircleAvatar(radius: 25,
                                        backgroundImage: NetworkImage(
                                            widget.searchList["executive_image"]
                                                .toString()),),),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    widget.searchList["rules_status"]? Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 11.0, left: 11.0, right: 11.0),
                          child: Text(
                            widget.searchList["rules_heading_text"],
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ):SizedBox(),
                    SizedBox(
                      height: 5,
                    ),
                    widget.searchList["rules_status"]?ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: widget.searchList["rules_contents"].length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Icon(
                                    Icons.circle,
                                    color: Colors.red,
                                    size: 16.0,
                                  ),
                                ),
                                Flexible(
                                    child: FittedBox(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.fromLTRB(
                                              10, 0, 0, 0),
                                          child: Text(
                                            widget
                                                .searchList["rules_contents"][index],
                                            style: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 14.0),
                                          ),
                                        ))),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                          ],
                        );
                      },
                    ):SizedBox(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        String url = prefs.getString('cancellation_policy_url') ?? "";
                        if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
                      },
                      child: Container(
                        height: media.height/18.5,
                        width: media.width/1.12,
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
                                  'Cancellation Policy',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 18.0),
                                ),
                              ),
                            ),
                            Container(
                              height: 30.0,
                              width: 30.0,
                              margin: EdgeInsets.only(right: 24),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(30.0),
                                // border: Border.all(width: 2.0, color: Colors.grey[300]),
                              ),
                              child: Icon(
                                Icons.arrow_forward,
                                size: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 14, right: 14),
                      child: Container(
                        height: media.height/18.5,
                        width: double.infinity,
                        child: RaisedButton(
                          child: Text("Accept This Ride", style: TextStyle(
                              fontSize: 16, color: Colors.white),),
                          color: Colors.black,
                          elevation: 5,
                          textColor: Colors.white,
                          onPressed: () {
                            acceptRide();
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
