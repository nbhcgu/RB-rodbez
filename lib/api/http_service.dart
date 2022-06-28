import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class API {
  static const baseUrl = "https://rodbez.in/rb_api/v0/";
  static const apiKey = "23456930fdda56f369fb0d62550dbf39";
  static Future appSetting() async {
    var url = baseUrl + "rb_user/app_setting";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future login(String mobile, String type, dId,fId) async {
    var url = baseUrl + "rb_user/put";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_mobile'] = mobile;
    map['user_type'] = type;
    map['device_id'] = dId;
    map['fbase_id'] = fId;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future nameSet(String user_id, String user_name) async {
    var url = baseUrl + "rb_user/update_name";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_name'] = user_name;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future userDetails(String user_id, String user_token) async {
    var url = baseUrl + "rb_user/user_details";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_token'] = user_token;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future searchLocation(String user_id, String user_token, String search_key) async {
    var url = baseUrl + "rb_ride_request/location_search";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_token'] = user_token;
    map['search_key'] = search_key;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future updateProfile(String user_id, String user_token, String user_name, String user_email) async {
    var url = baseUrl + "rb_user/update";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_token'] = user_token;
    map['user_name'] = user_name;
    map['user_email'] = user_email;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future rideList(String user_id, String user_token, String search_type, String page_number) async {
    var url = baseUrl + "rb_ride_request/my_rides_list";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_token'] = user_token;
    map['search_type'] = search_type;
    map['page_number'] = page_number;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future rideListDriver(String user_id, String user_token, String search_type, String page_number, String list_type) async {
    var url = baseUrl + "rb_ride_request/driver_rides";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_token'] = user_token;
    map['search_type'] = search_type;
    map['page_number'] = page_number;
    map['list_type'] = list_type;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future rideDetails(String user_id, String user_token, String ride_id, String request_type) async {
    var url = baseUrl + "rb_ride_request/ride_details";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_token'] = user_token;
    map['ride_id'] = ride_id;
    map['request_type'] = request_type;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future rideReview(String user_id, String user_token, String ride_id, String rating, String comment, String user_type) async {
    var url = baseUrl + "rb_ride_request/review_ride";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_token'] = user_token;
    map['ride_id'] = ride_id;
    map['rating'] = rating;
    map['comment'] = comment;
    map['user_type'] = user_type;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future rideCancel(String user_id, String user_token, String ride_id, String reason_id, String cancel_text, String u_type, String request_type) async {
    var url = baseUrl + "rb_ride_request/cancel_ride";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_token'] = user_token;
    map['ride_id'] = ride_id;
    map['reason_id'] = reason_id;
    map['cancel_text'] = cancel_text;
    map['u_type'] = u_type;
    map['request_type'] = request_type;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future selfSearch(String user_id, String user_token, String origin_place, String origin_lat, String origin_long
      , String destination_place, String destination_lat, String destination_long, String origin_id, String destination_id
      , String location_type) async {
    var url = baseUrl + "rb_ride_request/self_search_ride";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_token'] = user_token;
    map['origin_place'] = origin_place;
    map['origin_lat'] = origin_lat;
    map['origin_long'] = origin_long;
    map['destination_place'] = destination_place;
    map['destination_lat'] = destination_lat;
    map['destination_long'] = destination_long;
    map['origin_id'] = origin_id;
    map['destination_id'] = destination_id;
    map['location_type'] = location_type;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future selfSearchDriver(String user_id, String user_token, String origin_place, String origin_lat, String origin_long
      , String destination_place, String destination_lat, String destination_long, String origin_id, String destination_id
      , String location_type) async {
    var url = baseUrl + "rb_ride_request/search_rider";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_token'] = user_token;
    map['origin_place'] = origin_place;
    map['origin_lat'] = origin_lat;
    map['origin_long'] = origin_long;
    map['destination_place'] = destination_place;
    map['destination_lat'] = destination_lat;
    map['destination_long'] = destination_long;
    map['origin_id'] = origin_id;
    map['destination_id'] = destination_id;
    map['location_type'] = location_type;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future searchRideDetails(String user_id, String user_token, String ride_id) async {
    var url = baseUrl + "rb_ride_request/rider_request_details";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_token'] = user_token;
    map['ride_id'] = ride_id;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future driverAcceptRide(String user_id, String user_token, String ride_id, String current_lat, String current_long) async {
    var url = baseUrl + "rb_ride_request/accept_ride";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_token'] = user_token;
    map['ride_id'] = ride_id;
    map['current_lat'] = current_lat;
    map['current_long'] = current_long;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future driverArrivedRide(String user_id, String user_token, String ride_id, String current_lat, String current_long) async {
    var url = baseUrl + "rb_ride_request/driver_arrived";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_token'] = user_token;
    map['ride_id'] = ride_id;
    map['current_lat'] = current_lat;
    map['current_long'] = current_long;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future driverStartRide(String user_id, String user_token, String ride_id, String current_lat, String current_long) async {
    var url = baseUrl + "rb_ride_request/start_trip";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_token'] = user_token;
    map['ride_id'] = ride_id;
    map['current_lat'] = current_lat;
    map['current_long'] = current_long;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future driverEndRide(String user_id, String user_token, String ride_id, String current_lat, String current_long,
       String distance_covered, String toll_parking) async {
    var url = baseUrl + "rb_ride_request/end_trip";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_token'] = user_token;
    map['ride_id'] = ride_id;
    map['current_lat'] = current_lat;
    map['current_long'] = current_long;
    map['distance_covered'] = distance_covered;
    map['toll_parking'] = toll_parking;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future driverCollectCash(String user_id, String user_token, String ride_id) async {
    var url = baseUrl + "rb_ride_request/cash_collect";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_token'] = user_token;
    map['ride_id'] = ride_id;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future sendInv(String user_id, String user_token, String ride_id, String email_id) async {
    var url = baseUrl + "rb_ride_request/send_invoice";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_token'] = user_token;
    map['ride_id'] = ride_id;
    map['email_id'] = email_id;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future acceptOffer(String user_id, String user_token, String offer_id, String origin_place, String origin_lat,
   String origin_long, String destination_place, String destination_lat, String destination_long) async {
    var url = baseUrl + "rb_ride_request/accept_offer";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_token'] = user_token;
    map['offer_id'] = offer_id;
    map['origin_place'] = origin_place;
    map['origin_lat'] = origin_lat;
    map['origin_long'] = origin_long;
    map['destination_place'] = destination_place;
    map['destination_lat'] = destination_lat;
    map['destination_long'] = destination_long;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future rideRequest(String user_id, String user_token, String origin_place, String origin_lat, String origin_long, String destination_place, String destination_lat, String destination_long, String request_date) async {
    var url = baseUrl + "rb_ride_request/driver_request";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_token'] = user_token;
    map['origin_place'] = origin_place;
    map['origin_lat'] = origin_lat;
    map['origin_long'] = origin_long;
    map['destination_place'] = destination_place;
    map['destination_lat'] = destination_lat;
    map['destination_long'] = destination_long;
    map['request_date'] = request_date;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future cancelPublished(String user_id, String user_token, String request_id) async {
    var url = baseUrl + "rb_ride_request/cancel_published";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_token'] = user_token;
    map['request_id'] = request_id;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future rideShedule(String user_id, String user_token, String origin_place, String origin_lat, String origin_long
      , String destination_place, String destination_lat, String destination_long, String distance, String time
      , String cab_type_id, String cost, String request_date, String ride_for, String rider_name, String rider_contact) async {
    var url = baseUrl + "rb_ride_request/schedule_ride";
    print(baseUrl);
    print(url);
    var map = new Map<String, String>();
    map['api_key'] = apiKey;
    map['user_id'] = user_id;
    map['user_token'] = user_token;
    map['origin_place'] = origin_place;
    map['origin_lat'] = origin_lat;
    map['origin_long'] = origin_long;
    map['destination_place'] = destination_place;
    map['destination_lat'] = destination_lat;
    map['destination_long'] = destination_long;
    map['distance'] = distance;
    map['time'] = time;
    map['cab_type_id'] = cab_type_id;
    map['cost'] = cost;
    map['request_date'] = request_date;
    map['ride_for'] = ride_for;
    map['rider_name'] = rider_name;
    map['rider_contact'] = rider_contact;
    print(map);
    return await http.post(
        Uri.parse(url),
        body: map
    );
  }
  static Future imgUpload(String user_id, String user_token,File file)async{
    ///MultiPart request
    var url = baseUrl + "rb_user/profile_pic";
    var request = http.MultipartRequest(
      'POST', Uri.parse(url),
    );
    request.files.add(
      http.MultipartFile(
        'user_pic',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: "file.jpeg",
        contentType: MediaType('image','jpeg'),
      ),
    );
    request.fields.addAll({
      "api_key":apiKey,
      "user_id":user_id,
      "user_token":user_token
    });
    print("request: "+request.toString());
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    print("This is response:"+response.body.toString());
    return response;
  }
  static Future cabUpload(String user_id, String user_token,File file)async{
    ///MultiPart request
    var url = baseUrl + "rb_user/upload_cab";
    var request = http.MultipartRequest(
      'POST', Uri.parse(url),
    );
    request.files.add(
      http.MultipartFile(
        'cab_pic',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: "file.jpeg",
        contentType: MediaType('image','jpeg'),
      ),
    );
    request.fields.addAll({
      "api_key":apiKey,
      "user_id":user_id,
      "user_token":user_token
    });
    print("request: "+request.toString());
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    print("This is response:"+response.body.toString());
    return response;
  }
  static Future dlUpload(String user_id, String user_token,File file)async{
    ///MultiPart request
    var url = baseUrl + "rb_user/upload_dl";
    var request = http.MultipartRequest(
      'POST', Uri.parse(url),
    );
    request.files.add(
      http.MultipartFile(
        'dl_pic',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: "file.jpeg",
        contentType: MediaType('image','jpeg'),
      ),
    );
    request.fields.addAll({
      "api_key":apiKey,
      "user_id":user_id,
      "user_token":user_token
    });
    print("request: "+request.toString());
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    print("This is response:"+response.body.toString());
    return response;
  }
  static Future aadharUpload(String user_id, String user_token,File file)async{
    ///MultiPart request
    var url = baseUrl + "rb_user/upload_aadhar";
    var request = http.MultipartRequest(
      'POST', Uri.parse(url),
    );
    request.files.add(
      http.MultipartFile(
        'aadhar_pic',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: "file.jpeg",
        contentType: MediaType('image','jpeg'),
      ),
    );
    request.fields.addAll({
      "api_key":apiKey,
      "user_id":user_id,
      "user_token":user_token
    });
    print("request: "+request.toString());
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    print("This is response:"+response.body.toString());
    return response;
  }
  static Future addDrverPic(String user_id, String user_token,File cab_pic,File driver_pic, String driver_name,
      String driver_mobile, String owner_name, String car_reg_number, String car_model)async{
    ///MultiPart request
    var url = baseUrl + "rb_user/become_driver";
    var request = http.MultipartRequest(
      'POST', Uri.parse(url),
    );
    if(cab_pic!=null){
      request.files.add(
        http.MultipartFile(
          'cab_pic',
          cab_pic.readAsBytes().asStream(),
          cab_pic.lengthSync(),
          filename: "cab_pic.jpeg",
          contentType: MediaType('image','jpeg'),
        ),
      );
    }
    if(driver_pic!=null){
      request.files.add(
        http.MultipartFile(
          'driver_pic',
          driver_pic.readAsBytes().asStream(),
          driver_pic.lengthSync(),
          filename: "driver_pic.jpeg",
          contentType: MediaType('image','jpeg'),
        ),
      );
    }
    request.fields.addAll({
      "api_key":apiKey,
      "user_id":user_id,
      "user_token":user_token,
      "driver_name":driver_name,
      "driver_mobile":driver_mobile,
      "owner_name":owner_name,
      "car_reg_number":car_reg_number,
      "car_model":car_model
    });
    print("request: "+request.toString());
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    print("This is response:"+response.body.toString());
    return response;
  }
  static Future addDrver(String user_id, String user_token, String driver_name,
      String driver_mobile, String owner_name, String car_reg_number, String car_model)async{
    ///MultiPart request
    var url = baseUrl + "rb_user/become_driver";
    var request = http.MultipartRequest(
      'POST', Uri.parse(url),
    );
    request.fields.addAll({
      "api_key":apiKey,
      "user_id":user_id,
      "user_token":user_token,
      "driver_name":driver_name,
      "driver_mobile":driver_mobile,
      "owner_name":owner_name,
      "car_reg_number":car_reg_number,
      "car_model":car_model
    });
    print("request: "+request.toString());
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    print("This is response:"+response.body.toString());
    return response;
  }
}
