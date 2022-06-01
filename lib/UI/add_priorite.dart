import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:first_app_flutter/Models/Activity.dart';
import 'package:first_app_flutter/Models/Priorite.dart';
import 'package:first_app_flutter/Services/activity_service.dart';
import 'package:first_app_flutter/Services/priorite_service.dart';
import 'package:first_app_flutter/UI/activities_screen.dart';
import 'package:first_app_flutter/UI/priorites_screen.dart';
import 'package:flutter/material.dart';
import '../Config/customcolors.dart';
import '../Validators/validator.dart';

class AddPriorite extends StatefulWidget {
  const AddPriorite({Key? key}) : super(key: key);

  @override
  State<AddPriorite> createState() => _AddPrioriteState();
}

class _AddPrioriteState extends State<AddPriorite> {

  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  PrioriteService service = PrioriteService();

  TextEditingController  prioriteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: RaisedButton(
          onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context, PrioritesScreen.prioriteScreen, (route) => false);
          },
          elevation: 0.0,
          child: Icon(Icons.arrow_back, color: Colors.white,),
          color: Colors.blue,
        ),
        title: Center(
          child: Text("Ajouter Priorite"),
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
                          controller: prioriteController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) => Validator.validateField(
                              value: value!
                          ),
                          decoration: InputDecoration(
                            labelText: 'Priorite',
                            hintText: 'priorite',
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
                            :
                        ElevatedButton(
                          onPressed: () async {
                            saveData();
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

  Future saveData() async {
    if (_addItemFormKey.currentState!.validate()) {
      try {
        setState(() {
          _isProcessing = true;
        });

        var model = Priorite();
        model.priorite = prioriteController.text.trim();

        var result = await service.saveData(model);
        if (result > 0) {
          //Navigator.pop(context);
          print(result);
          AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.SUCCES,
            body: Center(child: Text(
              'Priorite save successfully',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),),
            title: 'Priorite saved',
            btnCancel: Text('Cancel'),
            btnOkOnPress: () {
              Navigator.of(context).pushNamedAndRemoveUntil(PrioritesScreen.prioriteScreen, (route) => false);
            },
          )..show();
        }
        setState(() {
          _isProcessing = false;
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
