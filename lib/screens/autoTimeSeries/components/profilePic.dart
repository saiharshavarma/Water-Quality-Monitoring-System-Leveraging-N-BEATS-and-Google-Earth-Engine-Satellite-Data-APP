import 'package:flutter/material.dart';
import 'package:tirtham/constants.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            foregroundColor: kPrimaryColor,
            backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? kDark[900]
                  : kLight,
            // backgroundImage: AssetImage("assets/images/Profile Image.png"),
            child: Icon(Icons.person_rounded, size: 64.0),
          ),
          
        ],
      ),
    );
  }
}