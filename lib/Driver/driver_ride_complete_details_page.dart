import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rodbez/Customer/cus_ride_page/review_page.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'accept_widget.dart';

class DriverRideCompleteDetailsPage extends StatefulWidget
{
  DriverRideCompleteDetailsPage(
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
  DriverRideCompleteDetailsPageState createState() => DriverRideCompleteDetailsPageState();
}

class DriverRideCompleteDetailsPageState extends State<DriverRideCompleteDetailsPage> {
  String id="",rideId="",sPlace="",ePlace="",date="",cab="",cab_icon="",cabData="",cabSeat="",fare="",baseFare="",taxes="",status="",
      msg="",serEx="",serExImg="",serExNo="",fare_caption="",extra_km_fare="",extra_time_charge="",round_off_amount="",
  tax_text="",fare_heading="",base_fare_text="",
  extra_km_text="",extra_time_text="",round_off_text="";
  bool extra_km_status= false,extra_time_status=false,round_off_status=false,is_review=false,tax_status=false;
  var rules=[], inc=[];
  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idu = prefs.getString('id') ?? "0";
    String idL = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + idu);
    print("user_login_token-" + idL);
    API.rideDetails(idu, idL, widget.id,widget.list_type).then((response) {
      setState(() {
        var jVar = jsonDecode(response.body);
        print(jVar["data"]);
        if (jVar["status"] == 200) {
          var data = jVar["data"];
          setState((){
            id = data["ride_id"].toString();
            rideId = data["display_id"].toString();
            sPlace = data["start_location"].toString();
            ePlace = data["end_location"].toString();
            date = data["ride_date"].toString();
            cab = data["cab_type"].toString();
            status = data["status"].toString();
            cab_icon = data["cab_icon"].toString();
            cabData = data["cab_type_caption"].toString();
            cabSeat = data["cab_luggage_text"].toString();
            extra_km_status = data["fare_details"]["extra_km_status"];
            extra_time_status = data["fare_details"]["extra_time_status"];
            round_off_status = data["fare_details"]["round_off_status"];
            extra_km_fare = data["fare_details"]["extra_km_fare"].toString();
            extra_time_charge = data["fare_details"]["extra_time_charge"].toString();
            round_off_amount = data["fare_details"]["round_off_amount"].toString();
            fare = data["fare_details"]["fare_amount"].toString();
            fare_caption = data["fare_details"]["fare_caption"].toString();
            baseFare = data["fare_details"]["base_fare_amount"].toString();
            taxes = data["fare_details"]["tax_amount"].toString();
            baseFare = data["fare_details"]["base_fare_amount"].toString();
            taxes = data["fare_details"]["tax_amount"].toString();
            tax_text = data["fare_details"]["tax_text"].toString();
            fare_heading = data["fare_details"]["fare_heading"].toString();
            extra_km_text = data["fare_details"]["extra_km_text"].toString();
            extra_time_text = data["fare_details"]["extra_time_text"].toString();
            round_off_text = data["fare_details"]["round_off_text"].toString();
            base_fare_text = data["fare_details"]["base_fare_text"].toString();
            msg = data["status_message"].toString();
            serEx = data["executive_name"].toString();
            serExNo = data["executive_number"].toString();
            serExImg = data["executive_image"].toString();
            rules = data["rules_contents"];
            inc = data["inclusion_contents"];
            is_review = data["is_review"];
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
                                              fontSize: 18.0,
                                              color: Colors.grey,overflow: TextOverflow.ellipsis),maxLines: 2,
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
                                              fontSize: 18.0,
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
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Row(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.fromLTRB(15, 5, 10, 0),
                    child: Icon(Icons.calendar_month,
                        color: Colors.black, size: 24.0),
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
            SizedBox(
              height: 10.0,
            ),
            Divider(),
            GestureDetector(
              onTap: () {},
              child: Padding(
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
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  cabData,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w300,
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
                              child: cab_icon.isEmpty?Icon(Icons.account_circle_rounded,color: Colors.black,size: 50,):
                              Image.network(cab_icon,width: 50,height: 50,),
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
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 10),
                  child: Text("Bill Details",style: TextStyle(color: Colors.black, fontSize:16,),),
                ),
              ],
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
                          flex: 2,
                          child: Text(
                            fare_heading,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(flex: 2, child: Container()),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                '₹ '+fare,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 16,
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
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
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
                   extra_km_status ?Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Text(
                            extra_km_text,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Expanded(flex: 2, child: Container()),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                '₹ '+extra_km_fare,
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
                    extra_time_status?Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Text(
                            extra_time_text,
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
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                  '₹ '+extra_time_charge,
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
                    tax_status?Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(
                            tax_text,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
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
                              padding: EdgeInsets.all(5.0),
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
                    Divider(),
                    round_off_status?Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(
                            round_off_text,
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
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                '₹ '+round_off_amount,
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
                                '₹ '+fare,
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
           is_review? GestureDetector(
              onTap: () async {
              bool chk = await  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ReviewPage(id: id,rideId: rideId,user_type: "driver",type: 0,)));
              if(chk!=null){
                if(chk){
                  setState((){
                    is_review = false;
                  });
                }
              }
              },
              child: Container(
                height: 45,
                margin: EdgeInsets.only(left: 20,right: 20),
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(5.0)),
                    border:
                    Border.all(color: Colors.grey, width: 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(left: 24),
                        child: Text(
                          'Review',
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
              height: 10.0,
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
