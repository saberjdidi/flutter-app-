import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../Config/customcolors.dart';

class ListProducts extends StatefulWidget {

  @override
  State<ListProducts> createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {

  final dbRef = FirebaseDatabase.instance.reference().child("product");
 /* DatabaseReference reference = FirebaseDatabase.instance.reference().child('product');
  Query _ref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = FirebaseDatabase.instance
        .reference()
        .child('product')
        .orderByChild('name');
  } */

  Widget _buildContactItem({required Map contact}) {
    Color typeColor = getTypeColor(contact['code']);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      height: 130,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                contact['name'],
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.phone_iphone,
                color: Theme.of(context).accentColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                contact['description'],
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 15),
              Icon(
                Icons.group_work,
                color: typeColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                contact['code'],
                style: TextStyle(
                    fontSize: 16,
                    color: typeColor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
      query: dbRef,
      itemBuilder: (BuildContext context, DataSnapshot snapshot,
          Animation<double> animation, int index) {
        Map contact = snapshot.value;
        contact['key'] = snapshot.key;
        return _buildContactItem(contact: contact);
      },
    );
  }

  Color getTypeColor(String type) {
    Color color = Theme.of(context).accentColor;

    if (type == 'pd1') {
      color = Colors.brown;
    }

    if (type == 'pd2') {
      color = Colors.green;
    }

    if (type == 'Friends') {
      color = Colors.teal;
    }
    return color;
  }
}