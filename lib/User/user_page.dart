import 'package:flutter/material.dart';

import '../UI/dashboardscreen.dart';
import '../Widgets/loading_widget.dart';
import 'api_service.dart';
import 'data_model.dart';
import 'user_tile.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  static const String userScreen = "userScreen";

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> { /// define two User type list views as users and usersDisplay ///
  // used to view fetched data to list //
  List<User> _users = <User>[];
  // used to view all list in our app alse to filtered data as list when searching //
  List<User> _usersDisplay = <User>[];

  /// this variable use to check if the app still fetching data or not. ///
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers().then((value) {
      setState(() {
        _isLoading = false;
        _users.addAll(value);
        _usersDisplay = _users;
        print(_usersDisplay.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color lightPrimary = Colors.white;
    const Color darkPrimary = Colors.white;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                lightPrimary,
                darkPrimary,
              ])),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: RaisedButton(
            onPressed: (){
              Navigator.pushNamedAndRemoveUntil(context, DashboardScreen.idScreen, (route) => false);
            },
            elevation: 0.0,
            child: Icon(Icons.arrow_back, color: Colors.blue,),
            color: Colors.white,
          ),
          title: Text(
            'Users List',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (!_isLoading) {
                  return index == 0
                      ? _searchBar()
                      : UserTile(user: this._usersDisplay[index - 1]);
                } else {
                  return LoadingView();
                }
              },
              itemCount: _usersDisplay.length + 1,
            ),
          ),
        ),
      ),
    );
  }

  /// to control with search view as list ///
  _searchBar() {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: TextField(
        autofocus: false,
        onChanged: (searchText) {
          searchText = searchText.toLowerCase();
          setState(() {
            _usersDisplay = _users.where((u) {
              var fName = u.firstName.toLowerCase();
              var lName = u.lastName.toLowerCase();
              var job = u.job.toLowerCase();
              return fName.contains(searchText) ||
                  lName.contains(searchText) ||
                  job.contains(searchText);
            }).toList();
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          hintText: 'Search Users',
        ),
      ),
    );
  }
}

