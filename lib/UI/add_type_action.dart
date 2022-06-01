import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:first_app_flutter/UI/types_action_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../Config/customcolors.dart';
import '../Models/typeAction.dart';
import '../Services/type_action_service.dart';
import '../Validators/validator.dart';

class AddTypeAction extends StatefulWidget {
  const AddTypeAction({Key? key}) : super(key: key);

  @override
  State<AddTypeAction> createState() => _AddTypeActionState();
}

class _AddTypeActionState extends State<AddTypeAction> {

  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  bool checkAction = false;
  int actionSimpl = 0;
  bool checkCause = false;
  int analyseCause = 0;

  TypeActionService service = TypeActionService();
  TextEditingController  typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: RaisedButton(
          onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context, TypeActionScreen.typeActionScreen, (route) => false);
          },
          elevation: 0.0,
          child: Icon(Icons.arrow_back, color: Colors.white,),
          color: Colors.blue,
        ),
        title: Center(
          child: Text("Ajouter Type Action"),
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
                          controller: typeController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) => Validator.validateField(
                              value: value!
                          ),
                          decoration: InputDecoration(
                            labelText: 'Type',
                            hintText: 'type',
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
                        CheckboxListTile(
                          title: const Text('Action simplifié'),
                          value: checkAction,
                          onChanged: (bool? value) {
                            setState(() {
                              checkAction = value!;
                              if(checkAction == true){
                                actionSimpl = 1;
                              }
                              else {
                                actionSimpl = 0;
                              }
                              print('action Simplifie ${actionSimpl}');
                            });
                          },
                          activeColor: Colors.blue,
                          //secondary: const Icon(Icons.hourglass_empty),
                        ),
                        SizedBox(height: 10.0,),
                        CheckboxListTile(
                          title: const Text('Analyse des cause'),
                          value: checkCause,
                          onChanged: (bool? value) {
                            setState(() {
                              checkCause = value!;
                              if(checkCause == true){
                                analyseCause = 1;
                              }
                              else {
                                analyseCause = 0;
                              }
                              print('Analyse des cause ${analyseCause}');
                            });
                          },
                          activeColor: Colors.blue,
                          //secondary: const Icon(Icons.hourglass_empty),
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
                            NewTypeAction();
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

  Future NewTypeAction() async {
    if (_addItemFormKey.currentState!.validate()) {
      try {
        setState(() {
          _isProcessing = true;
        });

        var type = TypeAction();
        type.TypeAct = typeController.text.trim();
        type.act_simpl = actionSimpl;
        type.analyse_cause = analyseCause;
        type.Supp = 0;
        type.codif_auto = 0;

        var result = await service.saveData(type);
        if (result > 0) {
          //Navigator.pop(context);
          print(result);
          AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.SUCCES,
            body: Center(child: Text(
              'Type Action save successfully',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),),
            title: 'Type Action saved',
            btnCancel: Text('Cancel'),
            btnOkOnPress: () {
              Navigator.of(context).pushNamedAndRemoveUntil(TypeActionScreen.typeActionScreen, (route) => false);
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
