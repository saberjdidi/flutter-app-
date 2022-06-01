import 'package:flutter/material.dart';
import '../Config/customcolors.dart';
import '../Config/shared_preference.dart';
import 'add_post.dart';
import '../Widgets/app_bar_title.dart';
import 'list_posts.dart';
import '../Widgets/navigation_drawer_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  static const String idScreen = "mainScreen";

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  //Future email =  SharedPreference.setUsername('saber');
  @override
  Widget build(BuildContext context) {
    /// 1- ui of DashboardScreen ///
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.firebaseNavy,
        /// 2- to call ui of AppBarTitle class ///
        title: AppBarTitle(),
      ),
      drawer: NavigationDrawerWidget(),
      floatingActionButton: FloatingActionButton(
        /// 3- code navigator to AddScreen when click floatingButton to add post ///
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddScreen(),
            ),
          );
        },
        backgroundColor: CustomColors.googleBackground,

        /// 4- ui of floatingButton ///
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),

          /// 5- to call ui of ItemList class and show them in DashboardScreen ///
          child: ItemList(),
        ),
      ),
    );
  }
}
