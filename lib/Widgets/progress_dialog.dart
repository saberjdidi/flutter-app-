import 'package:flutter/material.dart';

import '../Config/customcolors.dart';

class ProgressDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: CustomColors.firebaseOrange,
      child: Container(
        margin: EdgeInsets.all(15.8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              SizedBox(width: 6.0,),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
              SizedBox(width: 26.0,),
            ],
          ),
        ),
      ),
    );
  }
}
