import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:native_video_view/native_video_view.dart';
import 'package:rodbez/Customer/cus_cancel_status_page.dart';
import 'package:rodbez/Customer/cus_ride_page/assign_page.dart';
import 'package:rodbez/Customer/cus_ride_page/complete_page.dart';
import 'package:rodbez/Customer/cus_ride_page/confirm_page.dart';
import 'package:rodbez/Customer/cus_ride_page/pending_page.dart';
import 'package:rodbez/Driver/driver_ride_cancel_details_page.dart';
import 'package:rodbez/Driver/driver_ride_complete_details_page.dart';
import 'package:rodbez/Driver/driver_ride_confirmed.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverOffersPage extends StatefulWidget {
  @override
  DriverOffersPageState createState() => DriverOffersPageState();
}

class DriverOffersPageState extends State<DriverOffersPage> {
  bool offers = true;

  var offersList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOffers();
  }

  getOffers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ac = prefs.getString('offers') ?? "";
    setState(() {
      offersList = jsonDecode(ac);
    });
  }

  getUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ac = prefs.getString('updates') ?? "";
    setState(() {
      offersList = jsonDecode(ac);
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery
        .of(context)
        .size;
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
                        "Offers & Update",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(children: [
                Expanded(child:
                GestureDetector(
                  onTap: () {
                    setState(() {
                      offers = true;
                    });

                    getOffers();
                  },
                  child: Container(height: 40,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: offers ? Colors.black : Colors.white
                    ),
                    child: Center(child: Text("Offers", style: TextStyle(
                      color: offers ? Colors.white : Colors.black,
                      fontSize: 16,),)),
                  ),
                ),),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        offers = false;
                      });
                      getUpdate();
                    },
                    child: Container(height: 40,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: offers ? Colors.white : Colors.black
                      ),
                      child: Center(child: Text("Updates", style: TextStyle(
                        color: offers ? Colors.black : Colors.white,
                        fontSize: 16,),)),
                    ),
                  ),
                )
              ],),
            ),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 0),
                child: Divider(
                  height: 1,
                  color: Colors.grey,
                )),
            ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: offersList.length,
                itemBuilder: (context, index) {
                  return Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(offersList[index]["image_heading_text"], style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),),
                          Text(
                            offersList[index]["image_caption"],
                            style: TextStyle(
                                color: Colors.grey, fontSize: 15),),
                          SizedBox(height: 5,),
                          !offersList[index]["is_video"]? Image.network(offersList[index]["img_url"], height: 200,):
                          Container(
                            height: 200,
                            child: Center(
                              child: NativeVideoView(
                                keepAspectRatio: false,
                                showMediaController: true,
                                onCreated: (controller) {
                                  controller.setVideoSource(
                                    offersList[index]["img_url"],
                                    sourceType: VideoSourceType.network
                                  );
                                },
                                onPrepared: (controller, info) {
                                  debugPrint('NativeVideoView: Video prepared');
                                  controller.play();
                                },
                                onError: (controller, what, extra, message) {
                                  debugPrint(
                                      'NativeVideoView: Player Error ($what | $extra | $message)');
                                },
                                onCompletion: (controller) {
                                  debugPrint('NativeVideoView: Video completed');
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    color: Colors.white,
                    margin: EdgeInsets.fromLTRB(24, 20, 24, 0),
                  );
                }),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
