
import 'package:flutter/material.dart';

import '../Config/customcolors.dart';

class AppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// 1- ui of AppBarTitle ///
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        /// 2- image that placed in appbar ; and change name of image with your image name ///
        Image.asset(
          'assets/images/flutterfire.png',
          height: 20,
        ),
        SizedBox(width: 8),
        Text(
          'Formation Flutter',
          style: TextStyle(
            color: CustomColors.firebaseYellow,
            fontSize: 18,
          ),
        ),
        Text(
          ' CRUD',
          style: TextStyle(
            color: Colors.green,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
