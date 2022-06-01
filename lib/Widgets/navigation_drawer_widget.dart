import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app_flutter/APIRest/Participant/all_participants.dart';
import 'package:first_app_flutter/APIRest/books_screen.dart';
import 'package:first_app_flutter/UI/actions_page.dart';
import 'package:first_app_flutter/UI/activities_screen.dart';
import 'package:first_app_flutter/UI/categories_screen.dart';
import 'package:first_app_flutter/UI/causes_screen.dart';
import 'package:first_app_flutter/UI/dashboardscreen.dart';
import 'package:first_app_flutter/UI/notes_screen.dart';
import 'package:first_app_flutter/UI/products_screen.dart';
import 'package:first_app_flutter/UI/sources_screen.dart';
import 'package:first_app_flutter/UI/types_action_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Authentication/login_page.dart';
import '../Config/customcolors.dart';
import '../Config/shared_preference.dart';
import '../UI/actions_screen.dart';
import '../UI/dropdown_search.dart';
import '../User/user_page.dart';
import 'divider.dart';

class NavigationDrawerWidget  extends StatelessWidget {
  const NavigationDrawerWidget ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   String email = SharedPreference.getUsername() ?? 'test';

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          //drawer header
          Container(
            height: 160.0,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Row(
                children: [
                  Image.asset("assets/images/user_icon.png", height: 65.0, width: 65.0,),
                  SizedBox(width: 16.0,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Qualipro", style: TextStyle(fontSize: 16.0, fontFamily: "Brand-Bold"),),
                      SizedBox(height: 6.0,),
                      Text('${email}',
                        style: TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold", ),),
                    ],
                  )
                ],
              ),
            ),
          ),

          DividerWidget(),
          SizedBox(height: 12.0,),
          
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => DashboardScreen()))
            ,
            child: ListTile(
              leading: Icon(Icons.home, color: Colors.black,),
              title: Text("Home",
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProductScreen()));
            },
            child: ListTile(
              leading: Icon(Icons.add_shopping_cart_sharp, color: Colors.black,),
              title: Text("Product",
                style: TextStyle(
                    fontSize: 15.0,
                  color: Colors.black
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesScreen()));
            },
            child: ListTile(
              leading: Icon(Icons.view_list, color: Colors.black,),
              title: Text("Category",
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).pushNamed("site");
            },
            child: ListTile(
              leading: Icon(Icons.map, color: Colors.black,),
              title: Text("Site",
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              //Navigator.of(context).pushNamed(ActionsScreen.actionScreen);
              Navigator.of(context).pushNamed(ActionPage.actionPage);
              Future.delayed(Duration(seconds: 2));
            },
            child: ListTile(
              leading: Icon(Icons.pending_actions, color: Colors.black,),
              title: Text("Action",
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              //Navigator.of(context).pushNamed(ActionsScreen.actionScreen);
              Navigator.of(context).pushNamed(SourceScreen.sourceScreen);
              Future.delayed(Duration(seconds: 2));
            },
            child: ListTile(
              leading: Icon(Icons.source, color: Colors.black,),
              title: Text("Source",
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              //Navigator.of(context).pushNamed(ActionsScreen.actionScreen);
              Navigator.of(context).pushNamed(TypeActionScreen.typeActionScreen);
              Future.delayed(Duration(seconds: 2));
            },
            child: ListTile(
              leading: Icon(Icons.call_to_action_outlined, color: Colors.black,),
              title: Text("Type Action",
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              //Navigator.of(context).pushNamed(ActionsScreen.actionScreen);
              Navigator.of(context).pushNamed(CauseScreen.causeActionScreen);
              Future.delayed(Duration(seconds: 2));
            },
            child: ListTile(
              leading: Icon(Icons.category, color: Colors.black,),
              title: Text("Cause Action",
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).pushNamed(ActivitiesScreen.activityScreen);
              Future.delayed(Duration(seconds: 2));
            },
            child: ListTile(
              leading: Icon(Icons.local_activity, color: Colors.black,),
              title: Text("Activity",
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              //Navigator.push(context, MaterialPageRoute(builder: (context) => NotesScreen()));
              Navigator.of(context).pushNamed(NotesScreen.noteScreen);
            },
            child: ListTile(
              leading: Icon(Icons.note, color: Colors.black,),
              title: Text("Note",
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              //Navigator.push(context, MaterialPageRoute(builder: (context) => BooksScreen()));
              Navigator.of(context).pushNamed(BooksScreen.bookScreen);
            },
            child: ListTile(
              leading: Icon(Icons.view_list, color: Colors.black,),
              title: Text("Book",
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              //Navigator.push(context, MaterialPageRoute(builder: (context) => AllParticipants()));
              Get.to(()=>AllParticipants(), transition: Transition.fade, duration: Duration(seconds: 1));
            },
            child: ListTile(
              leading: Icon(Icons.view_list, color: Colors.black,),
              title: Text("Participant",
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).pushNamed(UserPage.userScreen);
            },
            child: ListTile(
              leading: Icon(Icons.person, color: Colors.black,),
              title: Text("User",
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => DropdownSearchScreen()));
            },
            child: ListTile(
              leading: Icon(Icons.search, color: Colors.black,),
              title: Text("Dropdown Search",
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black
                ),
              ),
            ),
          ),
          DividerWidget(),
          GestureDetector(
            onTap: (){
              FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, LoginPage.idScreen, (route) => false);
            },
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title: Text("Sign Out",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
