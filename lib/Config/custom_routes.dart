import 'package:first_app_flutter/APIRest/books_screen.dart';
import 'package:first_app_flutter/UI/gravites_action_screen.dart';
import 'package:first_app_flutter/UI/notes_screen.dart';
import 'package:first_app_flutter/UI/priorites_screen.dart';
import 'package:flutter/material.dart';
import '../Authentication/login_page.dart';
import '../Authentication/register_screen.dart';
import '../UI/actions_page.dart';
import '../UI/actions_screen.dart';
import '../UI/activities_screen.dart';
import '../UI/causes_screen.dart';
import '../UI/dashboardscreen.dart';
import '../UI/sites_screen.dart';
import '../UI/sources_screen.dart';
import '../UI/types_action_screen.dart';
import '../User/user_page.dart';

var CustomRoutes = <String, WidgetBuilder>{
  RegisterScreen.idScreen: (context) => RegisterScreen(),
  LoginPage.idScreen: (context) => LoginPage(),
  DashboardScreen.idScreen: (context) => DashboardScreen(),
  "site": (context) => SiteScreen(),
  ActionsScreen.actionScreen: (context) => ActionsScreen(),
  ActionPage.actionPage: (context) => ActionPage(),
  UserPage.userScreen: (context) => UserPage(),
  SourceScreen.sourceScreen: (context) => SourceScreen(),
  TypeActionScreen.typeActionScreen: (context) => TypeActionScreen(),
  CauseScreen.causeActionScreen: (context) => CauseScreen(),
  ActivitiesScreen.activityScreen: (context) => ActivitiesScreen(),
  PrioritesScreen.prioriteScreen: (context) => PrioritesScreen(),
  GravitesActionScreen.graviteActionScreen: (context) => GravitesActionScreen(),
  NotesScreen.noteScreen: (context) => NotesScreen(),
  BooksScreen.bookScreen: (context) => BooksScreen(),
};