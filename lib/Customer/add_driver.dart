import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:rodbez/api/http_service.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddDriver extends StatefulWidget {
  @override
  AddDriverState createState() => AddDriverState();
}

class AddDriverState extends State<AddDriver> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  TextEditingController carnoController = TextEditingController();
  TextEditingController carmodelController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  String name = "", email = "", mob = "", img = "",cab = "";
  int fileType=0;
  var driverImg,carImg;
  @override
  void initState() {
    getRiderSelf();
  }

  getRiderSelf() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('user_name') ?? "";
      mob = prefs.getString('user_mobile') ?? "";
      email = prefs.getString('user_email') ?? "";
      img = prefs.getString('disp_image') ?? "";
      cab = prefs.getString('cab_pic') ?? "";
      nameController.text = name;
      ownerController.text = name;
      mobileController.text = mob;
    });
  }

  final picker = ImagePicker();
  late File? _image;

  Future chooseFile(ImageSource source) async {
    final XFile? pickedFile = await picker.pickImage(source: source);
    setState(() {
      String? ss = pickedFile?.path;
      File? _image = new File(ss!);
      print(ss);
      cropFile(_image);
    });
  }

  Future<void> cropFile(File file) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    String? ss = croppedFile?.path;
    File? _image = new File(ss!);
    print(ss);
    if(fileType==0){setState((){driverImg=_image; img = _image.path;});}
    else if(fileType==1){setState((){carImg=_image;cab = _image.path;});}
  }

  Future setDriver() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String lid = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);

    var url = API.baseUrl + "rb_user/become_driver";
    var request = http.MultipartRequest(
      'POST', Uri.parse(url),
    );
    if(carImg!=null){
      request.files.add(
        http.MultipartFile(
          'cab_pic',
          carImg.readAsBytes().asStream(),
          carImg.lengthSync(),
          filename: "cab_pic.jpeg",
          contentType: MediaType('image','jpeg'),
        ),
      );
    }
    if(driverImg!=null){
      request.files.add(
        http.MultipartFile(
          'driver_pic',
          driverImg.readAsBytes().asStream(),
          driverImg.lengthSync(),
          filename: "driver_pic.jpeg",
          contentType: MediaType('image','jpeg'),
        ),
      );
    }
    request.fields.addAll({
      "api_key":API.apiKey,
      "user_id":id,
      "user_token":lid,
      "driver_name":nameController.text,
      "driver_mobile":mobileController.text,
      "owner_name":ownerController.text,
      "car_reg_number":carnoController.text,
      "car_model":carmodelController.text
    });
    print("request: "+request.toString());
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    print("This is response:"+response.body.toString());
    var jVar = jsonDecode(response.body);
    print(jVar["status"]);
    if (jVar["status"] == 200) {
      print("Loggin Google");
      EasyLoading.dismiss();
      prefs.setBool('become_driver', jVar["data"]["become_driver"]);
      Fluttertoast.showToast(
          msg: "Data updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Stack(children: [
      SingleChildScrollView(
        child: Container(
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
                          "Add Details",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 42, 0, 0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                      child: Column(
                        children: [
                          // Text("Unknown", style: TextStyle(fontSize: 23.0, color: Colors.black),),
                          // Text("Ph.no.", style: TextStyle(fontSize: 18.0, color: Colors.black45),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      fileType=1;
                                      chooseFile(ImageSource.gallery);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                      child: Stack(
                                        children: [
                                          carImg==null
                                              ? Container(
                                                  height: 70.0,
                                                  width: 70.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(60.0),
                                                    border: Border.all(
                                                        width: 2.0, color: Colors.grey),
                                                  ),
                                                  child: Image.asset("assets/non veg.png"),
                                                  // ),
                                                )
                                              : Container(
                                                  height: 70.0,
                                                  width: 70.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(60.0),
                                                  ),
                                                  child: CircleAvatar(
                                                      radius: 35,
                                                      backgroundImage:
                                                          FileImage(carImg))),
                                          Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(5))),
                                                  child: Image.asset(
                                                    'assets/edit.png',
                                                    width: 20,
                                                    height: 20,
                                                  )))
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text("Car Image", style: TextStyle(color: Colors.grey,fontSize: 18),)
                                ],
                              ),
                              SizedBox(width: 50,),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {fileType=0;
                                      chooseFile(ImageSource.gallery);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                      child: Stack(
                                        children: [
                                          driverImg!=null ?Container(
                                              height: 70.0,
                                              width: 70.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(60.0),
                                              ),
                                              child: CircleAvatar(
                                                  radius: 35,
                                                  backgroundImage:
                                                  FileImage(driverImg)))
                                          : img.isEmpty
                                              ? Container(
                                                  height: 70.0,
                                                  width: 70.0,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(60.0),
                                                    border: Border.all(
                                                        width: 2.0, color: Colors.grey),
                                                  ),
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 39.0,
                                                    color: Colors.white,
                                                  ),
                                                  // ),
                                                ): Container(
                                              height: 70.0,
                                              width: 70.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(60.0),
                                              ),
                                              child: CircleAvatar(
                                                  radius: 35,
                                                  backgroundImage:
                                                  NetworkImage(img))),
                                          Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(5))),
                                                  child: Image.asset(
                                                    'assets/edit.png',
                                                    width: 20,
                                                    height: 20,
                                                  )))
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text("Driver Image", style: TextStyle(color: Colors.grey,fontSize: 18),)
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 0,
              ),
              Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          inputFormatters: [new FilteringTextInputFormatter(RegExp("[a-zA-Z]"), allow: true),],
                          cursorColor: Colors.black,
                          // controller: nameTextEditingController,
                          decoration: new InputDecoration.collapsed(
                            hintText: "Driver Name",
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 18.0,
                            ),
                          ),
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Image.asset(
                            "assets/edit.png",
                            width: 20,
                            height: 20,
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
                margin: EdgeInsets.fromLTRB(24, 50, 24, 0),
              ),
              Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: ownerController,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.name,
                          inputFormatters: [new FilteringTextInputFormatter(RegExp("[a-zA-Z]"), allow: true),],
                          // controller: nameTextEditingController,
                          decoration: new InputDecoration.collapsed(
                            hintText: "Owner Name",
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 18.0,
                            ),
                          ),
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Image.asset(
                            "assets/edit.png",
                            width: 20,
                            height: 20,
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
                margin: EdgeInsets.fromLTRB(24, 10, 24, 0),
              ),
              Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: carnoController,
                          cursorColor: Colors.black,
                          // controller: nameTextEditingController,
                          decoration: new InputDecoration.collapsed(
                            hintText: "Car Reg Number",
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 18.0,
                            ),
                          ),
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Image.asset(
                            "assets/edit.png",
                            width: 20,
                            height: 20,
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
                margin: EdgeInsets.fromLTRB(24, 10, 24, 0),
              ),
              Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: carmodelController,
                          cursorColor: Colors.black,
                          // controller: nameTextEditingController,
                          decoration: new InputDecoration.collapsed(
                            hintText: "Car Model Name",
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 18.0,
                            ),
                          ),
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Image.asset(
                            "assets/edit.png",
                            width: 20,
                            height: 20,
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
                margin: EdgeInsets.fromLTRB(24, 10, 24, 0),
              ),
              Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: mobileController,
                          cursorColor: Colors.black,
                          // controller: nameTextEditingController,
                          decoration: new InputDecoration.collapsed(
                            hintText: "Mobile Number",
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 18.0,
                            ),
                          ),
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Image.asset(
                            "assets/edit.png",
                            width: 20,
                            height: 20,
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
                margin: EdgeInsets.fromLTRB(24, 10, 24, 0),
              ),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    child: Text("Done"),
                    color: Colors.black,
                    elevation: 5,
                    textColor: Colors.white,
                    onPressed: () {
                      if (nameController.text.isEmpty||ownerController.text.isEmpty||carnoController.text.isEmpty||
                          carmodelController.text.isEmpty||mobileController.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please enter all field",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        setDriver();
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ]);
  }
}
