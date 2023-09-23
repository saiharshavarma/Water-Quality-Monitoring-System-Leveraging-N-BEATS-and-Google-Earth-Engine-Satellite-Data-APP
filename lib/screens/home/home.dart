// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tirtham/screens/autoTimeSeries/autoTimeSeries.dart';
import 'package:tirtham/screens/home/map.dart';
import 'package:tirtham/screens/autoTimeSeries/profile.dart';
import 'package:tirtham/utils/snack.dart';

import '../../constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // bool isLoading = true;
  List data = [];
  Map dataOrg = {};
  String error = "";
  var storage = FlutterSecureStorage();
  var dio = Dio();
  final _formKey = GlobalKey<FormState>();
  String orgName = "";

  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  PageController _pageController = PageController();
  List<Widget> _screens = [];

  Future<void> sendFCM() async {
    try {
      // print()
      final FirebaseMessaging fcm = FirebaseMessaging.instance;
      fcm.getToken().then((value) async {
        try {
          
      Response response = await dio.post(
        '$baseAPI/addToken',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: {
          "token": value
        }
      );
      } catch (e) {
          print(e);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  // Future<void> _refreshPage() async {
  //   setState(() {
  //     // isLoading = true;
  //     // getOrgs();
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // isLoading = true;
      sendFCM();
    _selectedIndex = 0;
    _screens = [
      MapPage(),
      AutoTimeSeriesTab(),
    ];

    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return
        // (isLoading == true)
        //     ? Scaffold(
        //         // backgroundColor: Colors.white,
        //         body: Center(
        //           child: SpinKitThreeBounce(
        //             color: kPrimaryColor,
        //             size: 50.0,
        //           ),
        //         ),
        //       )
        //     :
        Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? kDark[900]
                : kLight,
        currentIndex: _selectedIndex,
        // onTap: _navigateBottomBar,
        onTap: (selectedPageIndex) {
          setState(() {
            // isLoading = false;
            _selectedIndex = selectedPageIndex;
            _pageController.jumpToPage(selectedPageIndex);
          });
        },
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_location_alt_rounded),
            label: 'Map',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.analytics_rounded),
            label: 'Time Series',
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _screens,
      ),
    );
  }

  // void bottomModal(context, modalLabel, textFieldLabel, validator, onSubmit) {
  //   // String orgName = "";
  //   showModalBottomSheet(
  //       isDismissible: true,
  //       isScrollControlled: true,
  //       barrierColor: Theme.of(context).canvasColor.withOpacity(0.2),
  //       backgroundColor: kForeground,
  //       context: context,
  //       // clipBehavior: Clip.antiAliasWithSaveLayer,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
  //       ),
  //       builder: (context) {
  //         return Padding(
  //           padding: MediaQuery.of(context).viewInsets,
  //           child: Form(
  //             key: _formKey,
  //             child: Padding(
  //               padding: const EdgeInsets.all(kDefaultPadding * 1.5),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Text(
  //                     modalLabel,
  //                     style: TextStyle(
  //                       color: kPrimaryColor,
  //                       fontSize: 20.0,
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 50.0,
  //                   ),
  //                   TextFormField(
  //                       decoration: InputDecoration(
  //                         labelText: textFieldLabel,

  //                         labelStyle: TextStyle(
  //                           // fontFamily: 'Raleway',
  //                           fontSize: 16.0,
  //                           color: MediaQuery.of(context).platformBrightness ==
  //                                   Brightness.dark
  //                               ? kPrimaryColor
  //                               : kDark[900],
  //                         ),
  //                         contentPadding: EdgeInsets.symmetric(
  //                             horizontal: 25.0, vertical: kDefaultPadding),
  //                         // floatingLabelBehavior: FloatingLabelBehavior.always,
  //                         border: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(15.0),
  //                         ),
  //                         focusedBorder: OutlineInputBorder(
  //                           borderSide: BorderSide(
  //                               color:
  //                                   MediaQuery.of(context).platformBrightness ==
  //                                           Brightness.dark
  //                                       ? kPrimaryColor
  //                                       : kDark[900]!),
  //                           borderRadius: BorderRadius.circular(15.0),
  //                         ),
  //                       ),
  //                       onChanged: (value) {
  //                         setState(() {
  //                           orgName = value;
  //                         });
  //                       },
  //                       validator: validator
  //                       // (val) {
  //                       //   if (!RegExp(r"^(?=[a-zA-Z0-9._]{3,32}$)")
  //                       //       .hasMatch(val!)) {
  //                       //     return 'Please enter a valid Username';
  //                       //   }
  //                       // return null;
  //                       // if (!RegExp(r"^[a-zA-Z0-9!#$%&-^_]+").hasMatch(val)) {
  //                       // },
  //                       ),
  //                   SizedBox(height: 20.0),
  //                   GestureDetector(
  //                     onTap: onSubmit,
  //                     // onTap: () async {
  //                     //   if (_formKey.currentState!.validate()) {
  //                     //     var url =
  //                     //         "http://20.124.13.106:8000/organisation/create";

  //                     //     var token = await storage.read(key: "token");
  //                     //     Response response = await dio.post(url,
  //                     //         options: Options(headers: {
  //                     //           HttpHeaders.contentTypeHeader:
  //                     //               "application/json",
  //                     //           HttpHeaders.authorizationHeader:
  //                     //               "Bearer " + token!
  //                     //         }),
  //                     //         data: {"org_name": orgName});
  //                     //     if (response.data["error"] != null) {
  //                     //       setState(() {
  //                     //         error = response.data['error'];
  //                     //       });
  //                     //     } else {
  //                     //       setState(() {
  //                     //         dataOrg = response.data['data'];
  //                     //         print(dataOrg);
  //                     //       });
  //                     //       Navigator.pop(context);
  //                     //       Navigator.pushReplacement(
  //                     //         context,
  //                     //         MaterialPageRoute(builder: (context) {
  //                     //           return Home();
  //                     //         }),
  //                     //       );
  //                     //       // Navigator.of(context).popUntil((route) => route.isFirst);
  //                     //     }
  //                     //   }
  //                     // },
  //                     child: Container(
  //                       height: 50.0,
  //                       child: Material(
  //                         borderRadius: BorderRadius.circular(25.0),
  //                         shadowColor: kPrimaryColorAccent,
  //                         color: kPrimaryColor,
  //                         elevation: 5.0,
  //                         child: Center(
  //                           child: Text(
  //                             'CREATE',
  //                             style: TextStyle(
  //                               // fontFamily: 'Raleway',
  //                               color: kLight,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }
}
