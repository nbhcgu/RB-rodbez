import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rodbez/Customer/cus_home_page.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:rodbez/Customer/cus_ride_page/gotit.dart';

// import 'package:rodbez/ride/arrived_page.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerSchedulePage extends StatefulWidget {
  static const String idScreen = "login";

  CustomerSchedulePage(
      {required this.searchList,
        required this.cabIndex,
        required this.start_address,
        required this.start_lat,
        required this.start_long,
        required this.end_address,
        required this.end_lat,
        required this.end_long});

  final List<dynamic> searchList;
  final String start_address;
  final String start_lat;
  final String start_long;
  final String end_address;
  final String end_lat;
  final String end_long;
  final int cabIndex;

  @override
  CustomerSchedulePageState createState() => CustomerSchedulePageState();
}

class CustomerSchedulePageState extends State<CustomerSchedulePage> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController mobileTextEditingController = TextEditingController();
  DateTime _dateTime = DateTime.now();
  bool mySelf = true;
  bool isGo = false;
  DateTime _curTime = DateTime.now();
  List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  late String ride_for, rider_name,rider_contact;
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  void initState() {
    getRiderSelf();
  }
  getRiderSelf() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    rider_name = prefs.getString('user_name') ?? "";
    rider_contact = prefs.getString('user_mobile') ?? "";
    ride_for = "self";
  }
  sheduleRide() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String idL = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    print("user_login_token-" + idL);
    API.rideShedule(id, idL, widget.start_address,widget.start_lat,widget.start_long,widget.end_address,
        widget.end_lat,widget.end_long,widget.searchList[widget.cabIndex]["distance"],widget.searchList[widget.cabIndex]["time"],
        widget.searchList[widget.cabIndex]["cab_type_id"],widget.searchList[widget.cabIndex]["cost"],
        '${_dateTime.day} ${months[_dateTime.month - 1]}, ${_dateTime.hour}:${_dateTime.minute}',ride_for,rider_name,rider_contact).then((response) {
      EasyLoading.dismiss();
      var jVar = jsonDecode(response.body);
      print(jVar);
      if (jVar["status"] == 200) {
        setState(() {
          isGo = true;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: [
            SingleChildScrollView(
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
                                  child: Text(
                                    "One-Way Trip",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
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
                                                      widget.start_address,
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
                                                      widget.end_address,
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
                        GestureDetector(
                          onTap: () {
                            // Navigator.pop(context);
                            showModalBottomSheet(
                              context: context,
                              builder: (_) => Container(
                                height: 270,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                  ),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      spreadRadius: 0.5,
                                      blurRadius: 16.0,
                                      color: Colors.black54,
                                      offset: Offset(0.7, 0.7),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height:200,
                                      child: CupertinoDatePicker(
                                          initialDateTime: _dateTime,
                                          use24hFormat: true,
                                          onDateTimeChanged: (dateTime) {
                                            print(dateTime);
                                            setState(() {
                                              _dateTime = dateTime;
                                            });
                                          }),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: RaisedButton(
                                        child: Text("OK"),
                                        color: Colors.black,
                                        elevation: 5,
                                        textColor: Colors.white,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(0, 5, 10, 0),
                                  child: Icon(Icons.calendar_month,
                                      color: Colors.black, size: 24.0),
                                ),
                                Flexible(
                                  child: FittedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 05, 10, 0),
                                      child: Text(
                                        '${_dateTime.day} ${months[_dateTime.month - 1]}, ${_dateTime.hour}:${_dateTime.minute}',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.blueAccent[400]),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(0, 5, 10, 0),
                                  child: Icon(Icons.edit,
                                      color: Colors.black, size: 20.0),
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
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Someone else taking this ride?",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.searchList[widget
                                    .cabIndex][
                                "review_page_data"]
                                ["guest_select_text"],
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.black45,fontWeight: FontWeight.w300,),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      mySelf = !mySelf;
                                    });
                                    if(mySelf){
                                      getRiderSelf();
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      mySelf
                                          ? Container(
                                        height: 20.0,
                                        width: 20.0,
                                        margin:
                                        EdgeInsets.only(right: 20),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(
                                              30.0,
                                            ),
                                            border: Border.all(
                                                width: 5,
                                                color: Colors.black)
                                          // border: Border.all(width: 2.0, color: Colors.grey[300]),
                                        ),
                                      )
                                          : Container(
                                        height: 20.0,
                                        width: 20.0,
                                        margin:
                                        EdgeInsets.only(right: 20),
                                      ),
                                      Text(
                                        "My Self",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      mySelf = !mySelf;
                                    });
                                    if(mySelf){
                                      getRiderSelf();
                                    }
                                    if (!mySelf) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              insetPadding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      topRight:
                                                      Radius.circular(
                                                          20),
                                                      topLeft:
                                                      Radius.circular(
                                                          20))),
                                              //this right here
                                              child: Container(
                                                height: 320,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Center(
                                                        child: Container(
                                                          width: 70,
                                                          height: 7,
                                                          decoration:
                                                          BoxDecoration(
                                                              color: Colors
                                                                  .grey[
                                                              100],
                                                              borderRadius:
                                                              BorderRadius
                                                                  .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                    20.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                    20.0),
                                                                bottomLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                                bottomRight:
                                                                Radius.circular(
                                                                    20.0),
                                                              )),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "Enter Guest Details",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "Good Name",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        height: 50,
                                                        padding:
                                                        EdgeInsets.only(
                                                            left: 16,
                                                            right: 16),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                Colors.grey,
                                                                width: 1)),
                                                        child: Center(
                                                          child: TextField(
                                                            controller: nameTextEditingController,
                                                            keyboardType: TextInputType.name,
                                                            inputFormatters: [new FilteringTextInputFormatter(RegExp("[a-zA-Z]"), allow: true),],
                                                            decoration:
                                                            new InputDecoration
                                                                .collapsed(
                                                                hintText:
                                                                ''),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "Mobile Number",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        height: 50,
                                                        padding:
                                                        EdgeInsets.only(
                                                            left: 16,
                                                            right: 16,top: 16),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                Colors.grey,
                                                                width: 1)),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Center(
                                                            child: TextField(
                                                              inputFormatters: [LengthLimitingTextInputFormatter(10)],
                                                              controller: mobileTextEditingController,
                                                              decoration:
                                                              new InputDecoration
                                                                  (
                                                                  hintText:
                                                                  '',
                                                                border: UnderlineInputBorder(
                                                                  borderSide: BorderSide.none,
                                                                ),
                                                                // counter: Text("",style: TextStyle(fontSize: 0),),
                                                              ),
                                                              // maxLength: 10,
                                                              keyboardType:
                                                              TextInputType
                                                                  .number,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 16),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        height: 50,
                                                        child: RaisedButton(
                                                          onPressed: () {
                                                            if(nameTextEditingController.text.isEmpty||mobileTextEditingController.text.isEmpty){
                                                              Fluttertoast.showToast(
                                                                  msg: "Please fill guest details",
                                                                  toastLength: Toast.LENGTH_SHORT,
                                                                  gravity: ToastGravity.CENTER,
                                                                  timeInSecForIosWeb: 1,
                                                                  backgroundColor: Colors.red,
                                                                  textColor: Colors.white,
                                                                  fontSize: 16.0
                                                              );
                                                            }else{
                                                              ride_for = "guest";
                                                              rider_name = nameTextEditingController.text;
                                                              rider_contact = mobileTextEditingController.text;
                                                              Navigator.pop(context);
                                                            }
                                                          },
                                                          child: Text(
                                                            "Confirm",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          color: Colors.black,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      !mySelf
                                          ? Container(
                                        height: 20.0,
                                        width: 20.0,
                                        margin:
                                        EdgeInsets.only(right: 20),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(
                                              30.0,
                                            ),
                                            border: Border.all(
                                                width: 5,
                                                color: Colors.black)
                                          // border: Border.all(width: 2.0, color: Colors.grey[300]),
                                        ),
                                      )
                                          : Container(
                                        height: 20.0,
                                        width: 20.0,
                                        margin:
                                        EdgeInsets.only(right: 20),
                                      ),
                                      Text(
                                        "Guest",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.blueAccent),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                                              widget.searchList[widget.cabIndex]
                                              ["cab_type"],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              widget.searchList[widget.cabIndex]
                                              ["review_page_data"]
                                              ["cab_cat_text"],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            Text(
                                              widget.searchList[widget.cabIndex]
                                              ["luggage_text"],
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
                                          child: Image.network(
                                            widget.searchList[widget.cabIndex]
                                            ["cab_icon"],
                                            height: 50,
                                          ),
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
                        GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Container(
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
                                          flex: 1,
                                          child: SizedBox(
                                            child: FittedBox(
                                              child: Padding(
                                                padding: EdgeInsets.all(0.0),
                                                child: Text(
                                                  'Total Fare',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
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
                                                    '₹ ' +
                                                        widget.searchList[widget
                                                            .cabIndex][
                                                        "review_page_data"]
                                                        ["total_cost"],
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
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: SizedBox(
                                            child: FittedBox(
                                              child: Padding(
                                                padding: EdgeInsets.all(0.0),
                                                child: Text(
                                                  widget.searchList[
                                                  widget.cabIndex]
                                                  ["review_page_data"]
                                                  ["price_caption_text"],
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(flex: 1, child: SizedBox())
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Base Fare',
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
                                                    '₹ ' +
                                                        widget.searchList[widget
                                                            .cabIndex][
                                                        "review_page_data"]
                                                        ["base_fare"],
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
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            widget.searchList[widget
                                                .cabIndex][
                                            "review_page_data"]
                                            ["taxes_text"],
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
                                                    '₹ ' +
                                                        widget.searchList[widget
                                                            .cabIndex][
                                                        "review_page_data"]
                                                        ["taxes"],
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
                                  ],
                                ),
                              ),
                              // constraints: BoxConstraints(minWidth: 100, maxHeight: 200),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                        widget.searchList[widget.cabIndex]["review_page_data"]["rules_status"]?  Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 11.0, left: 11.0, right: 11.0),
                              child: Text(
                                widget.searchList[widget.cabIndex]["review_page_data"]["rules_heading_text"],
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ):SizedBox(),
                        SizedBox(
                          height: 5,
                        ),
                        widget.searchList[widget.cabIndex]["review_page_data"]["rules_status"]?ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: widget.searchList[widget.cabIndex]["review_page_data"]["rules_regulations_text"].length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      child: Icon(
                                        Icons.circle,
                                        color: Colors.red,
                                        size: 16.0,
                                      ),
                                    ),
                                    Flexible(
                                        child: FittedBox(
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              child: Text(
                                                widget.searchList[widget.cabIndex]["review_page_data"]["rules_regulations_text"][index],
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 12.0,fontWeight: FontWeight.w300,),
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
                        widget.searchList[widget.cabIndex]["review_page_data"]["inclusion_status"]? Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top:11,left:11,right:11),
                              child: Text(
                                widget.searchList[widget.cabIndex]["review_page_data"]["inclusion_heading_text"],
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,),
                              ),
                            ),
                          ],
                        ):SizedBox(),
                        SizedBox(
                          height: 5,
                        ),
                        widget.searchList[widget.cabIndex]["review_page_data"]["inclusion_status"]?ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: widget.searchList[widget.cabIndex]["review_page_data"]["ride_inclusion_text"].length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      child: Icon(
                                        Icons.circle,
                                        color: Colors.green,
                                        size: 16.0,
                                      ),
                                    ),
                                    Text(
                                      widget.searchList[widget.cabIndex]["review_page_data"]["ride_inclusion_text"][index],
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 14.0,fontWeight: FontWeight.w300,),
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
                                      'Cancellation Policy',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 18.0),
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            child: RaisedButton(
                              child: Text(
                                "Shedule Ride",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              color: Colors.black,
                              elevation: 5,
                              textColor: Colors.white,
                              onPressed: () async {
                                if(_dateTime.isAfter(_curTime)){
                                  sheduleRide();
                                }else{
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  String msg = prefs.getString('date_error_message') ?? "";
                                  Fluttertoast.showToast(
                                      msg: msg,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            isGo
                ? Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                color: Colors.black87,
              ),
            )
                : SizedBox(),
            isGo
                ? Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).viewInsets.bottom,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  height: media.height * 0.4,
                  // width: media.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    color: Colors.white,
                    // boxShadow: [
                    //   BoxShadow(
                    //     spreadRadius: 10.5,
                    //     blurRadius: 116.0,
                    //     // color: Colors.black54,
                    //     offset: Offset(0.7, 0.7),
                    //   ),
                    // ],
                  ),
                  // height: requestRideContainerHeight,

                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                            child: SizedBox(
                              height: 0.0,
                            )),
                        Container(
                          width: 70,
                          height: 7,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              )),
                        ),
                        Center(
                            child: SizedBox(
                              height: 10.0,
                            )),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(
                            "Ride Scheduled",
                            style: TextStyle(
                                fontSize: 23.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Your ride has been scheduled. You will get all the information related to your booking through Phone call and SMS. ",
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.grey,fontWeight: FontWeight.w300,),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Icon(
                            Icons.check_circle_outline,
                            size: 65.0,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            child: RaisedButton(
                              child: Text("Got it"),
                              color: Colors.black,
                              elevation: 5,
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CustomerHomePage()));
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}