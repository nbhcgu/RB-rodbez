import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rodbez/Customer/cus_home_page.dart';
import 'package:rodbez/Driver/driver_home_page.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'accept_widget.dart';

class ReviewPage extends StatefulWidget
{
  ReviewPage(
      {required this.id,required this.rideId,required this.user_type,required this.type});
  final String id;
  final String rideId;
  final String user_type;
  final int type;

  @override
  ReviewPageState createState() => ReviewPageState();
}
class ReviewPageState extends State<ReviewPage> {
  double _userRating = 0.0;
  IconData? _selectedIcon;
  TextEditingController  reviewController = TextEditingController();
  String rating = "0";

  setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String idL = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    print("user_login_token-" + idL);
    API.rideReview(id, idL, widget.id,rating,reviewController.text.toString(),widget.user_type).then((response) {
      setState(() {
        var jVar = jsonDecode(response.body);
        print(jVar);
        Fluttertoast.showToast(
            msg: jVar["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
          if(widget.user_type=="user"){
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => new CustomerHomePage()),
                    (Route<dynamic> route) => false);
          }else{
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => new DriverPage()),
                    (Route<dynamic> route) => false);
          }
      });
    });
  }

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
                      if(widget.type==1){
                        if(widget.user_type=="user"){
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => new CustomerHomePage()),
                                  (Route<dynamic> route) => false);
                        }else{
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => new DriverPage()),
                                  (Route<dynamic> route) => false);
                        }
                      }else{
                        Navigator.pop(context);
                      }
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
                            "Review",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),Text(
                            "Ride Id "+widget.rideId,
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
              child: RatingBar.builder(
                initialRating: 1,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              )
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child:
              Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: 150,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: reviewController,
                          keyboardType: TextInputType.text,
                          maxLines: 8,
                          decoration: new InputDecoration.collapsed(
                            hintText: "Enter your comment",
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize:18.0,
                            ),
                          ),
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
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
                margin: EdgeInsets.fromLTRB(24,70,24,0),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: double.infinity,
                child: RaisedButton(
                  child: Text("Done"),
                  color: Colors.black,
                  elevation: 5,
                  textColor: Colors.white,
                  onPressed: () {
                    setData();
                  },
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
