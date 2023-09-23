import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tirtham/constants.dart';

class ChangeModel extends StatefulWidget {
  ChangeModel({Key? key}) : super(key: key);

  @override
  ChangeModelState createState() => ChangeModelState();
}

class ChangeModelState extends State<ChangeModel> {

  final storage = const FlutterSecureStorage();
  int selectedModel = 1;
  String model = "Xgboost";

  Future<void> getModelIndex() async {
    var m = await storage.read(key: 'model');
    if (m != null) {
      setState(() {
        if (m == "Xgboost") {
          selectedModel = 1;
        }
        if (m == "NBeats") {
          selectedModel = 2;
        }
      });
    } else {
      await storage.write(key: 'model', value: model);
    }
  }

  @override
  void initState() {
    super.initState();
    getModelIndex();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            'Change Model',
            style: TextStyle(
                color:
                    kPrimaryColor,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        // systemOverlayStyle: SystemUiOverlayStyle(
        //     statusBarColor: Theme.of(context).scaffoldBackgroundColor,
        //     statusBarIconBrightness:
        //         Theme.of(context).brightness == Brightness.light
        //             ? Brightness.dark
        //             : Brightness.light),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        toolbarHeight: kToolbarHeight + 50.0,
        foregroundColor: kDark,
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              const SizedBox(
                height: 15.0,
              ),
              themeRadio(1, "Xgboost"),
              const SizedBox(
                height: 15.0,
              ),
              themeRadio(2, "NBeats"),
              const SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> changeTheme(int index, String thme) async {
    if (mounted) {
      setState(() {
        model = thme;
        selectedModel = index;
      });
      await storage.write(key: 'model', value: model);
 
    }
    // print(flavour);
  }

  Widget themeRadio(int index, String flav) {
    return GestureDetector(
      onTap: () => changeTheme(index, flav),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: selectedModel == index
              ? kPrimaryColor
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black54
                  : kDark,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(flav,
            style: TextStyle(
                color: selectedModel != index
                    ? kPrimaryColor
                    : Theme.of(context).scaffoldBackgroundColor)),
      ),
    );
  }
}
