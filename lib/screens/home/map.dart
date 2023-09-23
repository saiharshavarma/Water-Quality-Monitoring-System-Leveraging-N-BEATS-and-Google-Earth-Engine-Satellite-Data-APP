import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart' as g;
// import 'package:latlng/latlng.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:tirtham/constants.dart';
import 'package:tirtham/screens/home/changeModel.dart';
import 'package:tirtham/screens/home/prLoader.dart';
import 'package:tirtham/screens/home/timeSeries.dart';
import 'package:tirtham/screens/home/tsLoader.dart';
import 'package:tirtham/screens/home/waterQuality.dart';
import 'package:tirtham/utils/snack.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  double lat = 51.5;
  double lng = -0.09;
  String message = "";
  bool isLoading = true;
  bool isClicked = false;
  var storage = const FlutterSecureStorage();
  var dio = Dio();
  String query = "varanasi";
  final TextEditingController _tc = TextEditingController();
  MapController _mc = MapController();

  void checkPermission() async {
    bool _serviceEnabled;
    Location location = Location();
    PermissionStatus _permissionGranted;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print('Error');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('Error');
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void setLocation(currentLocation) {
    print(currentLocation);
    setState(() {
      lat = currentLocation.latitude!;
      lng = currentLocation.longitude!;
    });
  }

  void setLocationTest(late, long) {
    print(late);
    print(long);
    setState(() {
      lat = late;
      lng = long;
      isLoading = false;
    });
  }

  Future<LocationData> getLocation() async {
    print('hello');
    LocationData _locationData;
    Location location = Location();
    _locationData = await location.getLocation();
    setLocation(_locationData);
    setState(() {
      isLoading = false;
    });
    // location.onLocationChanged.listen((LocationData currentLocation) {

    // });

    // setState(() {
    //   location.onLocationChanged.listen((LocationData currentLocation) {
    //     lat = _locationData.latitude!;
    //     lng = _locationData.longitude!;
    //   });
    // });
    print(lng);
    print(lat);
    print(_locationData);
    return _locationData;
  }

  @override
  void initState() {
    super.initState();
    _mc = MapController();
    checkPermission();
    getLocation();

    // gulf of mexico
    // setLocationTest(30.018749999999997,-84.01875);
    // setLocationTest(30.018749999999997,-85.93124999999999);
    // ganga
    // setLocationTest(25.477308,83.513130);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoading
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
            // appBar: AppBar(
            //   title: const Text('Live location'),
            //   centerTitle: true,
            //   backgroundColor: Colors.transparent,
            //   toolbarHeight: kToolbarHeight + 20.0,
            //   foregroundColor: kDark,
            // ),
            appBar: AppBar(
              elevation: 0,
              // forceElevated: isScrollable,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              foregroundColor: Theme.of(context).brightness == Brightness.dark
                  ? kLight
                  : kDark[900],
              // backgroundColor: Colors.transparent,
              title: TextFormField(
                controller: _tc,
                // autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  if (value == '') {
                    query = 'varanasi';
                  } else {
                    query = value;
                  }
                },
                validator: (val) => val!.isEmpty
                    //  || (!RegExp(r"^[a-zA-Z0-9]+").hasMatch(val))
                    ? 'Search name should not be empty'
                    : null,
                textInputAction: TextInputAction.search,
                onFieldSubmitted: (val) async {
                  var loc = (await g.locationFromAddress(query));
                  setLocation(loc[loc.length - 1]);
                  _mc.move(
                      LatLng(loc[loc.length - 1].latitude,
                          loc[loc.length - 1].longitude),
                      10);
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: () {
                    // clear query
                    _tc.text = "";
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.search_rounded),
                  onPressed: () async {
                    var loc = (await g.locationFromAddress(query));
                    setLocation(loc[loc.length - 1]);
                    _mc.move(
                        LatLng(loc[loc.length - 1].latitude,
                            loc[loc.length - 1].longitude),
                        10);
                  },
                ),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: '1',
                  child: const Icon(
                    Icons.settings,
                  ),
                  // foregroundColor: MediaQuery.of(context).platformBrightness ==
                  //                           Brightness.light
                  //                       ? kDark[900]
                  //                       : Colors.white,
                  foregroundColor: kPrimaryColor,
                  backgroundColor: kDark[900],
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ChangeModel();
                      }),
                    );
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                FloatingActionButton(
                  heroTag: '2',
                  child: const Icon(
                    Icons.my_location_rounded,
                  ),
                  // foregroundColor: MediaQuery.of(context).platformBrightness ==
                  //                           Brightness.light
                  //                       ? kDark[900]
                  //                       : Colors.white,
                  foregroundColor: kPrimaryColor,
                  backgroundColor: kDark[900],
                  onPressed: () async {
                    var loc = await getLocation();
                    _mc.move(LatLng(loc.latitude!, loc.longitude!), 10);
                  },
                ),
              ],
            ),
            body: Stack(
              children: [
                FlutterMap(
                  mapController: _mc,
                  options: MapOptions(
                      center: LatLng(lat, lng),
                      zoom: 18.0,
                      onTap: (tapPos, latLong) {
                        setLocation(latLong);
                      }),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                      attributionBuilder: (_) {
                        return const Text("");
                      },
                    ),
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: LatLng(lat, lng),
                          builder: (ctx) => Container(
                            child: Icon(
                              Icons.location_on_rounded,
                              color: kDark[800],
                              size: 54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: kDefaultPadding,
                  right: kDefaultPadding * 2 + 80.0,
                  left: kDefaultPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // setState(() {
                          //   isClicked = true;
                          // });
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return PrLoader();
                            }),
                          );
                          try {
                            Response response = await dio.post(
                              '$baseAPI/getReflectanceL',
                              options: Options(headers: {
                                HttpHeaders.contentTypeHeader:
                                    "application/json",
                              }),
                              // data: jsonEncode(value),
                              data: {"lat": lat, "long": lng},
                            );
                            if (!mounted) return;
                            // setState(() {
                            //   isClicked = false;
                            // });
                            if (response.data['status'] == true) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return WaterQuality(
                                      lat: lat,
                                      long: lng,
                                      res: response.data['data']);
                                }),
                              );
                            } else {
                              Navigator.of(context).pop();
                              showSnack(
                                  context,
                                  'Error: ${response.data['message']}, Try searching near land or fresh water',
                                  () {},
                                  'OK',
                                  4);
                            }
                          } catch (e) {
                            Navigator.of(context).pop();
                            showSnack(context, 'Server error', () {}, 'OK', 4);
                          }
                        },
                        child: Container(
                          // height: 50.0,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Center(
                            child: Text(
                              'Check quality',
                              style: TextStyle(
                                // fontFamily: 'Raleway',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          // setState(() {
                          //   isClicked = true;
                          // });
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return TsLoader();
                            }),
                          );
                          try {
                            var model = await storage.read(key: 'model');
                            // if(model == null) {
                            //   setState(() {
                            //     model = 'Xgboost';
                            //   });
                            // }
                            Response response = await dio.post(
                              '$baseAPI/timeSeries',
                              options: Options(headers: {
                                HttpHeaders.contentTypeHeader:
                                    "application/json",
                              }),
                              // data: jsonEncode(value),
                              data: {
                                "lat": lat,
                                "long": lng,
                                "model": model == 'NBeats' ? 2 : 1
                              },
                            );
                            if (!mounted) return;
                            // setState(() {
                            //   isClicked = false;
                            // });
                            if (response.data['status'] == true) {
                              // print(response.data['data']);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return TimeSeries(
                                      lat: lat,
                                      long: lng,
                                      res: response.data['data']);
                                }),
                              );
                            } else {
                              Navigator.of(context).pop();
                              showSnack(
                                  context,
                                  'Error: ${response.data['message']}: ${response.data['error']}',
                                  () {},
                                  'OK',
                                  4);
                            }
                          } catch (e) {
                            Navigator.of(context).pop();
                            showSnack(context, 'Server error', () {}, 'OK', 4);
                          }
                        },
                        child: Container(
                          height: 50.0,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Center(
                            child: Text(
                              'Future analysis',
                              style: TextStyle(
                                // fontFamily: 'Raleway',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
