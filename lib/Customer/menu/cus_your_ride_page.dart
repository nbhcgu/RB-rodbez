import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rodbez/Customer/cus_ride_page/assign_page.dart';
import 'package:rodbez/Customer/cus_ride_page/complete_page.dart';
import 'package:rodbez/Customer/cus_ride_page/confirm_page.dart';
import 'package:rodbez/Customer/cus_ride_page/cus_ride_start.dart';
import 'package:rodbez/Customer/cus_ride_page/pending_page.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cus_cancel_status_page.dart';

class CustomerYourRidePage extends StatefulWidget {
  @override
  _YourRidePageState createState() => _YourRidePageState();
}

class _YourRidePageState extends State<CustomerYourRidePage> {
  List<dynamic> dataList = <dynamic>[];
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  int _page = 1;
  int _limit = 15;
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;
  Future<void> _getData() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String idL = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    print("user_login_token-" + idL);
    API.rideList(id, idL, "all",_page.toString()).then((response) {
      setState(() {
        print(response.body);
        _refreshController.refreshCompleted();
        _refreshController.loadComplete();
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
      API.rideList(id, idL, "all",_page.toString()).then((response) {
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
        print(response.body);
        var jVar = jsonDecode(response.body);
        if (jVar["status"] == 200) {
          var kVar = jVar['data'];
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CusRideStartPage(searchList: kVar,status_type: dataList[index]["status_type"],)));
        }
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
            Container(
                margin: EdgeInsets.all(20),
                child: Divider(
                  thickness: 2,
                  color: Colors.grey[200],
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
                            onTap: () async {
                            //  0-assign,1-confirmed,3-cancelled,4-completed,(2-pending,5-started ---
                              //  ye dono driver k case k liye use hoga mainly)
                              EasyLoading.show();
                             await Timer(Duration(seconds: 2), () {
                               EasyLoading.dismiss();
                               if(dataList[index]["status_type"]==1||dataList[index]["status_type"]==2){
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (context) =>
                                             CustomerPendingPage(id:dataList[index]["ride_id"],type:dataList[index]["status_type"].toString(),list_type:dataList[index]["list_type"].toString())));
                               }
                               else if(dataList[index]["status_type"]==0||dataList[index]["status_type"]==5){
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (context) =>
                                             CustomerAssignPage(id:dataList[index]["ride_id"],list_type:dataList[index]["list_type"].toString(),
                                             is_started:false,)));
                               }  else if(dataList[index]["status_type"]==6){
                                 _getDtails(dataList[index]["ride_id"], dataList[index]["list_type"].toString(), index);
                               }
                               else if(dataList[index]["status_type"]==3){
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (context) =>
                                             CustomerCancelPage(id:dataList[index]["ride_id"],list_type:dataList[index]["list_type"].toString())));
                               }
                               else if(dataList[index]["status_type"]==4){
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (context) =>
                                             CustomerCompletePage(id:dataList[index]["ride_id"],list_type:dataList[index]["list_type"].toString())));
                               }
                             });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(0),
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
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  15, 0, 00, 0),
                                              child: Text(
                                                dataList[index]["cab_type"].toString(),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
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
                                                      fontSize: 12,
                                                      color: Colors.grey
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
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: SizedBox(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: FittedBox(
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
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5,),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Align(
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
                                                            'Status',
                                                            // textAlign: TextAlign.center,
                                                            style:
                                                                TextStyle(
                                                              fontSize: 14,
                                                                  color: Colors.grey[800],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets
                                                                  .fromLTRB(
                                                                      0.0,
                                                                      0,
                                                                      0,
                                                                      0),
                                                          child: Text(
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
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
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
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                      Flexible(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      20,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              child: Text(
                                                                 dataList[index]["start_location"],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                    color: Colors
                                                                        .grey,overflow: TextOverflow.ellipsis),
                                                                maxLines: 2,
                                                              ),
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
                                                        Flexible(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      20,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              child: Text(
                                                                dataList[index]["end_location"],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                    color: Colors
                                                                        .grey,overflow: TextOverflow.ellipsis),
                                                                maxLines: 2,
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
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
