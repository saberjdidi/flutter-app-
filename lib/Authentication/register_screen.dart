import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Config/customcolors.dart';
import '../UI/dashboardscreen.dart';
import '../Widgets/navigation_drawer_widget.dart';
import '../Widgets/progress_dialog.dart';
import 'login_page.dart';

class RegisterScreen extends StatefulWidget {
  //const RegisterScreen({Key? key}) : super(key: key);


  static const String idScreen = "register";
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(6.0),
          child: Column(
            children: [
              Image(
                image: AssetImage("assets/images/logo.png"),
                width: 390.0,
                height: 300.0,
                alignment: Alignment.center,
              ),

              SizedBox(height: 1.0,),
              Text(
                "Registration",
                style: TextStyle(fontSize: 24.0),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: "Phone",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
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
                    ),

                    SizedBox(height: 10.0,),
                    RaisedButton(
                      color: CustomColors.firebaseYellow,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold "),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(24.0)
                      ),
                      onPressed: ()
                      {
                        if(nameTextEditingController.text.isEmpty){
                          displayToatMessage("Name is required", context);
                        }
                        else if(!emailTextEditingController.text.contains("@")){
                          displayToatMessage("Email not valid", context);
                        }
                        else if(phoneTextEditingController.text.isEmpty){
                          displayToatMessage("Phone is required", context);
                        }
                        else if(phoneTextEditingController.text.length < 6){
                          displayToatMessage("Password must be at least 6 charecters", context);
                        }
                        else {
                          registerNewUser(context);
                        }
                      },
                    )
                  ],
                ),
              ),
              FlatButton(
                onPressed: ()
                {
                  //Poussez la route avec le nom donné sur le navigateur qui entoure le plus étroitement le contexte donné,
                  // puis supprimez toutes les routes précédentes jusqu'à ce que le prédicat renvoie true.
                  Navigator.pushNamedAndRemoveUntil(context, LoginPage.idScreen, (route) => false);
                },
                child: Text(
                    "Already have an account ? Login now."
                ),
              )

            ],
          ),
        ),
      ),
      //drawer: NavigationDrawerWidget(),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return ProgressDialog();
        }
    );
    final User? firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword(email: emailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errorMsg){
      Navigator.pop(context);
      displayToatMessage("Error : "+errorMsg, context);
    })).user;

    //user created
    if(firebaseUser != null) {
      //save user info to db
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToatMessage("user has been created", context);

      Navigator.pushNamedAndRemoveUntil(context, DashboardScreen.idScreen, (route) => false);
    }
    else{
      Navigator.pop(context);
      displayToatMessage("New user account has been not created", context);
    }
  }
}

displayToatMessage(String message, BuildContext context){
  Fluttertoast.showToast(msg: message);
}