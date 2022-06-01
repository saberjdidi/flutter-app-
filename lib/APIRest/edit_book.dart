import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:first_app_flutter/APIRest/api_services.dart';
import 'package:first_app_flutter/APIRest/books_screen.dart';
import 'package:first_app_flutter/Models/Activity.dart';
import 'package:first_app_flutter/Services/activity_service.dart';
import 'package:first_app_flutter/UI/activities_screen.dart';
import 'package:first_app_flutter/UI/dashboardscreen.dart';
import 'package:flutter/material.dart';
import '../Config/customcolors.dart';
import '../Config/url_api.dart';
import '../Validators/validator.dart';

class EditBook extends StatefulWidget {
  final book;
  const EditBook({Key? key, this.book}) : super(key: key);

  @override
  State<EditBook> createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> with ApiServices {

  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  TextEditingController  fullNameController = TextEditingController();
  TextEditingController  emailController = TextEditingController();
  TextEditingController  jobController = TextEditingController();

  @override
  void initState() {
    fullNameController.text = widget.book['fullName'];
    emailController.text = widget.book['email'];
    jobController.text = widget.book['job'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: RaisedButton(
          onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context, BooksScreen.bookScreen, (route) => false);
          },
          elevation: 0.0,
          child: Icon(Icons.arrow_back, color: Colors.white,),
          color: Colors.blue,
        ),
        title: Center(
          child: Text("Edit Book"),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: SingleChildScrollView(
              child: Form(
                key: _addItemFormKey,
                child: Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Column(
                      children: <Widget>[
                        SizedBox(height: 8.0,),
                        TextFormField(
                          controller: fullNameController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) => Validator.validateField(
                              value: value!
                          ),
                          decoration: InputDecoration(
                            labelText: 'FullName',
                            hintText: 'fullName',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                          ),
                          style: TextStyle(fontSize: 14.0),
                        ),
                        SizedBox(height: 10.0,),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) => Validator.validateField(
                              value: value!
                          ),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'email',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                          ),
                          style: TextStyle(fontSize: 14.0),
                        ),
                        SizedBox(height: 10.0,),
                        TextFormField(
                          controller: jobController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) => Validator.validateField(
                              value: value!
                          ),
                          decoration: InputDecoration(
                            labelText: 'Job',
                            hintText: 'job',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                          ),
                          style: TextStyle(fontSize: 14.0),
                        ),
                        SizedBox(height: 20.0,),
                        _isProcessing
                            ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              CustomColors.firebaseOrange,
                            ),
                          ),
                        )
                       : ElevatedButton(
                          onPressed: () async {
                            updateData();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              CustomColors.googleBackground,
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Save',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.firebaseWhite,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        )
                      ]
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future updateData() async {
    if (_addItemFormKey.currentState!.validate()) {
      try {
        _isProcessing = true;
        setState(() {
        });
        var response = await putRequest(
            "${book_url}/${widget.book['_id']}",
            {
              "_id": widget.book['_id'],
              "fullName": fullNameController.text.trim(),
              "email": emailController.text.trim(),
              "job": jobController.text.trim()
          });
        print(response);
        if (response['message'] == "participant updated successfully"){
          AwesomeDialog(
              context: context,
              animType: AnimType.SCALE,
              dialogType: DialogType.SUCCES,
              body: Center(child: Text(
                'Data update successfully',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),),
              title: 'saved',
              btnOk: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.blue,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pushReplacementNamed(BooksScreen.bookScreen);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Ok',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              closeIcon: Icon(Icons.close, color: Colors.red,),
              btnCancel: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.redAccent,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              )
          )..show();
        }
        _isProcessing = false;
        setState(() {
        });
      }
      catch (ex){
        AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.ERROR,
          body: Center(child: Text(
            ex.toString(),
            style: TextStyle(fontStyle: FontStyle.italic),
          ),),
          title: 'Error',
          btnCancel: Text('Cancel'),
          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
        )..show();
        print("throwing new error " + ex.toString());
        throw Exception("Error " + ex.toString());
      }
    }
  }
}
