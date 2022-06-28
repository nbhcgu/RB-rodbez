
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rodbez/Customer/cus_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';



class GotitPage extends StatefulWidget
{
  static const String idScreen = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<GotitPage>
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
    var media = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //     title:
      //     Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text("One Way Ride"),
      //           Text("ID RodBez",style: TextStyle(fontSize: 15,color: Colors.grey),),
      //         ]
      //     )
      // ),
      backgroundColor: Colors.black,
      body:Container(
        child: Stack(
          children: [
            Positioned(
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
                          child: GestureDetector(
                            onTap: ()
                            {
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                height: MediaQuery.of(context).size.height/9,
                                width: MediaQuery.of(context).size.width/1.2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.circle,color: Colors.red,size: 10,),
                                        Flexible(
                                          child: FittedBox(
                                            child: Padding(
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
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.circle,color: Colors.green,size: 10,),
                                        Flexible(
                                          child: FittedBox(
                                            child: Padding(
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
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // constraints: BoxConstraints(minWidth: 100, maxHeight: 200),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(width: 0.5, color: Colors.grey),
                                  boxShadow: [
                                    BoxShadow(
                                      spreadRadius: 0.1,
                                      blurRadius: 2.0,
                                      color: Colors.grey,
                                      offset: Offset(0.5, 0.5),
                                    ),
                                  ],
                                ),
                                // child: RaisedButton(
                                //   color: Colors.white,
                                //   // shape: new RoundedRectangleBorder(
                                //   //   borderRadius: new BorderRadius.circular(10.0),
                                //   // ),
                                //   child: Row(
                                //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //     children: [
                                //       Padding(
                                //         padding: const EdgeInsets.fromLTRB(10,0,0,0),
                                //         child: Icon(Icons.search, color: Colors.green, size: 40.0,),
                                //       ),
                                //        FittedBox(
                                //          child: Text("Search Your Destination ", style: TextStyle(fontSize: 18.0, color: Colors.black)),
                                //        ),
                                //     ],
                                //   ),
                                //   onPressed: (){
                                //     Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerSearchBar()));
                                //   },
                                //   // child: Icon(Icons.arrow_back, size: 26.0,color: Colors.black,),
                                // ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            // Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  content: CupertinoDatePicker(
                                      initialDateTime: _dateTime,
                                      use24hFormat: true,
                                      onDateTimeChanged: (dateTime) {
                                        print(dateTime);
                                        setState(() {
                                          _dateTime = dateTime;
                                        });
                                      }),
                                )
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15,0,0,0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0,5,20,0),
                                  child: Icon(Icons.date_range, color: Colors.black, size: 23.0),
                                ),
                                Flexible(
                                  child: FittedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0,05,50,0),
                                      child: Text(
                                        '${_dateTime.day}/${_dateTime.month}/${_dateTime.year}, ${_dateTime.hour}:${_dateTime.minute}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.blueAccent[700]),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Someone else taking this ride?", style: TextStyle(fontSize: 18.0, color: Colors.black,fontWeight: FontWeight.bold),),
                              Text("Choose a contact so that they also get drive number, vehicle details and ride bill. ", style: TextStyle(fontSize: 14.0, color: Colors.black45),),
                            ],
                          ),
                        ),
                        Divider(),
                        GestureDetector(
                          onTap: ()
                          {

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              // height: MediaQuery.of(context).size.height/8,
                              width: MediaQuery.of(context).size.width/1.2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          child: FittedBox(
                                            child: Padding(
                                              padding: EdgeInsets.all(0.0),
                                              child: Text(
                                                'Mini Cabs',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Container()
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          child: Image.asset(
                                            'assets/non veg.png',
                                            height: 50,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // constraints: BoxConstraints(minWidth: 100, maxHeight: 200),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              // child: RaisedButton(
                              //   color: Colors.white,
                              //   // shape: new RoundedRectangleBorder(
                              //   //   borderRadius: new BorderRadius.circular(10.0),
                              //   // ),
                              //   child: Row(
                              //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Padding(
                              //         padding: const EdgeInsets.fromLTRB(10,0,0,0),
                              //         child: Icon(Icons.search, color: Colors.green, size: 40.0,),
                              //       ),
                              //        FittedBox(
                              //          child: Text("Search Your Destination ", style: TextStyle(fontSize: 18.0, color: Colors.black)),
                              //        ),
                              //     ],
                              //   ),
                              //   onPressed: (){
                              //     Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerSearchBar()));
                              //   },
                              //   // child: Icon(Icons.arrow_back, size: 26.0,color: Colors.black,),
                              // ),
                            ),
                          ),
                        ),
                        // SizedBox(height: 10.0,),
                        // Divider(
                        //   // color: Colors.black,
                        // ),
                        GestureDetector(
                          onTap: ()
                          {
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Container(
                              // height: MediaQuery.of(context).size.height/8,
                              width: MediaQuery.of(context).size.width/1.1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: SizedBox(
                                            child: FittedBox(
                                              child: Padding(
                                                padding: EdgeInsets.all(0.0),
                                                child: Text(
                                                  'Estimated Fare',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Container()
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: FittedBox(
                                                child: Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Text(
                                                    '2000',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            child: FittedBox(
                                              child: Padding(
                                                padding: EdgeInsets.all(0.0),
                                                child: Text(
                                                  'Distance 125 km, Time 4hr',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Container()
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            child: FittedBox(
                                              child: Padding(
                                                padding: EdgeInsets.all(0.0),
                                                child: Text(
                                                  'Ride Fare',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Container()
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: FittedBox(
                                                child: Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Text(
                                                    '100',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            child: FittedBox(
                                              child: Padding(
                                                padding: EdgeInsets.all(0.0),
                                                child: Text(
                                                  'RodBez Fee',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Container()
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: FittedBox(
                                                child: Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Text(
                                                    '100',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            child: FittedBox(
                                              child: Padding(
                                                padding: EdgeInsets.all(0.0),
                                                child: Text(
                                                  "Taxes",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 3,
                                            child: Container()
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: SizedBox(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: FittedBox(
                                                child: Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Text(
                                                    '0',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            child: FittedBox(
                                              child: Padding(
                                                padding: EdgeInsets.all(0.0),
                                                child: Text(
                                                  'Total Payout',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Container()
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: FittedBox(
                                                child: Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Text(
                                                    '2200',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // constraints: BoxConstraints(minWidth: 100, maxHeight: 200),
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
                              ),
                              // child: RaisedButton(
                              //   color: Colors.white,
                              //   // shape: new RoundedRectangleBorder(
                              //   //   borderRadius: new BorderRadius.circular(10.0),
                              //   // ),
                              //   child: Row(
                              //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Padding(
                              //         padding: const EdgeInsets.fromLTRB(10,0,0,0),
                              //         child: Icon(Icons.search, color: Colors.green, size: 40.0,),
                              //       ),
                              //        FittedBox(
                              //          child: Text("Search Your Destination ", style: TextStyle(fontSize: 18.0, color: Colors.black)),
                              //        ),
                              //     ],
                              //   ),
                              //   onPressed: (){
                              //     Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerSearchBar()));
                              //   },
                              //   // child: Icon(Icons.arrow_back, size: 26.0,color: Colors.black,),
                              // ),
                            ),
                          ),
                        ),
                        Divider(
                          // color: Colors.black,
                        ),
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: Text("Rules & Restriction", style: TextStyle(fontSize: 16.0),),
                            ),

                          ],
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10,0,0,0),
                              child: Icon(Icons.circle, color: Colors.red, size: 16.0,),
                            ),
                            Flexible(child: FittedBox(child: Padding(
                              padding: const EdgeInsets.fromLTRB(10,0,0,0),
                              child: Text("Excludes toll costs,parking, state tax", style: TextStyle(color: Colors.black45,fontSize: 14.0),),
                            ))),
                          ],
                        ),
                        SizedBox(height: 5.0,),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10,0,0,0),
                              child: Icon(Icons.circle, color: Colors.red, size: 16.0,),
                            ),
                            Flexible(child: FittedBox(child: Padding(
                              padding: const EdgeInsets.fromLTRB(10,0,0,0),
                              child: Text("12/km will be charge extra km", style: TextStyle(color: Colors.black45,fontSize: 14.0),),
                            ))),
                          ],
                        ),
                        SizedBox(height: 5.0,),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10,0,0,0),
                              child: Icon(Icons.circle, color: Colors.red, size: 16.0,),
                            ),
                            Flexible(child: FittedBox(child: Padding(
                              padding: const EdgeInsets.fromLTRB(10,0,0,0),
                              child: Text("150/hour will be charged for additional hour", style: TextStyle(color: Colors.black45,fontSize: 14.0),),
                            ))),
                          ],
                        ),
                        SizedBox(height: 5.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10,0,0,0),
                              child: Icon(Icons.circle, color: Colors.red, size: 16.0,),
                            ),
                            Flexible(
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10,0,0,0),
                                  child: Text('Estimated fares will change as time or distance'
                                    , style: TextStyle(color: Colors.black45,fontSize: 14.0),),
                                ),
                              ),
                            ),
                          ],
                        ),Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10,0,0,0),
                              child: Icon(Icons.circle, color: Colors.white, size: 16.0,),
                            ),
                            Flexible(
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10,0,0,0),
                                  child: Text('increases during travel.', style: TextStyle(color: Colors.black45, fontSize: 14.0),),
                                ),
                              ),
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
                        SizedBox(height: 30,),
                        GestureDetector(
                          onTap: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            String url = prefs.getString('cancellation_policy_url') ?? "";
                            if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
                          },
                          child: Positioned(
                            top: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  // height: 60.0,
                                  // width: 342.0,

                                  child: Text('Cancellation Policy', style: TextStyle(color: Colors.red, fontSize: 18.0),),
                                ),
                              ],
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
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              child: Container(
                height: media.height*1.4,
                width: media.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0),),
                  color: Colors.black45,
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 112.5,
                      blurRadius: 116.0,
                      color: Colors.black45,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                // height: requestRideContainerHeight,

                child:Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0,),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0,0,0,0),
                              child: Text("Ride Scheduled1", style: TextStyle(fontSize: 23.0, color: Colors.black),),
                            ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,0,0),
                        child: Text("Your ride has been scheduled. You will get all the information related to your booking through Phone call and SMS. ", style: TextStyle(fontSize: 16.0, color: Colors.grey),),
                      ),
                    ],
                  ),
                ),
              ),
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
                    child: Text("Got it"),
                    color: Colors.black,
                    elevation: 5,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerHomePage()));
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

}
