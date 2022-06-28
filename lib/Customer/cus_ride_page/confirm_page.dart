
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';



class CustomerConfirmPage extends StatefulWidget
{
  static const String idScreen = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}



class _LoginScreenState extends State<CustomerConfirmPage>
{
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  DateTime _dateTime = DateTime.now();
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("One Way Ride"),
                Text("ID RodBez",style: TextStyle(fontSize: 15,color: Colors.grey),),
              ]
          )
      ),
      backgroundColor: Colors.white,
      body:Container(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Positioned(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0.0),
                        topRight: Radius.circular(0.0),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 0.2,
                          blurRadius: 9.0,
                          color: Colors.black54,
                          offset: Offset(0.9, 0.9),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SizedBox(height: 20.0,),
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
                          SizedBox(height: 10.0,),
                          Divider(),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0,0,0,0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15,0,0,0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0,0,10,0),
                                      child: Column(
                                        children: [
                                          Text("Mini Cab", style: TextStyle(fontSize: 22.0, color: Colors.black,fontWeight: FontWeight.bold),),
                                          // Text("cab id", style: TextStyle(fontSize: 18.0, color: Colors.black45),),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(100,0,25,0),
                                      child: Column(
                                        children: [
                                          Image.asset('assets/non veg.png',  height: 110.3, width: 110.3,),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(height: 10.0,),
                          // Divider(
                          //   // color: Colors.black,
                          // ),
                          Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Container(
                                    height: 220,
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
                                                        .grey,
                                                  ),
                                                ),
                                              ),
                                              Divider(),
                                              Padding(
                                                padding:
                                                const EdgeInsets
                                                    .fromLTRB(
                                                    5, 0, 0, 0),
                                                child: Text(
                                                  "Ride Fare",
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
                                                  "RodBez Fee",
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
                                              Divider(),
                                              Padding(
                                                padding:
                                                const EdgeInsets
                                                    .fromLTRB(
                                                    5, 0, 0, 0),
                                                child: Text(
                                                  "Total Payout",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors
                                                          .black54),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 30,),
                                        Padding(
                                          padding: const EdgeInsets.all(7),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              // Icon(Icons.circle,color: Colors.green,size: 10,),
                                              Padding(
                                                padding:
                                                const EdgeInsets
                                                    .fromLTRB(
                                                    5, 5, 0, 0),
                                                child: Text(
                                                  "2000",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors
                                                          .black,fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(height: 30,),
                                              Divider(),
                                              Padding(
                                                padding:
                                                const EdgeInsets
                                                    .fromLTRB(
                                                    0, 0, 0, 0),
                                                child: Text(
                                                  "100",
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
                                                    0, 0, 0, 0),
                                                child: Text(
                                                  "100000",
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
                                                    0, 0, 0, 0),
                                                child: Text(
                                                  "0",
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
                                                    0, 0, 0, 0),
                                                child: Text(
                                                  "2200",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors
                                                          .black54),
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
                          Divider(
                            // color: Colors.black,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20,00,0,0),
                            child: Row(
                              children: [
                                Text("Status", style: TextStyle(fontSize: 16.0),),
                                SizedBox(width: 5,),
                                Text("Confirm /", style: TextStyle(fontSize: 16.0,color: Colors.green),),
                                SizedBox(width: 5,),
                                Text("Pending", style: TextStyle(fontSize: 16.0,color: Colors.orange),),
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Container(
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
                                    child: Padding(
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
                                              "Message",
                                              style: TextStyle(
                                                  fontSize: 16.0,
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
                                              "your ride has been schedule. Driver details will be shared 2 hour be four your pickup time",
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors
                                                    .grey,),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // SizedBox(width: 30,),
                                ],
                              )
                          ),

                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15,00,0,0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Service executive for this ride", style: TextStyle(fontSize: 16.0),),
                                    Text("Mr Suraj Mishra", style: TextStyle(fontSize: 16.0,color: Colors.black),),
                                    Icon(Icons.call,color: Colors.green,)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(50,0,0,0),
                                child: Icon(Icons.account_circle_rounded,color: Colors.black,size: 50,),
                              ),
                            ],
                          ),

                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Text("Rules & Restriction", style: TextStyle(fontSize: 16.0),),
                              ),

                            ],
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(13,0,0,0),
                                child: Icon(Icons.circle, color: Colors.red, size: 16.0,),
                              ),
                              Text(" Excludes toll costs,parking, state tax", style: TextStyle(color: Colors.black45,fontSize: 14.0),),
                            ],
                          ),
                          SizedBox(height: 5.0,),Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(13,0,0,0),
                                child: Icon(Icons.circle, color: Colors.red, size: 16.0,),
                              ),
                              Text(" Excludes toll costs,parking, state tax", style: TextStyle(color: Colors.black45,fontSize: 14.0),),
                            ],
                          ),
                          SizedBox(height: 5.0,),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(13,0,0,0),
                                child: Icon(Icons.circle, color: Colors.red, size: 16.0,),
                              ),
                              Text(" 12/km will be charge extra km", style: TextStyle(color: Colors.black45,fontSize: 14.0),),
                            ],
                          ),
                          SizedBox(height: 5.0,),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(13,0,0,0),
                                child: Icon(Icons.circle, color: Colors.red, size: 16.0,),
                              ),
                              Text(" 150/hour will be charged for additional hour", style: TextStyle(color: Colors.black45,fontSize: 14.0),),
                            ],
                          ),
                          SizedBox(height: 5.0,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(13,0,0,0),
                                child: Icon(Icons.circle, color: Colors.red, size: 16.0,),
                              ),
                              Text(' Estimated fares will change as time or distance'
                                , style: TextStyle(color: Colors.black45,fontSize: 14.0),),
                            ],
                          ),Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(13,0,0,0),
                                child: Text('      increases during travel.', style: TextStyle(color: Colors.black45, fontSize: 14.0),),
                              ),
                            ],
                          ),
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Text("Rules & Restriction", style: TextStyle(fontSize: 16.0),),
                              ),
                            ],
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(13,0,0,0),
                                child: Icon(Icons.circle, color: Colors.green, size: 16.0,),
                              ),
                              Text(" Regularly audited cars", style: TextStyle(color: Colors.black45,fontSize: 14.0),),
                            ],
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(13,0,0,0),
                                child: Icon(Icons.circle, color: Colors.green, size: 16.0,),
                              ),
                              Text(" 24x7 on-rod assistance", style: TextStyle(color: Colors.black45,fontSize: 14.0),),
                            ],
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(13,0,0,0),
                                child: Icon(Icons.circle, color: Colors.green, size: 16.0,),
                              ),
                              Text(" Real time tracking", style: TextStyle(color: Colors.black45,fontSize: 14.0),),
                            ],
                          ),

                          GestureDetector(
                            onTap: () {
                              // cancelRideRequest();
                              // resetApp();
                            },
                            child: Positioned(
                              child: Padding(
                                padding:
                                EdgeInsets.all(30),
                                child: Row(
                                  children: [

                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                      child: Text('Cancel ride', style: TextStyle(color: Colors.black, fontSize: 18.0),),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(90,0,0,0),
                                      child: Icon(Icons.arrow_forward_ios),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              String url = prefs.getString('cancellation_policy_url') ?? "";
                              if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(30,00,0,0),
                              child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                      child: Text('Cancellation Policy', style: TextStyle(color: Colors.red, fontSize: 18.0),),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(90,0,0,0),
                                      child: Icon(Icons.arrow_forward_ios),
                                    ),
                                  ]
                              ),
                            ),
                          ),
                          SizedBox(height: 70.0,),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Positioned(
            //   bottom: MediaQuery.of(context).viewInsets.bottom,
            //   left: 0,
            //   right: 0,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Container(
            //       height: 50,
            //       child: RaisedButton(
            //         child: Text("Accept Ride"),
            //         color: Colors.black,
            //         elevation: 5,
            //         textColor: Colors.white,
            //         onPressed: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => ArrivedPage()));
            //         },
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

// final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

// void loginAndAuthenticateUser(BuildContext context) async
// {
//   showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context)
//       {
//         return ProgressDialog(message: " Please wait...",);
//       }
//   );
//
//   final User firebaseUser = (await _firebaseAuth
//       .signInWithEmailAndPassword(
//       email: emailTextEditingController.text,
//       password: passwordTextEditingController.text
//   ).catchError((errMsg){
//     Navigator.pop(context);
//     displayToastMessage("Error: " + errMsg.toString(), context);
//   })).user;
//
//   if(firebaseUser != null)
//   {
//     usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap){
//       if(snap.value != null)
//       {
//         Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
//         displayToastMessage("you are logged-in now.", context);
//       }
//       else
//       {
//         Navigator.pop(context);
//         _firebaseAuth.signOut();
//         displayToastMessage("No record exists for this user. Please create new account.", context);
//       }
//     });
//   }
//   else
//   {
//     Navigator.pop(context);
//     displayToastMessage("Error Occured, can not be Signed-in.", context);
//   }
// }
}
