import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//Future<Album>
void createAlbum(String user_mobile) async {
  var request = http.MultipartRequest('POST', Uri.parse('http://rodbez.in/rb_api/v0/rb_user/check_mobile'));
  request.fields.addAll({
    'api_key': '23456930fdda56f369fb0d62550dbf39',
    'user_mobile': user_mobile
  });
  var response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  }
  else {
    print(response.reasonPhrase);
  }
  print(request);

   if (response.statusCode == 200) {
  //   // If the server did return a 201 CREATED response,
  //   // then parse the JSON.
   //return Album.fromJson(jsonDecode(response));
   } else {
  // If the server did not return a 201 CREATED response,
     // then throw an exception.
     throw Exception('Failed to create album.');
  }
}

class Album {
  final int id;
  final int api_key;
  final String user_mobile;

  const Album({required this.id,required this.api_key,required  this.user_mobile});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      api_key: json['api_key'],
      user_mobile: json['user_mobile'],
    );
  }
}

void main() {
  runApp(page());
}

class page extends StatefulWidget {
  page({key});

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<page> {
  final TextEditingController _controller = TextEditingController();
  Future<Album>? _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Create Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Create Data Example'),
        // ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futureAlbum == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Enter Mobile Number'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
             // _futureAlbum = createAlbum(_controller.text);
            });
          },
          child: const Text('Send'),
        ),
      ],
    );
  }

  FutureBuilder<Album> buildFutureBuilder() {
    return FutureBuilder<Album>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.user_mobile);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}