import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rodbez/Customer/cus_cancel_status_page.dart';
import 'package:rodbez/Customer/cus_ride_page/assign_page.dart';
import 'package:rodbez/Customer/cus_ride_page/complete_page.dart';
import 'package:rodbez/Customer/cus_ride_page/confirm_page.dart';
import 'package:rodbez/Customer/cus_ride_page/pending_page.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerOfferPage extends StatefulWidget {
  CustomerOfferPage({required this.exclusive_offers,required this.origin_place,required this.origin_lat,
    required this.origin_long,required this.destination_place,required this.destination_lat,
    required this.destination_long});
  var exclusive_offers;
  String origin_place, origin_lat, origin_long, destination_place, destination_lat, destination_long;
  @override
  CustomerOfferPageState createState() => CustomerOfferPageState();
}

class CustomerOfferPageState extends State<CustomerOfferPage> {
  List<dynamic> dataList = <dynamic>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataList = widget.exclusive_offers["offer_data"];
    print(dataList);
  }

  acceptOffer(String offer_id ) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String idL = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    print("user_login_token-" + idL);
    API.acceptOffer(id, idL, offer_id,widget.origin_place,widget.origin_lat,widget.origin_long,widget.destination_place,
    widget.destination_lat,widget.destination_long)
        .then((response) {
      EasyLoading.dismiss();
      print(response.body);
      var jVar = jsonDecode(response.body);
      print(jVar);
      if (jVar["status"] == 200) {
        if (json.decode(response.body)['chk'] == 1) {
          var searchList = json.decode(response.body)['data'];
          Fluttertoast.showToast(
              msg: "Offer Accepted",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pop(context);
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
                        "Exclusive Offers",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.all(10),
                child: Divider(
                  thickness: 2,
                  color: Colors.grey[200],
                )),
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
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  content: Container(
                                    height: MediaQuery.of(context).size.height/2.5,
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/offer.png", width: 120,height:120),
                                        SizedBox(height: 15,),
                                        Text("There is no any change in the time and date for availing this offer.", style:TextStyle(color:Colors.grey[800], fontSize:16,fontWeight: FontWeight.w300)),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex:1,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8, bottom: 8, left: 0, right: 10),
                                                child: Container(
                                                  height: 50,
                                                  width: double.infinity,
                                                  child: RaisedButton(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(6),
                                                        side: BorderSide(width:0.1,color: Colors.black,)),
                                                    child: Text(
                                                      "Back",
                                                      style:
                                                      TextStyle(fontSize: 16, color: Colors.black),
                                                    ),
                                                    color: Colors.white,
                                                    elevation: 5,
                                                    textColor: Colors.white,
                                                    onPressed: () {
                                                      Navigator.pop(context);

                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex:1,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8, bottom: 8, left: 0, right: 0),
                                                child: Container(
                                                  height: 50,
                                                  width: double.infinity,
                                                  child: RaisedButton(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(6),
                                                        side: BorderSide(width:0.1,color: Colors.black,)),
                                                    child: Text(
                                                      "Book Now",
                                                      style:
                                                      TextStyle(fontSize: 16, color: Colors.white),
                                                    ),
                                                    color: Colors.black,
                                                    elevation: 5,
                                                    textColor: Colors.white,
                                                    onPressed: () {
                                                        Navigator.pop(context);
                                                        acceptOffer( dataList[index]["oid"]);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                            );
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
                                                dataList[index]["cab_type"],
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            child:
                                            dataList[index]["cab_icon"].isEmpty?Image.asset("assets/non veg.png",width: 50,height: 50):
                                            Image.network(dataList[index]["cab_icon"],width: 50,height: 50,),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
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
                                                        size: 15,
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
                                                               dataList[index]["source"],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  color: Colors
                                                                      .black45),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(50.0,0,0,0),
                                                  child: const Divider(
                                                    color: Colors.black26,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .fromLTRB(
                                                      10, 0, 00, 0),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.circle,
                                                        color: Colors.red,
                                                        size: 15,
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
                                                              dataList[index]["destination"],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  color: Colors
                                                                      .black45),
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
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Container(
                                      // height: MediaQuery.of(context).size.height/15,
                                      // width: 45.0,
                                      decoration: BoxDecoration(
                                        color: Colors.green[50],
                                        borderRadius: BorderRadius.circular(5.0),
                                        // border: Border.all(width: 2.0, color: Colors.grey[300]),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: Colors.grey.shade500,
                                        //     offset: Offset(0.0, 0.0),
                                        //     blurRadius: 5.0,
                                        //     spreadRadius: 0.0,
                                        //   ),
                                        // ],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(dataList[index]["valid_caption"], style: TextStyle(color: Colors.grey,fontSize: 14, fontWeight: FontWeight.w300),),
                                                Text(dataList[index]["start_time"]+" To "+dataList[index]["end_time"], style: TextStyle(color: Colors.black,fontSize: 14)),
                                                Text(dataList[index]["start_date"], style: TextStyle(color: Colors.black,fontSize: 14))
                                              ],
                                            ),
                                          )),
                                          Text("₹"+dataList[index]["offer_price"]+"/-", style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
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
                                    spreadRadius: 0.1,
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
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
