import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:first_app_flutter/UI/actions_screen.dart';
import 'package:first_app_flutter/UI/causes_screen.dart';
import 'package:first_app_flutter/UI/sites_screen.dart';
import 'package:first_app_flutter/UI/sous_action_list.dart';
import 'package:first_app_flutter/UI/types_action_screen.dart';
import 'package:first_app_flutter/User/user_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'APIRest/Participant/data_controller.dart';
import 'Authentication/login_page.dart';
import 'Authentication/register_screen.dart';
import 'Config/custom_routes.dart';
import 'Config/shared_preference.dart';
import 'UI/actions_page.dart';
import 'UI/activities_screen.dart';
import 'UI/dashboardscreen.dart';
import 'UI/sources_screen.dart';

//late SharedPreferences sharedPref;

void main() async {
  /// 1- Pour initialiser la Firebase pour assurer la liaison entre la couche de widget flutter et le plug-in Firebase ///
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //sharedPref = await SharedPreferences.getInstance();
  await SharedPreference.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  loadData() async {
    await Get.find<DataController>().getData();
  }
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DataController());
    loadData();

    return GetMaterialApp(
      //return MaterialApp( //without package get
      /// 2- contrôle avec la couleur du thème ///
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),

      /// 3- le premier écran s'affiche lorsque l'application est ouverte
      //home: LoginPage(),
      initialRoute: FirebaseAuth.instance.currentUser == null ? LoginPage.idScreen : DashboardScreen.idScreen,
      routes: CustomRoutes,
      //booléen debugShowCheckedModeBanner. Active une petite bannière "DEBUG"
      // en mode débogage pour indiquer que l'application est en mode débogage.
      debugShowCheckedModeBanner: false,
      //   ),
      // );
    );
  }
}