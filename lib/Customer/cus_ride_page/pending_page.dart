import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rodbez/Customer/cus_ride_page/cancel_action_page.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerPendingPage extends StatefulWidget {
  static const String idScreen = "login";

  CustomerPendingPage({
    required this.id,
    required this.type,
    required this.list_type,
  });

  final String id;
  final String type;
  final String list_type;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<CustomerPendingPage> {
  String id = "",rideId = "",request_type="",
      sPlace = "",
      ePlace = "",
      date = "",
      cab = "",
      cab_icon = "",
      cabData = "",
      cabSeat = "",
      fare = "",
      baseFare = "",
      taxes = "",
      status = "",
      serEx = "",
      serExImg = "",
      serExNo = "",
      fare_caption = "",rules_heading_text="",inclusion_heading_text="",tax_text="",fare_heading="",base_fare_text="";
  var rules = [], inc = [], msg = [];
  bool can_cancel = false;
  bool rules_status=false,inclusion_status=false,tax_status=false,status_message_status=false;
  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idu = prefs.getString('id') ?? "0";
    String idL = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + idu);
    print("user_login_token-" + idL);
    API.rideDetails(idu, idL, widget.id, widget.list_type).then((response) {
      setState(() {
        var jVar = jsonDecode(response.body);
        print(jVar["data"]);
        if (jVar["status"] == 200) {
          var data = jVar["data"];
          setState(() {
            id = data["ride_id"].toString();
            print("iiiiiii"+id);
            rideId = data["display_id"].toString();
            request_type = data["request_type"].toString();
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
            can_cancel = data["can_cancel"];
            rules_status = data["rules_status"];
            inclusion_status = data["inclusion_status"];
            rules_heading_text = data["rules_heading_text"].toString();
            inclusion_heading_text = data["inclusion_heading_text"];
            print(rules);
            print(inc);
            print(rules_status);
            print(inclusion_status);
            print(rules_heading_text);
            print(inclusion_heading_text);
          });
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
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
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Ride ID " + rideId,
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
                                                sPlace,
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
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
                                                ePlace,
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.grey),
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
                                  date,
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
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        cabSeat,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    child: cab_icon.isEmpty?Image.asset("assets/non veg.png",width: 50,height: 50):
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
                    Container(
                      width: MediaQuery.of(context).size.width / 1.1,
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
                                    fare_heading,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Expanded(flex: 1, child: Container()),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: FittedBox(
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          '₹ ' + fare,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
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
                                    base_fare_text,
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
                                  child: SizedBox(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: FittedBox(
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            '₹ ' + baseFare,
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
                            ),
                           tax_status? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                            '₹ ' + taxes,
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
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                            child: Text(
                              'Status  ',
                              // textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,),
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0, 0, 0),
                              child: Text(
                                status,
                                // textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: widget.type=="2"?Colors.orangeAccent:Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(8.0, 10, 0, 0),
                              child: Text(
                                'Service executive for this ride',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,0,0,0,),
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
                                        serEx,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      GestureDetector(
                                        onTap: () {
                                          final Uri launchUri = Uri(
                                            scheme: 'tel',
                                            path: serExNo,
                                          );
                                          launchUrl(launchUri);
                                        },
                                        child: Container(
                                          height: 50,
                                          margin: EdgeInsets.only(top: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(50.0),
                                            border: Border.all(
                                                width: 0.0,
                                                color: Colors.black),
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
                                                height: 33,
                                                width: 33,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                  BorderRadius.circular(50.0),
                                                  border: Border.all(
                                                      width: 0.0,
                                                      color: Colors.black),
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
                                                    left: 10, right: 10),
                                                child: SizedBox(
                                                    child: Icon(
                                                      Icons.call,
                                                      color: Colors.yellow,
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
                                        child: serExImg.isEmpty?Icon(Icons.account_circle_rounded,color: Colors.black,size: 50,):
                                        CircleAvatar(radius:25,backgroundImage: NetworkImage(serExImg)),),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                   SizedBox(height: 10,),
                   Divider(),
                   SizedBox(height: 10,),
                   rules_status? Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 11.0, left: 11.0, right: 11.0),
                          child: Text(
                            rules_heading_text,
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ):SizedBox(),
                    SizedBox(
                      height: 5,
                    ),
                    rules_status? ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: rules.length,
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
                                          const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Text(
                                            rules[index],
                                            style: TextStyle(
                                                color: Colors.black45, fontSize: 14.0),
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
                    inclusion_status?Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 11, left: 11, right: 11),
                          child: Text(
                           inclusion_heading_text,
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ):SizedBox(),
                    SizedBox(
                      height: 5,
                    ),
                    inclusion_status?ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: inc.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Icon(
                                    Icons.circle,
                                    color: Colors.green,
                                    size: 16.0,
                                  ),
                                ),
                                Text(
                                  inc[index],
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 14.0),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        );
                      },
                    ):SizedBox(),
                    SizedBox(
                      height: 5.0,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    can_cancel?GestureDetector(
                      onTap: () async {
                        print("iiiiiii"+id);
                        bool chk = await  Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CancelActionPage(id: id,rideId: rideId,isUser: true,request_type:request_type)));
                        if(chk!=null){
                          if(chk){
                            setState((){
                              can_cancel = false;
                            });
                          }
                        }
                      },
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
                                  'Cancel Ride',
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
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        String url = prefs.getString('cancellation_policy_url') ?? "";
                        if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
                      },
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
                                  'Cancellation Policy',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16.0),
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
                    ),
                    SizedBox(
                      height: 20.0,
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
