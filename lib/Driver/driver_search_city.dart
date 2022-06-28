import 'dart:async';
import 'dart:convert';
import 'dart:core';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rodbez/Customer/cus_home_page.dart';
import 'package:rodbez/Customer/cus_service_not_page.dart';
import 'package:rodbez/Driver/driver_find_ride_page.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:rodbez/functions/functions.dart';

// import 'package:rodbez/functions/map_page.dart';
import 'package:rodbez/styles/styles.dart';
import 'package:google_place/google_place.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverSearchCity extends StatefulWidget {
  DriverSearchCity({required this.cur_address,required this.cur_lat,required this.cur_long});

  final String cur_address;
  final String cur_lat;
  final String cur_long;
  @override
  DriverSearchCityState createState() => DriverSearchCityState();
}
class DriverSearchCityState extends State<DriverSearchCity> {
  final _startSearchFieldController = TextEditingController();
  final _endSearchFieldController = TextEditingController();
  late bool isStart = true;
  late Timer _debounce;
  late bool isSet = true;
  late String origin_place="", origin_lat="", origin_long="", destination_place="", destination_lat="", destination_long="",
      origin_id="", destination_id="",location_type="";

  selfSearch() async {
    if(origin_id.isEmpty || destination_id.isEmpty){
      Fluttertoast.showToast(
          msg: "Please select place",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }else
    {
    var kk = {"origin_place":origin_place,"origin_lat":origin_lat,"origin_long":origin_long,"destination_place":destination_place,
    "destination_lat":destination_lat,"destination_long":destination_long,"origin_id":origin_id,"destination_id":destination_id,
    "location_type":location_type};
    Navigator.push(context, MaterialPageRoute(builder: (context)=> DriverFindRidePage(selected_Place:kk)));
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startSearchFieldController.addListener((){
      //here you have the changes of your textfield
      print("value: ${_startSearchFieldController.text}");
      isStart = true;
      //use setState to rebuild the widget
      if(isSet){
        _getData(_startSearchFieldController.text);
      }else{
        isSet = true;
      }
    });
    _endSearchFieldController.addListener((){
      //here you have the changes of your textfield
      print("value: ${_endSearchFieldController.text}");
      isStart = false;
      //use setState to rebuild the widget
      if(isSet){
        _getData(_endSearchFieldController.text);
      }else{
        isSet = true;
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  List<dynamic> dataList = <dynamic>[];
  List<dynamic> searchList = <dynamic>[];
  _getData(String key) async {
    if(!key.isEmpty && key != origin_place && key != destination_place){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String id = prefs.getString('id') ?? "0";
      String idL = prefs.getString('user_login_token') ?? "0";
      print("user_id-"+id);
      print("user_login_token-"+idL);
      API.searchLocation(id,idL,key).then((response) {
        setState(() {
          var jVar = jsonDecode(response.body);
          print(jVar);
          if (jVar["status"] == 200) {
            dataList = json.decode(response.body)['data'];
            if(isStart){
              dataList.add({"location_id":"0","display_text":widget.cur_address,"place_heading":widget.cur_address,"google_place_id":"0","place_lat":widget.cur_lat,"place_long":widget.cur_long});
            }
          }
        });
      });
    }else{
      isSet = true;
    }
  }
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Stack(children: [
      Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // _futureAlbum = createAlbum(_controller.text);
                      });
                      Navigator.pop(context);
                      // cancelRideRequest();
                      // resetApp();
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Container(
                        margin: EdgeInsets.only(top: 40),
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          // border: Border.all(width: 2.0, color: Colors.grey[300]),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          size: 30.0,
                          color: Colors.black,
                        ),
                        // child: RaisedButton(
                        //   shape: new RoundedRectangleBorder(
                        //     borderRadius: new BorderRadius.circular(24.0),
                        //   ),
                        //   onPressed: (){
                        //     Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPage()));
                        //   },
                        //
                        // ),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 38),
                      child: Text(
                        'Destination',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                child: Column(children: [
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> TabWidget()));
                      // cancelRideRequest();
                      // resetApp();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Container(
                        // height: MediaQuery.of(context).size.height/13,
                        // width: MediaQuery.of(context).size.width/1.2,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                          child: TextField(
                            controller: _startSearchFieldController,
                            autofocus: false,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            decoration: InputDecoration(
                                icon:  const Icon(
                                  Icons.circle,
                                  color: Colors.green,
                                  size: 15,
                                ),
                                labelText: "Pick Up",
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18, color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                suffixIcon:IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _startSearchFieldController.clear();
                                          });
                                            origin_place = "";
                                            origin_lat = "";
                                            origin_long = "";
                                            origin_id = "";
                                        },
                                        icon: Icon(Icons.clear_outlined, color: Colors.grey,),
                                      )
                                    ),
                            onChanged: (value) {
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    child: Divider(
                        color: Colors.black
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> TabWidget()));
                      // cancelRideRequest();
                      // resetApp();
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Container(
                        // height: MediaQuery.of(context).size.height/13,
                        // width: MediaQuery.of(context).size.width/1.2,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                          child: TextField(
                            controller: _endSearchFieldController,
                            autofocus: false,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            decoration: InputDecoration(
                                icon:  const Icon(
                                  Icons.circle,
                                  color: Colors.red,
                                  size: 15,
                                ),
                                labelText: 'Destination ',
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18, color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                suffixIcon:IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _endSearchFieldController.clear();
                                    });
                                      destination_place = "";
                                      destination_lat = "";
                                      destination_long = "";
                                      destination_id = "";
                                  },
                                  icon: Icon(Icons.clear_outlined, color: Colors.grey,),
                                )
                            ),
                            onChanged: (value) {

                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),

      Container(
        margin: EdgeInsets.only(top:250, bottom: 100),
        child: ListView.builder(
          padding: EdgeInsets.zero,
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(
                  Icons.location_on_outlined,
                  color: Colors.black,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataList[index]["place_heading"].toString(),style: TextStyle(color: Colors.black, fontSize: 16),
                    ),Text(
                      dataList[index]["display_text"].toString(),style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                onTap: () async {
                  if(isStart){
                    origin_place = dataList[index]["display_text"].toString();
                    origin_lat = dataList[index]["place_lat"].toString();
                    origin_long = dataList[index]["place_long"].toString();
                    origin_id = dataList[index]["location_id"].toString();
                    if(origin_id=="0"){
                      location_type = "current";
                    }else{
                      location_type = "db";
                    }
                    setState((){
                      _startSearchFieldController.text = origin_place;
                      isSet = false;
                    });
                  }else{
                    destination_place = dataList[index]["display_text"].toString();
                    destination_lat = dataList[index]["place_lat"].toString();
                    destination_long = dataList[index]["place_long"].toString();
                    destination_id = dataList[index]["location_id"].toString();
                    setState((){
                      _endSearchFieldController.text = destination_place;
                      isSet = false;
                    });
                  }
                  setState((){
                    dataList  = <dynamic>[];
                  });
                },
              );
            }),
      ),
      Positioned(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 0,
        right: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50,
            child: RaisedButton(
              child: Text("Done"),
              color: Colors.black,
              elevation: 5,
              textColor: Colors.white,
              onPressed: () {
                selfSearch();
              },
            ),
          ),
        ),
      ),
    ]);
  }
}
