import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Config/customcolors.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final double? borderradius;
  final int? maxlines; //optional not required

  const TextFieldWidget({Key? key,
   required this.textEditingController,
  required this.hintText,
  this.borderradius=30,
  required this.maxlines}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxlines,
      controller: textEditingController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          filled: true,
          fillColor: CustomColors.textHolder,
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderradius!),
              borderSide: const BorderSide(
                  color: Colors.white,
                  width: 1
              )
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderradius!),
              borderSide: const BorderSide(
                  color: Colors.white,
                  width: 1
              )
          )
      ),
    );
  }
}
