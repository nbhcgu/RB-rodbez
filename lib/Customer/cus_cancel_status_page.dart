import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


// import 'end_page.dart';

// import 'accept_widget.dart';

class CustomerCancelPage extends StatefulWidget
{  CustomerCancelPage(
    {required this.id,required this.list_type});
final String id;
final String list_type;
  static const String idScreen = "MainImageWidget";
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  // static const String idScreen = "mainScreen";
  @override
  _ArrivedPageState createState() => _ArrivedPageState();
}

class _ArrivedPageState extends State<CustomerCancelPage> {
  String rideId="",sPlace="",ePlace="",date="",cab="",cab_icon="",cabData="",cabSeat="",fare="",baseFare="",taxes="",status="",
      serEx="",serExImg="",serExNo="",fare_caption="",tax_text="",fare_heading="",base_fare_text="";
  var rules=[], inc=[],msg=[];
  bool tax_status=false,status_message_status=false;
  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String idL = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    print("user_login_token-" + idL);
    API.rideDetails(id, idL, widget.id,widget.list_type).then((response) {
      setState(() {
        var jVar = jsonDecode(response.body);
        print(jVar["data"]);
        if (jVar["status"] == 200) {
          var data = jVar["data"];
          setState((){
            rideId = data["display_id"].toString();
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
            msg = data["status_message"];
            status_message_status = data["status_message_status"];
            serEx = data["executive_name"].toString();
            serExNo = data["executive_number"].toString();
            serExImg = data["executive_image"].toString();
            rules = data["rules_contents"];
            inc = data["inclusion_contents"];
          });
        }
      });
    });
  }

  @override
  void initState() {
    _getData();
  }
  DateTime _dateTime = DateTime.now();
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
                            "One-Way Trip",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),Text(
                            "Ride Id "+rideId,
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
                                        padding: const EdgeInsets
                                            .fromLTRB(20, 0, 0, 0),
                                        child: Text(
                                          sPlace,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.grey,
                                          overflow: TextOverflow.ellipsis),maxLines: 2,
                                        ),
                                      ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0,
                                    top: 10,
                                    bottom: 10),
                                child: Divider(),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets
                                            .fromLTRB(20, 0, 0, 0),
                                        child: Text(
                                          ePlace,
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
              onTap: () {
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Row(
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(0, 5, 10, 0),
                      child: Icon(Icons.calendar_month,
                          color: Colors.black, size: 20.0),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            0, 05, 10, 0),
                        child: Text(
                          date,
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black),
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
            Padding(
              padding: const EdgeInsets.only(left: 20.0,right:10),
              child: Divider(),
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
                                cab,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                cabData,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w300
                                ),
                              ),
                              Text(
                                cabSeat,
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
                            child: cab_icon.isEmpty?Image.asset("assets/non veg.png",width: 70,height: 70):
                            Image.network(cab_icon,width: 70,height: 70,),
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
                        Expanded(
                          flex: 1,
                          child: Align(
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
                        Expanded(flex: 1, child: Container()),
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
                        Expanded(
                          flex: 1,
                          child: Align(
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
                        Expanded(
                          flex: 1,
                          child: Align(
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0,22,0,0),
              child: Row(
                children: [
                  SizedBox(width: 20,),
                  Text("Status", style: TextStyle(fontSize: 16.0, color: Colors.black),),
                  SizedBox(width: 10,),
                  Text("Cancel", style: TextStyle(fontSize: 16.0, color: Colors.red,fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            SizedBox(height: 10.0,),
            status_message_status?Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Message",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: msg.length,
                          itemBuilder: (context, index) {
                            return Text(
                              msg[index],
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black45,fontWeight: FontWeight.w300),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ):SizedBox(),
            SizedBox(height: 30.0,),
          ],
        ),
      ),
    );
  }
}
