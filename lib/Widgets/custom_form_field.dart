import 'package:flutter/material.dart';
import '../Config/customcolors.dart';

class CustomFormField extends StatelessWidget {
  /// 1- ui of all textformfield ///
  const CustomFormField({
    Key? key,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required TextInputAction inputAction,
    required String label,
    required String hint,
    required Function(String value) validator,
    this.isObscure = false,
    this.maxLines = 1,
    this.isLabelEnabled = true,
  })  : _uiController = controller,
        _keyboardtype = keyboardType,
        _inputAction = inputAction,
        _label = label,
        _hint = hint,
        _validator = validator,
        super(key: key);

  final TextEditingController _uiController;
  final TextInputType _keyboardtype;
  final TextInputAction _inputAction;
  final String _label;
  final String _hint;
  final bool isObscure;
  final int maxLines;
  final bool isLabelEnabled;
  final Function(String) _validator;

  @override
  Widget build(BuildContext context) {
    /// 1- ui of all textfield in app ///
    return TextFormField(
      maxLines: maxLines,
      controller: _uiController,
      keyboardType: _keyboardtype,
      obscureText: isObscure,
      textInputAction: _inputAction,
      cursorColor: CustomColors.firebaseYellow,
      validator: (value) => _validator(value!),
      decoration: InputDecoration(
        labelText: isLabelEnabled ? _label : null,
        labelStyle: TextStyle(color: CustomColors.firebaseYellow),
        hintText: _hint,
        hintStyle: TextStyle(
          color: CustomColors.firebaseWhite.withOpacity(0.5),
        ),
        errorStyle: TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: CustomColors.firebaseAmber,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: CustomColors.firebaseWhite.withOpacity(0.5),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.redAccent,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.redAccent,
            width: 2,
          ),
        ),
      ),
    );
  }
}
