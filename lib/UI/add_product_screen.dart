import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class AddProductScreen extends StatefulWidget {

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

final productReference = FirebaseDatabase.instance.reference().child('product');

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  Widget divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        width: 0.8,
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(

        //height: 570.0,
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  style:
                  TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.person), labelText: 'Name'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                TextField(
                  controller: _codeController,
                  style:
                  TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.person), labelText: 'CodeBar'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                TextField(
                  controller: _descriptionController,
                  style:
                  TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.list), labelText: 'Description'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                TextField(
                  controller: _priceController,
                  style:
                  TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.monetization_on), labelText: 'Price'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.0),
                ),
                Divider(),
                FlatButton(
                    onPressed: () {

                        productReference.push().set({
                          'name': _nameController.text,
                          'code': _codeController.text,
                          'description': _descriptionController.text,
                          'price': _priceController.text,
                        }).then((_) {
                          Navigator.pop(context);
                        });
                    },
                    child: Text('Add')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
