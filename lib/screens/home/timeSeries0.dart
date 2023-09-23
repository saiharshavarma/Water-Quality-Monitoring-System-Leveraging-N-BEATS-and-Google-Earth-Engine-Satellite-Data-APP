import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tirtham/constants.dart';
import 'package:tirtham/utils/addressToDict.dart';
import 'package:tirtham/utils/date_convert.dart';
import 'package:collection/collection.dart';

class TimeSeries0 extends StatefulWidget {
  const TimeSeries0(
      {super.key, required this.lat, required this.long, required this.res});
  final double lat;
  final double long;
  final Map res;
  @override
  State<TimeSeries0> createState() => _TimeSeries0State();
}

class _TimeSeries0State extends State<TimeSeries0> {
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
  int _index = 0;
  List preds = [];
  List diff = [];
  double maxC = 1;
  double minC = 100;
  bool isLoading = false;
  Future<void> convert() async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(widget.lat, widget.long);
    addressMap = addressToDict(placemarks);
    setState(() {});

    List str_arr = widget.res['time_series'];

    if(str_arr.length == widget.res['steps']){
    str_arr.forEach((element) {
      var arr = element.split(" ");
      preds.add(arr);
      if (double.parse(arr[0]) > maxC) {
        setState(() {
          maxC = double.parse(arr[0]);
        });
      }
      if (double.parse(arr[0]) < minC) {
        setState(() {
          minC = double.parse(arr[0]);
        });
      }
    });
    preds.forEach((element) {
      diff.add(double.parse(element[0]) - minC);
    });
    }
    setState(() {
      isLoading = false;
    });
  }

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    // Widget text;
    // switch (value.toInt()) {
    //   case 1:
    //   case 2:
    //     text = const Text('MAR', style: style);
    //     break;
    //   case 5:
    //     text = const Text('JUN', style: style);
    //     break;
    //   case 8:
    //     text = const Text('SEP', style: style);
    //     break;
    //   default:
    //     text = const Text('*', style: style);
    //     break;
    // }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      // child: Text("${value.toInt() * 16}", style: style),
      child: Text("${increaseDate2(formatDate(DateTime.now()), 16 * (value.toInt() + 1))}",
          style: style),
    );
  }

  // Widget leftTitleWidgets(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     color: Color(0xff67727d),
  //     fontWeight: FontWeight.bold,
  //     fontSize: 15,
  //   );
  //   String text;
  //   switch (value.toInt()) {
  //     case 1:
  //       text = '10K';
  //       break;
  //     case 3:
  //       text = '30k';
  //       break;
  //     case 5:
  //       text = '50k';
  //       break;
  //     default:
  //       return Container();
  //   }

  //   return Text(text, style: style, textAlign: TextAlign.left);
  // }

  LineChartData ChartData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 60,
            interval: 2,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            // interval: 2,
            interval: diff.reduce((a, b) => a + b) / diff.length,
            // getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      // minY: minC > 1 ? minC-1 : minC,
      minY: minC,
      maxY: maxC,
      minX: 0,
      maxX: preds.length.toDouble() - 1,
      lineBarsData: [
        LineChartBarData(
          spots: [
            for (var i = 0; i < preds.length; i++) ...[
              FlSpot(i.toDouble(), double.parse(preds[i][0])),
              // FlSpot(2.6, 2),
              // FlSpot(4.9, 5),
              // FlSpot(6.8, 3.1),
              // FlSpot(8, 4),
              // FlSpot(9.5, 3),
              // FlSpot(11, 4),
            ]
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    preds = [];
    convert();
  }

  @override
  Widget build(BuildContext context) {
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
                      'Future Predictions',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 40),
                    if(preds.isEmpty) ... [
                      SizedBox(height: 5),
                      Text(
                        'No data found',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ] else ... [
                    AspectRatio(
                      aspectRatio: 1.3,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(18),
                          ),
                          // color: Color(0xff232d37),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: LineChart(
                            ChartData(),
                          ),
                        ),
                      ),
                    ),

                    // SizedBox(height: 5),
                    // Text(
                    //   'Chlorophyll (μg/L): ${widget.res['predicted_chl']}',
                    //   style: TextStyle(
                    //     fontSize: 16.0,
                    //   ),
                    // ),

                    SizedBox(height: 30),
                    Stepper(
                      physics: NeverScrollableScrollPhysics(),
                      currentStep: _index,
                      controlsBuilder: ((context, details) => Container()),
                      onStepCancel: () {
                        if (_index > 0) {
                          setState(() {
                            _index -= 1;
                          });
                        }
                      },
                      onStepContinue: () {
                        if (_index <= 0) {
                          setState(() {
                            _index += 1;
                          });
                        }
                      },
                      onStepTapped: (int index) {
                        setState(() {
                          _index = index;
                        });
                      },
                      steps: [
                        for (var i = 0; i < preds.length; i++) ...[
                          Step(
                            title: Text(increaseDate(
                                formatDate(DateTime.now()), 16 * (i + 1))),
                            isActive: true,
                            state: StepState.complete,
                            content: Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Chlorophyll (μg/L): ${preds[i][0]}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Above surface reflectance (443): ${preds[i][1]}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Below surface reflectance (443): ${preds[i][2]}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Seawater backscattering coefficient (443): ${preds[i][3]}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Total absorption coefficient (443): ${preds[i][4]}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ],
                    )]
                  ],
                ),
              ),
            ));
  }
}
