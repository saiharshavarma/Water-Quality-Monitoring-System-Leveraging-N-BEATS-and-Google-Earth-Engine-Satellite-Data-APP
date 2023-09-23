import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tirtham/constants.dart';
import 'package:tirtham/utils/addressToDict.dart';

class WaterQuality extends StatefulWidget {
  const WaterQuality(
      {super.key, required this.lat, required this.long, required this.res});
  final double lat;
  final double long;
  final Map res;
  @override
  State<WaterQuality> createState() => _WaterQualityState();
}

class _WaterQualityState extends State<WaterQuality> {
  String tsi = "";
  String tclass = "";
  String phos = "";
  String sd = "";
  String tdesc = "";
  Map<dynamic, dynamic> addressMap = {
    'city': '',
    'state': '',
    'country': '',
  };
  int fui = 0;
  String fcolor = '0xFFFFFFFF';
  String fWaterType1 = '';
  String fWaterType2 = '';
  String fDesc1 = '';
  String fDesc2 = '';

  Future<void> estimate() async {
    double c = double.parse(widget.res['predicted_chl']);
    double a = widget.res['fui_alpha'];

    if (c < 2.6) {
      tsi = "< 30—40";
      tclass = "Oligotrophic or hipotrophic";
      phos = "0—12";
      sd = "> 8—4";
      tdesc =
          "Low in nutrients and not productive in terms of aquatic animal and plant life. It is usually accompanied by an abundance of dissolved oxygen";
    } else if (c < 7.3) {
      tsi = "40—50";
      tclass = "Mesotrophic";
      phos = "12—24";
      sd = "4—2";
      tdesc =
          "Intermediate levels of nutrients, fairly productive in terms of aquatic animal and plant life and showing emerging signs of water quality problems.";
    } else if (c < 56) {
      tsi = "50—70";
      tclass = "Eutrophic";
      phos = "24—96";
      sd = "2—0.5";
      tdesc =
          "Rich in nutrients, very productive in terms of aquatic animal and plant life and showing increasing signs of water quality problems.";
    } else {
      tsi = "50—70";
      tclass = "Eutrophic";
      phos = "24—96";
      sd = "2—0.5";
      tdesc =
          "Very high nutrient concentrations where plant growth is determined by physical factors. Water quality problems are serious and almost continuous.";
    }

    if (a < 42.83) {
      fui = 1;
      fcolor = '0xFF01008A';
    } else if (a < 49.02) {
      fui = 2;
      fcolor = '0xFF01008A';
    } else if (a < 60.01) {
      fui = 3;
      fcolor = '0xFF0000CC';
    } else if (a < 79.23) {
      fui = 4;
      fcolor = '0xFF0000CC';
    } else if (a < 106.94) {
      fui = 5;
      fcolor = '0xFF0065FF';
    } else if (a < 137.03) {
      fui = 6;
      fcolor = '0xFF0096EB';
    } else if (a < 160.97) {
      fui = 7;
      fcolor = '0xFF32B8D1';
    } else if (a < 175.98) {
      fui = 8;
      fcolor = '0xFF08B885';
    } else if (a < 186.67) {
      fui = 9;
      fcolor = '0xFF0AD06E';
    } else if (a < 195.44) {
      fui = 10;
      fcolor = '0xFF50D06F';
    } else if (a < 202.05) {
      fui = 11;
      fcolor = '0xFF5EE600';
    } else if (a < 207.82) {
      fui = 12;
      fcolor = '0xFF8AEE00';
    } else if (a < 213.57) {
      fui = 13;
      fcolor = '0xFF97EE01';
    } else if (a < 219.34) {
      fui = 14;
      fcolor = '0xFFB5EE01';
    } else if (a < 224.87) {
      fui = 15;
      fcolor = '0xFFC2EF00';
    } else if (a < 230.23) {
      fui = 16;
      fcolor = '0xFFE7FA00';
    } else if (a < 235.09) {
      fui = 17;
      fcolor = '0xFFF7F001';
    } else if (a < 239.56) {
      fui = 18;
      fcolor = '0xFFF7E500';
    } else if (a < 243.66) {
      fui = 19;
      fcolor = '0xFFF7DA00';
    } else if (a < 247.25) {
      fui = 20;
      fcolor = '0xFFF7CF56';
    } else {
      fui = 21;
      fcolor = '0xFFD9B557';
    }
    setState(() {});

    if (fui < 3) {
      fWaterType1 = 'Marine';
      fDesc1 = 'High light penetration';
    } else if (fui < 5) {
      fWaterType1 = 'Tertiary';
      fDesc1 = 'High light penetration';
    } else if (fui < 9) {
      fWaterType1 = 'Secondary';
      fDesc1 =
          'Dominated by algae, but increased dissolved organic material and some sediment';
    } else {
      fWaterType1 = 'Primary';
      fDesc1 =
          'High concentration of phytoplankton, nutrients, sediments and decreased light attenuation';
    }

    if (fui < 9) {
      fWaterType2 = 'Open Sea';
      fDesc2 =
          'Dominated by microscopic algae, some sediment might be present but typically the Open Sea';
    } else if (fui < 13) {
      fWaterType2 = 'Coastal';
      fDesc2 =
          'Increased nutrient and phytoplankton, some minerals and dissolved organic material';
    } else if (fui < 17) {
      fWaterType2 =
          'High nutrient and phytoplankton, increased sediment and dissolved organic material typical for Coastal waters';
      fDesc2 = 'Dominated by algae';
    } else {
      fWaterType2 = 'Estuaries';
      fDesc2 =
          'Extremely high concentration of humic acids typical for rivers and Estuaries';
    }

    List<Placemark> placemarks = [];
    try {
      placemarks = await placemarkFromCoordinates(widget.lat, widget.long);
      addressMap = addressToDict(placemarks);
    } catch (e) {
      placemarks = [];
    }
    
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    estimate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Tirtham results')),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Geo location',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'latitude: ${widget.lat.toString()}\nlongitude: ${widget.long.toString()}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'City: ${addressMap['city'] == "" ? 'Ocean/Sea' : addressMap['city']}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'State: ${addressMap['state']}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Country: ${addressMap['country']}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'Predictions',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Chlorophyll (μg/L): ${widget.res['predicted_chl']}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'The estimated values are as follows:',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Trophic State Index: ${tsi}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Trophic Class: ${tclass}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Phosphorus (μg/L): ${phos}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Secchi depth (m): ${sd}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'What is ${tclass} water?',
                  style: TextStyle(
                    fontSize: 16.0,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '${tdesc}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'FUI index',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Hue angle (ɑ + ∆ɑ) : ${widget.res['fui_alpha']}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'FUI index : ${fui}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Water type 1 : ${fWaterType1}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                
                Text(
                  'Water type 2 : ${fWaterType2}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Water color : ',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                Container(height: 30, width: 30, color: Color(int.parse(fcolor))),
                SizedBox(height: 30),
                Text(
                  'What is ${fWaterType1} water?',
                  style: TextStyle(
                    fontSize: 16.0,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '${fDesc1}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'What is ${fWaterType2} water?',
                  style: TextStyle(
                    fontSize: 16.0,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '${fDesc2}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'Calculations',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Total absorption coefficient (443): ${widget.res['calculated_vars']['a443']}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Total backscattering coefficient (443): ${widget.res['calculated_vars']['b443']}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Wavelength: ${widget.res['calculated_vars']['w']} nm',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Above surface reflectance (443): ${widget.res['calculated_vars']['R443']}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Below surface reflectance (443): ${widget.res['calculated_vars']['r443']}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Seawater absorption coefficient (443): ${widget.res['calculated_vars']['aw443']}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Seawater backscattering coefficient (443): ${widget.res['calculated_vars']['bw443']}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'Satellite data',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                // SizedBox(height: 5),
                // Text(
                //   'Above surface reflectance (412): ${widget.res['satellite_data']['R412']}',
                //   style: TextStyle(
                //     fontSize: 16.0,
                //   ),
                // ),
                SizedBox(height: 5),
                Text(
                  'Above surface reflectance (443): ${widget.res['satellite_data']['R443']}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Above surface reflectance (488): ${widget.res['satellite_data']['R488']}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Above surface reflectance (550): ${widget.res['satellite_data']['R550']}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Above surface reflectance (667): ${widget.res['satellite_data']['R667']}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Date: ${widget.res['satellite_data']['date']}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }
}
