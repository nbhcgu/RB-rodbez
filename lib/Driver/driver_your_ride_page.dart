import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rodbez/Customer/cus_cancel_status_page.dart';
import 'package:rodbez/Customer/cus_ride_page/assign_page.dart';
import 'package:rodbez/Customer/cus_ride_page/complete_page.dart';
import 'package:rodbez/Customer/cus_ride_page/confirm_page.dart';
import 'package:rodbez/Customer/cus_ride_page/pending_page.dart';
import 'package:rodbez/Driver/driver_publish_page.dart';
import 'package:rodbez/Driver/driver_ride_cancel_details_page.dart';
import 'package:rodbez/Driver/driver_ride_complete_details_page.dart';
import 'package:rodbez/Driver/driver_ride_confirmed.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverYourRidePage extends StatefulWidget {
  @override
  DriverYourRidePageState createState() => DriverYourRidePageState();
}

class DriverYourRidePageState extends State<DriverYourRidePage> {
  List<dynamic> dataList = <dynamic>[];
  List<dynamic> detailsList = <dynamic>[];
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  bool yourRide = true;
  String list_type = "booking";
  int _page = 1;
  int _limit = 15;
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;
  _getData() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String idL = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    print("user_login_token-" + idL);
    API.rideListDriver(id, idL, "all",_page.toString(),list_type).then((response) {
      EasyLoading.dismiss();
      setState(() {
        _refreshController.refreshCompleted();
        _refreshController.loadComplete();
        print(response.body);
        var jVar = jsonDecode(response.body);
        if (jVar["status"] == 200) {
          final List fetchedPosts = json.decode(response.body)['data'];
          dataList = json.decode(response.body)['data'];
          if(fetchedPosts.length<_limit){
            _hasNextPage = false;
          }
        }
        _isFirstLoadRunning = false;
      });
    });
  }

  late ScrollController _controller;
  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String id = prefs.getString('id') ?? "0";
      String idL = prefs.getString('user_login_token') ?? "0";
      print("user_id-" + id);
      print("user_login_token-" + idL);
      API.rideListDriver(id, idL, "all",_page.toString(),list_type).then((response) {
        setState(() {
          var jVar = jsonDecode(response.body);
          print(jVar);
          if (jVar["status"] == 200) {
            final List fetchedPosts = json.decode(response.body)['data'];
            dataList.add(fetchedPosts);
            if(fetchedPosts.length<_limit){
              _hasNextPage = false;
            }
          }
          _isFirstLoadRunning = false;
        });
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
    _controller = new ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }
  _getDtails(String rideId, String req, int index) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String idL = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    print("user_login_token-" + idL);
    API.rideDetails(id, idL, rideId,req).then((response) {
      EasyLoading.dismiss();
      setState(() async {
        print(dataList[index]["status_type"]);
        print(response.body);
        var jVar = jsonDecode(response.body);
        if (jVar["status"] == 200) {
          var kVar = jVar['data'];
          if(yourRide) {
           // 0-assigned,1-confirmed,2-pending,3-cancelled,4-completed,5-arrived,6-started
            if (dataList[index]["status_type"] == 0 ||dataList[index]["status_type"] == 1 || dataList[index]["status_type"] == 5 || dataList[index]["status_type"] == 6) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DriverRideConfirmedPage(searchList: kVar,status_type: dataList[index]["status_type"],)));
            } else if (dataList[index]["status_type"] == 2) {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DriverPublishPage(message: "widget.message",
                              caption: "widget.caption",
                              start_lat: "",
                              start_long:"",
                              start_address: kVar["start_location"].toString(),
                              end_lat:kVar["destination_lat"],
                              end_long: kVar["destination_long"],
                              end_address: kVar["end_location"].toString(),
                              cab_icon: kVar["cab_icon"],
                              cab_type: kVar["cab_type"],
                              date:kVar["ride_date"],
                              driver_publish_page_msg_heading_status:kVar["driver_publish_page_msg_heading_status"],
                              driver_publish_page_msg_heading:kVar["driver_publish_page_msg_heading"],
                              driver_publish_page_msg:kVar["driver_publish_page_msg"],
                              ride_id:kVar["ride_id"],
                              display_id:kVar["display_id"]
                          )));
              _getData();
            } else if (dataList[index]["status_type"] == 3) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DriverRideCanceDetailsPage(
                              id: dataList[index]["ride_id"],
                              list_type: dataList[index]["list_type"]
                                  .toString())));
            } else if (dataList[index]["status_type"] == 4) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DriverRideCompleteDetailsPage(
                              id: dataList[index]["ride_id"],
                              list_type: dataList[index]["list_type"]
                                  .toString())));
            }
          }else{
         await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DriverPublishPage(message: "widget.message",
                            caption: "widget.caption",
                            start_lat: "",
                            start_long:"",
                            start_address: kVar["start_location"].toString(),
                            end_lat:kVar["destination_lat"],
                            end_long: kVar["destination_long"],
                            end_address: kVar["end_location"].toString(),
                            cab_icon: kVar["cab_icon"],
                            cab_type: kVar["cab_type"],
                            date:kVar["ride_date"],
                            driver_publish_page_msg_heading_status:kVar["driver_publish_page_msg_heading_status"],
                            driver_publish_page_msg_heading:kVar["driver_publish_page_msg_heading"],
                            driver_publish_page_msg:kVar["driver_publish_page_msg"],
                            ride_id:kVar["ride_id"],
                            display_id:kVar["display_id"]
                        )));
          _getData();
          }
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (() {
                      Navigator.pop(context);
                    }),
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
                      // child: RaisedButton(
                      //   color: Colors.white,
                      //   shape: new RoundedRectangleBorder(
                      //     borderRadius: new BorderRadius.circular(5.0),
                      //   ),
                      //   onPressed: () {
                      //   },
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
                        "Your Ride",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(children: [
                  Expanded(child: GestureDetector(
                  onTap: (){
                    setState((){
                      yourRide = true;
                      list_type = "booking";
                      _getData();
                    });
                  },
                  child: Container(height: 40,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: yourRide? Colors.black:Colors.white
                    ),
                    child: Center(child: Text("Your Ride", style: TextStyle(color:  yourRide? Colors.white:Colors.black,fontSize: 16,),)),
                  ),
                ),),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      setState((){
                        yourRide = false;
                        list_type = "published";
                        _getData();
                      });
                    },
                    child: Container(height: 40,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: yourRide? Colors.white:Colors.black
                      ),
                      child: Center(child: Text("Published Ride", style: TextStyle(color: yourRide? Colors.black:Colors.white,fontSize: 16,),)),
                    ),
                  ),
                )
              ],),
            ),
            Container(
                margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                child: Divider(
                  height: 1,
                  color: Colors.grey,
                )),
            Expanded(
              child: SmartRefresher(
                header: WaterDropHeader(),
                onRefresh:_getData,
                controller: _refreshController,
                child: ListView.builder(
                  controller: _controller,
                  padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              _getDtails(dataList[index]["ride_id"], dataList[index]["list_type"].toString(), index);
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              15, 0, 00, 0),
                                          child: Text(
                                            dataList[index]["cab_type"],
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight:
                                                    FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          child: Align(
                                            alignment:
                                                Alignment.centerRight,
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0.0, 0, 10, 0),
                                              child: Text(
                                                dataList[index]["display_id"],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Align(
                                                  alignment: Alignment
                                                      .centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets
                                                            .fromLTRB(
                                                                15.0,
                                                                0,
                                                                0,
                                                                0),
                                                    child: Text(
                                                      dataList[index]["display_date"],
                                                      // textAlign: TextAlign.center,
                                                      style:
                                                          TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(width: 15,),
                                                Text(
                                                  'Status',
                                                  // textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                SizedBox(width: 10,),
                                                Text(
                                                  dataList[index]["ride_status"],
                                                  // textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color:dataList[index]["status_type"]==2? Colors
                                                        .orangeAccent:dataList[index]["status_type"]==1? Colors
                                                        .green:dataList[index]["status_type"]==0? Colors.
                                                    blue[900]:dataList[index]["status_type"]==3? Colors.
                                                    red:Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0.0, 0, 10, 0),
                                          child: Text(
                                           "₹ "+ dataList[index]["total_amount"].toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Text("Mini Cab", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),),
                                              Padding(
                                                padding: const EdgeInsets
                                                        .fromLTRB(
                                                    10, 10, 00, 0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      color: Colors.green,
                                                      size: 10,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets
                                                                  .fromLTRB(
                                                              20,
                                                              0,
                                                              0,
                                                              0),
                                                      child: Text(

                                                        dataList[index]["start_location"].length>22?dataList[index]["start_location"].substring(0,22)+"...":dataList[index]["start_location"],
                                                        style: TextStyle(
                                                            fontSize:
                                                                16.0,
                                                            color: Colors
                                                                .grey,),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets
                                                        .fromLTRB(
                                                    10, 10, 00, 0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      color: Colors.red,
                                                      size: 10,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets
                                                                  .fromLTRB(
                                                              20,
                                                              0,
                                                              0,
                                                              0),
                                                      child: Text(dataList[index]["end_location"].length>22?dataList[index]["end_location"].substring(0,22)+"...":dataList[index]["end_location"],
                                                        style: TextStyle(
                                                            fontSize:
                                                                16.0,
                                                            color: Colors
                                                                .grey),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 40.0,
                                            width: 40.0,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
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
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 0.2,
                                    blurRadius: 3.0,
                                    color: Colors.black38,
                                    offset: Offset(0.5, 0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    }),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

}
