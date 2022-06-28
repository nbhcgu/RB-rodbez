import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodbez/Customer/cus_home_page.dart';
import 'package:rodbez/api/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverProfileSetting extends StatefulWidget {
  @override
  DriverProfileSettingState createState() => DriverProfileSettingState();
}

class DriverProfileSettingState extends State<DriverProfileSetting> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String name = "", email = "", mob = "", img = "",cab = "",dl = "",aadhar = "";
  int fileType=0;
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
      dl = prefs.getString('dl_pic') ?? "";
      aadhar = prefs.getString('aadhar_pic') ?? "";
      nameController.text = name;
      emailController.text = email;
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
    if(fileType==0){uploadFile(_image);}
    else if(fileType==1){uploadCab(_image);}
    else if(fileType==2){uploadDL(_image);}
    else if(fileType==3){uploadAadhar(_image);}
  }

  Future uploadFile(File file) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String lid = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    API.imgUpload(id, lid, file).then((response) {
      print(response);
      var jVar = jsonDecode(response.body);
      print(jVar["status"]);
      if (jVar["status"] == 200) {
        print("Loggin Google");
        EasyLoading.dismiss();
        prefs.setString('disp_image', jVar["data"]["disp_image"]);
        setState(() {
          img = jVar["data"]["disp_image"];
        });
        Fluttertoast.showToast(
            msg: "Profile updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
  Future uploadCab(File file) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String lid = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    API.cabUpload(id, lid, file).then((response) {
      print(response);
      var jVar = jsonDecode(response.body);
      print(jVar["status"]);
      if (jVar["status"] == 200) {
        print("Loggin Google");
        EasyLoading.dismiss();
        prefs.setString('cab_pic', jVar["data"]["driver_profile_data"]["cab_pic"]);
        setState(() {
          cab = jVar["data"]["driver_profile_data"]["cab_pic"];
        });
        Fluttertoast.showToast(
            msg: "Cab Img updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
  Future uploadDL(File file) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String lid = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    API.dlUpload(id, lid, file).then((response) {
      print(response);
      var jVar = jsonDecode(response.body);
      print(jVar["status"]);
      if (jVar["status"] == 200) {
        print("Loggin Google");
        EasyLoading.dismiss();
        prefs.setString('dl_pic', jVar["data"]["driver_profile_data"]["dl_pic"]);
        setState(() {
          dl = jVar["data"]["driver_profile_data"]["dl_pic"];
        });
        Fluttertoast.showToast(
            msg: "DL updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
  Future uploadAadhar(File file) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String lid = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    API.aadharUpload(id, lid, file).then((response) {
      print(response);
      var jVar = jsonDecode(response.body);
      print(jVar["status"]);
      if (jVar["status"] == 200) {
        print("Loggin Google");
        EasyLoading.dismiss();
        prefs.setString('aadhar_pic', jVar["data"]["driver_profile_data"]["aadhar_pic"]);
        setState(() {
          aadhar = jVar["data"]["driver_profile_data"]["aadhar_pic"];
        });
        Fluttertoast.showToast(
            msg: "Profile updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  Future<void> updateProfile() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "0";
    String lid = prefs.getString('user_login_token') ?? "0";
    print("user_id-" + id);
    API
        .updateProfile(
            id, lid, nameController.text.trim(), emailController.text.trim())
        .then((response) {
      print(response.body);
      var jVar = jsonDecode(response.body);
      print(jVar["status"]);
      if (jVar["status"] == 200) {
        print("Loggin Google");
        EasyLoading.dismiss();
        if (jVar["chk"] == 1) {
        prefs.setString('user_name',jVar['data']['user_name']);
        prefs.setString('user_email', jVar['data']['user_email']);
        Fluttertoast.showToast(
            msg: jVar["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else{
          Fluttertoast.showToast(
              msg: jVar["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Stack(children: [
      Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
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
                        "Profile Setting",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                            GestureDetector(
                              onTap: () {
                                fileType=1;
                                chooseFile(ImageSource.gallery);
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                child: Stack(
                                  children: [
                                    cab.isEmpty
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
                                                    NetworkImage(cab))),
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
                            SizedBox(width: 70,),
                            GestureDetector(
                              onTap: () {fileType=0;
                                chooseFile(ImageSource.gallery);
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                child: Stack(
                                  children: [
                                    img.isEmpty
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
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
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.name,
                        inputFormatters: [new FilteringTextInputFormatter(RegExp("[a-z A-Z]"), allow: true),],
                       decoration: new InputDecoration.collapsed(
                          hintText: "Enter Your Good Name",
                          hintStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.0,
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
              margin: EdgeInsets.fromLTRB(24, 40, 24, 0),
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
                      child: Text(
                        mob,
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
              margin: EdgeInsets.fromLTRB(24, 20, 24, 0),
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {fileType=2;
                    chooseFile(ImageSource.gallery);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            dl.isEmpty
                                ? Container(
                              height: 70.0,
                              width: 70.0,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(60.0),
                                border: Border.all(
                                    width: 2.0, color: Colors.grey),
                              ),
                              child: Image.asset("assets/card.png"),
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
                                    NetworkImage(dl))),
                            SizedBox(height: 5,),
                            Text("Driving Licence", style: TextStyle(fontSize: 16,color: Colors.black),)
                          ],
                        ),
                        Positioned(
                            bottom: 30,
                            right: 10,
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
                SizedBox(width: 70,),
                GestureDetector(
                  onTap: () {fileType=3;
                    chooseFile(ImageSource.gallery);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            aadhar.isEmpty
                                ? Container(
                              height: 70.0,
                              width: 70.0,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(60.0),
                                border: Border.all(
                                    width: 2.0, color: Colors.grey),
                              ),
                              child: Image.asset("assets/card.png"),
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
                                    NetworkImage(aadhar))),
                            SizedBox(height: 5,),
                            Text("Aadhar Card", style: TextStyle(fontSize: 16,color: Colors.black),)
                          ],
                        ),
                        Positioned(
                            bottom: 30,
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
                                ),),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Positioned(
        bottom: 0,
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
                if (nameController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Please enter name",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  updateProfile();
                }
              },
            ),
          ),
        ),
      ),
    ]);
  }
}
