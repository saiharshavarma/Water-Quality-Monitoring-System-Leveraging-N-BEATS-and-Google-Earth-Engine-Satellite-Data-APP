import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tirtham/constants.dart';
import 'package:tirtham/screens/autoTimeSeries/components/profilePic.dart';
import 'package:tirtham/utils/snack.dart';

class AutoTimeSeriesTab extends StatefulWidget {
  const AutoTimeSeriesTab({Key? key}) : super(key: key);

  @override
  State<AutoTimeSeriesTab> createState() => _AutoTimeSeriesTabState();
}

class _AutoTimeSeriesTabState extends State<AutoTimeSeriesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  var storage = FlutterSecureStorage();
  var dio = Dio();
  bool isLoading = true;
  List data = [];

  Future<void> getData() async {
    setState(() {
      isLoading = false;
    });

    // var token = await storage.read(key: "token");
    // Response response = await dio.get(
    //   "https://api-ecolyf-alt.herokuapp.com/home/getUser",
    //   options: Options(headers: {
    //     HttpHeaders.contentTypeHeader: "application/json",
    //     HttpHeaders.authorizationHeader: "Bearer " + token!
    //   }),
    // );
    // // print(response.data);
    // if (response.data['status'] == true) {
    //   user = response.data['data']['user'];
    //   print(user);
    //   Response response1 = await dio.get(
    //     "https://api-ecolyf-alt.herokuapp.com/home/getStats",
    //     options: Options(headers: {
    //       HttpHeaders.contentTypeHeader: "application/json",
    //       HttpHeaders.authorizationHeader: "Bearer " + token
    //     }),
    //   );
    //   if (response1.data['status'] == true) {
    //     stats = response1.data['data'];
    //     print(stats);
    //   }
    //   setState(() {
    //     isLoading = false;
    //   });
    // } else {
    //   user = response.data['data'];
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
  }

  Future<void> fetchData() async {
    try {
      var dio = Dio();
      // print()
      Response response = await dio.get(
        '$baseAPI/fetchData',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );
      if (response.data['status']) {
        if (!mounted) return;
        setState(() {
          data = response.data['data'];
          print(data);
          isLoading = false;
        });
      } else {
        if (!mounted) return;
        showSnack(context, "error", () {}, "OK", 3);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      showSnack(context, "error", () {}, "OK", 3);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshPage() async {
    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return (isLoading == true)
        ? Scaffold(
            // backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
                // strokeWidth: 2.0,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Automated Analysis'),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              toolbarHeight: kToolbarHeight + 20.0,
              foregroundColor: kDark,
            ),
            body: RefreshIndicator(
              onRefresh: _refreshPage,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 20),
                child: data.isEmpty
                    ? Column(
                        children: [
                          Center(
                            child: Text('No data found'),
                          ),
                          SizedBox(height: size.height * 0.8, width: size.width)
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        child: Column(
                          children: [
                            for (var i = 0; i < data.length; i++) ...[
                              Container(
                                padding: EdgeInsets.all(kDefaultPadding),
                                decoration: BoxDecoration(
                                  border: Border.all(color: kDark),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data[i]['name'],
                                      style: TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                        "Last Estimated Chlorophyll:"),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        "${data[i]['chl'][0]['value']}"),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            "Chl. by ${data[i]['chl'][1]['date']}:  ${data[i]['chl'][1]['value']}"),
                                        data[i]['chl'][1]['value'] >
                                                data[i]['chl'][0]['value']
                                            ? Icon(
                                                Icons.trending_up,
                                                color: Colors.red,
                                              )
                                            : Icon(Icons.trending_down,
                                                color: Colors.green),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            "Chl. by ${data[i]['chl'][2]['date']}:  ${data[i]['chl'][2]['value']}"),
                                        data[i]['chl'][2]['value'] >
                                                data[i]['chl'][1]['value']
                                            ? Icon(
                                                Icons.trending_up,
                                                color: Colors.red,
                                              )
                                            : Icon(Icons.trending_down,
                                                color: Colors.green),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Last updated: ${data[i]['updated_on']}",
                                      style: TextStyle(color: kDark),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ]
                          ],
                        ),
                      ),
              ),
            ),
          );
  }
}
