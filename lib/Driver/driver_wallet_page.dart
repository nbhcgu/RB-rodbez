import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodbez/Customer/cus_cancel_status_page.dart';
import 'package:rodbez/Customer/cus_ride_page/assign_page.dart';
import 'package:rodbez/Customer/cus_ride_page/complete_page.dart';
import 'package:rodbez/Customer/cus_ride_page/confirm_page.dart';
import 'package:rodbez/Customer/cus_ride_page/pending_page.dart';
import 'package:rodbez/Driver/driver_ride_cancel_details_page.dart';
import 'package:rodbez/Driver/driver_ride_complete_details_page.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverWalletPage extends StatefulWidget {
  @override
  DriverWalletPageState createState() => DriverWalletPageState();
}

class DriverWalletPageState extends State<DriverWalletPage> {
  List<dynamic> dataList = <dynamic>[];
  bool isDebit = true;
  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String idL = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    print("user_login_token-" + idL);
    // API.rideList(id, idL, "all").then((response) {
    //   setState(() {
    //     var jVar = jsonDecode(response.body);
    //     print(jVar);
    //     if (jVar["status"] == 200) {
    //       dataList = json.decode(response.body)['data'];
    //     }
    //   });
    // });
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
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
            Row(children: [
              Expanded(child: Row(children: [
                Text("Balance", style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("10", style: TextStyle(color: Colors.red,fontSize: 18,fontWeight: FontWeight.bold),),
                )
              ],)),
              GestureDetector(
                onTap: (){
                  setState((){
                    isDebit = false;
                  });
                },
                child: Container(height: 40,
                  padding: EdgeInsets.only(left: 20,right: 20),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: isDebit? Colors.white:Colors.black
                  ),
                  child: Center(child: Text("Pay Now", style: TextStyle(color: isDebit? Colors.black:Colors.white,fontSize: 16,),)),
                ),
              ),
            ],),
            Container(
                margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                child: Divider(
                  height: 1,
                  color: Colors.grey,
                )),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(children: [
                  Expanded(child:
                GestureDetector(
                  onTap: (){
                    setState((){
                      isDebit = true;
                    });
                  },
                  child: Expanded(child: Container(height: 40,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: isDebit? Colors.black:Colors.white
                    ),
                    child: Center(child: Text("Debit", style: TextStyle(color:  isDebit? Colors.white:Colors.black,fontSize: 16,),)),
                  )),
                ),),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      setState((){
                        isDebit = false;
                      });
                    },
                    child: Container(height: 40,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: isDebit? Colors.white:Colors.black
                      ),
                      child: Center(child: Text("Credit", style: TextStyle(color: isDebit? Colors.black:Colors.white,fontSize: 16,),)),
                    ),
                  ),
                )
              ],),
            ),
            Expanded(
              child: ListView.builder(
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
                          //  0-assign,1-confirmed,3-cancelled,4-completed,(2-pending,5-started ---
                            //  ye dono driver k case k liye use hoga mainly)
                           if(dataList[index]["status_type"]==1||dataList[index]["status_type"]==2){
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) =>
                                         CustomerPendingPage(id:dataList[index]["ride_id"],type:dataList[index]["status_type"].toString(),list_type:dataList[index]["list_type"].toString())));
                           }else if(dataList[index]["status_type"]==0){
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) =>
                                         CustomerAssignPage(id:dataList[index]["ride_id"],list_type:dataList[index]["list_type"].toString(), is_started: false)));
                           }else if(dataList[index]["status_type"]==3){
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) =>
                                         DriverRideCanceDetailsPage(id:dataList[index]["ride_id"],list_type:dataList[index]["list_type"].toString())));
                           }else if(dataList[index]["status_type"]==4){
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) =>
                                         DriverRideCompleteDetailsPage(id:dataList[index]["ride_id"],list_type:dataList[index]["list_type"].toString())));
                           }
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
                                              dataList[index]["cab_type"],
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
                                                    fontSize: 16,
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
                                                              'Status',
                                                              // textAlign: TextAlign.center,
                                                              style:
                                                                  TextStyle(
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
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
                                                                        0.0,
                                                                        0,
                                                                        0,
                                                                        0),
                                                            child: Text(
                                                              dataList[index]["ride_status"],
                                                              // textAlign: TextAlign.center,
                                                              style:
                                                                  TextStyle(
                                                                fontSize: 16,
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
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
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
                                                fontSize: 16,
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
                                                        child: FittedBox(
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
                                                                      18.0,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
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
                                                        child: FittedBox(
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
                                                                      18.0,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
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
                                    blurRadius: 9.0,
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
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
