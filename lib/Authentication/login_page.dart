import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app_flutter/Authentication/register_screen.dart';
import 'package:first_app_flutter/Config/customcolors.dart';
import 'package:first_app_flutter/Widgets/custom_form_field.dart';
import 'package:first_app_flutter/Validators/validator.dart';
import 'package:first_app_flutter/main.dart';
import 'package:flutter/material.dart';

import '../Config/shared_preference.dart';
import '../UI/dashboardscreen.dart';
import '../Widgets/progress_dialog.dart';

class LoginPage extends StatefulWidget {
  static const String idScreen = "login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController emailVerificationEditingController = TextEditingController();

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Form(
        key: _loginFormKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 35.0,),
                Image(
                  image: AssetImage("assets/images/logo.png"),
                  width: 390.0,
                  height: 300.0,
                  alignment: Alignment.center,
                ),

                SizedBox(height: 1.0,),
                Text(
                  "Login ",
                  style: TextStyle(fontSize: 24.0),
                  textAlign: TextAlign.center,
                ),

                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 1.0,),
                      CustomFormField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        inputAction: TextInputAction.next,
                        label: 'Email',
                        hint: 'Enter your Email',
                        validator: (value) => Validator.validateField(value: value),
                      ),
                      SizedBox(height: 10.0,),
                    /*  TextField(
                        controller: passwordTextEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            )
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ), */
                      CustomFormField(
                        controller: passwordTextEditingController,
                        keyboardType: TextInputType.visiblePassword,
                        inputAction: TextInputAction.next,
                        label: 'Password',
                        hint: 'Enter your Password',
                        validator: (value) => Validator.validateField(value: value),
                        isObscure: obscurePassword,

                      ),

                      SizedBox(height: 10.0,),
                      RaisedButton(
                        color: CustomColors.firebaseYellow,
                        textColor: Colors.white,
                        child: Container(
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold "),
                            ),
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(24.0)
                        ),
                        onPressed: ()
                        {
                          authenticateUser(context);
                         /* if(emailTextEditingController.text.isEmpty){
                            displayToatMessage("Email is required", context);
                          }
                          if(passwordTextEditingController.text.isEmpty){
                            displayToatMessage("Password is required", context);
                          }
                          else {
                            authenticateUser(context);
                          } */
                        },
                      )
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: ()
                  {
                    _showDialog(context);
                  },
                  child: Text(
                      "Forgot Password ?"
                  ),
                ),
                FlatButton(
                  onPressed: ()
                  {
                    Navigator.pushNamedAndRemoveUntil(context, RegisterScreen.idScreen, (route) => false);
                  },
                  child: Text(
                      "Don't have an account ? Register now."
                  ),
                )

              ],
            ),
          ),
        ),
      )
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void authenticateUser(BuildContext context) async {
    if (_loginFormKey.currentState!.validate()) {
      //await sharedPref.setString('action', 'ahmed');
      Future email =  SharedPreference.setUsername(emailTextEditingController.text.toString());
      try {
        final User? firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(email: emailTextEditingController.text,
            password: passwordTextEditingController.text
        ).catchError((errorMsg){
          Navigator.pop(context);
          displayToatMessage("Error : "+errorMsg, context);
        })).user;

        if(firebaseUser != null) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context)
              {
                return ProgressDialog();
              }
          );
          Navigator.pushNamedAndRemoveUntil(context, DashboardScreen.idScreen, (route) => false);
          displayToatMessage("You are logged in", context);

        }
        else{
          //Navigator.pop(context);
          displayToatMessage("Error occured", context);

        }
      } catch (ex) {
        displayToatMessage("Error "+ex.toString(), context);
       print("throwing new error");
        throw Exception("Error on server");
    }

    }
  }

  void _showDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Password'),
          content: CustomFormField(
            controller: emailVerificationEditingController,
            keyboardType: TextInputType.emailAddress,
            inputAction: TextInputAction.next,
            label: 'Email',
            hint: 'Enter your Email',
            validator: (value) => Validator.validateField(value: value),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.mail,
                  color: Colors.blue,
                ),
                onPressed: () {
                  resetPassword();
                }
            ),
            new FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future resetPassword() async {
    try{
     await _firebaseAuth.sendPasswordResetEmail(email: emailVerificationEditingController.text.trim());
      Navigator.of(context).pop();
     displayToatMessage("Password reset email sent", context);
    } on FirebaseAuthException catch (e) {
      displayToatMessage(e.message.toString(), context);
    }
  }
}
