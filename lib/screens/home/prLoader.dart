import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tirtham/constants.dart';

class PrLoader extends StatefulWidget {
  const PrLoader({super.key});

  @override
  State<PrLoader> createState() => _PrLoaderState();
}

class _PrLoaderState extends State<PrLoader> {
  double percent = 0.1;
  String status = 'Fetching data from satellite ...';

  Future<void> animate() async {
    await Future.delayed(Duration(seconds: 5));
    if(!mounted) return;
    setState(() {
      percent = 0.4;
      status = 'Calculating parameters ...';
    });
    // await Future.delayed(Duration(seconds: 5));
    // if(!mounted) return;
    // setState(() {
    //   percent = 0.2;
    //   status = 'Loading model ...';
    // });
    await Future.delayed(Duration(seconds: 12));
    if(!mounted) return;
    setState(() {
      percent = 0.8;
      status = 'Predicting chlorophyll ...';
    });
    // await Future.delayed(Duration(seconds: 8));
    // if(!mounted) return;
    // setState(() {
    //   percent = 0.8;
    //   status = 'Forecasting future values ...';
    // });
    await Future.delayed(Duration(seconds: 15));
    if(!mounted) return;
    setState(() {
      percent = 0.9;
      status = 'Loading ...';
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animate();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width*0.7,
              child: TextLiquidFill(
                text: 'tirtham',
                loadDuration: Duration(seconds: 10),
                waveDuration: Duration(seconds: 3),
                waveColor: kPrimaryColor,
                boxBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                textStyle: TextStyle(
                  fontSize: 56.0,
                  fontWeight: FontWeight.bold,
                ),
                boxHeight: 300.0,
              ),
            ),
            // CircularProgressIndicator(
            //   color: kPrimaryColor,
            //   strokeWidth: 2.0,
            // ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: LinearPercentIndicator(
                width: MediaQuery.of(context).size.width - 50,
                animation: true,
                lineHeight: 20.0,
                animationDuration: 1000,
                animateFromLastPercent: true,
                percent: percent,
                // center: Text("80.0%"),
                barRadius: Radius.circular(25),
                progressColor: kPrimaryColor,
              ),
            ),
            SizedBox(height: 5,),
            Text(status),
          ],
        ),
      ),
    );
  }
}
