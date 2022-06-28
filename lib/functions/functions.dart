import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class MyHttp extends StatefulWidget {
   @override
  _MyHttpState createState() => _MyHttpState();
}

class _MyHttpState extends State<MyHttp> {
  int _counter =0;

  void _incrementCounter(){
    setState(() {
      _counter++;
    });
  }

  postData()async{
    try {
      var request = http.MultipartRequest('POST', Uri.parse('http://192.168.1.43:3000/api/acceptRide'));
      request.fields.addAll({
        'api_key': '23456930fdda56f369fb0d62550dbf39',
        'user_mobile': '8076213643',
        'user_type': 'user',
        'device_id': '123',
        'rideId':'1'
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      }
      else {
        print(response.reasonPhrase);
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("data"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times'),
            Text('$_counter',style: Theme.of(context).textTheme.headline4,),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: postData,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
