import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


// import 'end_page.dart';

// import 'accept_widget.dart';

class CustomerCancelStatusPage extends StatefulWidget
{
  static const String idScreen = "MainImageWidget";
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  // static const String idScreen = "mainScreen";
  @override
  _ArrivedPageState createState() => _ArrivedPageState();
}

class _ArrivedPageState extends State<CustomerCancelStatusPage> {

  DateTime _dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("One-Way-Ride"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30.0,),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,0),
                    child: Container(
                      height: 80,
                      // width: 320,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(width: 0.0, color: Colors.white),
                        // image: DecorationImage( scale: 1,alignment: Alignment.centerLeft,
                        //   image: AssetImage("assets/pinn.png",),
                        // ),
                      ),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Text("Mini Cab", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10,10,00,0),
                            child: Row(
                              children: [
                                Icon(Icons.circle,color: Colors.green,size: 10,),
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .fromLTRB(
                                      20, 0, 0, 0),
                                  child: Text(
                                    "Saharsa Bihar India 852212",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors
                                            .grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10,0,10,0),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0,0,0,0),
                              child: Divider(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10,0,00,0),
                            child: Row(
                              children: [
                                Icon(Icons.circle,color: Colors.red,size: 10,),
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .fromLTRB(
                                      20, 0, 0, 0),
                                  child: Text(
                                    "Saharsa Bihar India 852212",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors
                                            .grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15,0,0,0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,5,20,0),
                    child: Icon(Icons.date_range, color: Colors.black, size: 23.0,),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,05,50,0),
                    child: Text(
                      '${_dateTime.day}/${_dateTime.month}/${_dateTime.year}, ${_dateTime.hour}:${_dateTime.minute}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0,),
            Divider(
              color: Colors.black,
            ),
            Padding(
              padding: EdgeInsets.all(0.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,22,00,0),
                    child: Text("   Mini Cab", style: TextStyle(fontSize: 20.0, color: Colors.black),),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(200,0,0,0),
                    child: Image.asset('assets/non veg.png', alignment: Alignment.bottomRight, height: 90.0, width: 90.0,),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Container(
                      height: 160,
                      // width: 320,
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(width: 0.0, color: Colors.grey),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 0.1,
                            blurRadius: 2.0,
                            color: Colors.grey,
                            offset: Offset(0.5, 0.5),
                          ),
                        ],
                        // image: DecorationImage( scale: 1,alignment: Alignment.centerLeft,
                        //   image: AssetImage("assets/pinn.png",),
                        // ),
                      ),
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text("Mini Cab", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon(Icons.circle,color: Colors.green,size: 10,),
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .fromLTRB(
                                      5, 5, 0, 0),
                                  child: Text(
                                    "Estimated Fare",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors
                                            .black,fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .fromLTRB(
                                      5, 5, 0, 0),
                                  child: Text(
                                    "Distance 125 km, Time 4 hr",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors
                                          .grey,),
                                  ),
                                ),
                                Divider(),
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .fromLTRB(
                                      5, 0, 0, 0),
                                  child: Text(
                                    "Base Fare",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors
                                            .grey),
                                  ),
                                ),
                                Divider(),
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .fromLTRB(
                                      5, 0, 0, 0),
                                  child: Text(
                                    "Taxes",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors
                                            .grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            SizedBox(height: 10.0,),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,22,100,0),
              child: Row(
                children: [
                  Text("   Status", style: TextStyle(fontSize: 18.0, color: Colors.black),),
                  Text("  Cancel", style: TextStyle(fontSize: 18.0, color: Colors.red),),
                ],
              ),
            ),
            SizedBox(height: 10.0,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                color: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 0.0,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,0,0),
                        child: Text("Message", style: TextStyle(fontSize: 23.0, color: Colors.black),),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,0,0),
                        child: Text("Your booking request has been received, please wait for few minutes your booking will accepted or rejected after we check the availability of cabs", style: TextStyle(fontSize: 16.0, color: Colors.grey),),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0,),

           SizedBox(height: 10.0,),
            SizedBox(height: 10.0,),
          ],
        ),
      ),
    );
  }
}
