
import 'package:flutter/material.dart';

import '../Config/customcolors.dart';
import 'add_item_form.dart';
import '../Widgets/app_bar_title.dart';

class AddScreen extends StatelessWidget {
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _imageFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    /// 1- ui of AddScreen ///
    return GestureDetector(
      onTap: () {
        _titleFocusNode.unfocus();
        _imageFocusNode.unfocus();
        _descriptionFocusNode.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.firebaseNavy,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.firebaseNavy,

          /// 2- to call ui of AppBarTitle class ///
          title: AppBarTitle(),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),

            /// 3- to call ui of AddItemForm class and show the empty textfield to add post  ///
            child: AddItemForm(
              titleFocusNode: _titleFocusNode,
              descriptionFocusNode: _descriptionFocusNode,
              imageFocusNode: _imageFocusNode,
            ),
          ),
        ),
      ),
    );
  }
}
