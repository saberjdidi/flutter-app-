import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:first_app_flutter/Models/causeAction.dart';
import 'package:first_app_flutter/UI/causes_screen.dart';
import 'package:first_app_flutter/UI/types_action_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../Config/customcolors.dart';
import '../Models/typeAction.dart';
import '../Services/cause_action_service.dart';
import '../Validators/validator.dart';

class AddCauseAction extends StatefulWidget {
  const AddCauseAction({Key? key}) : super(key: key);

  @override
  State<AddCauseAction> createState() => _AddCauseActionState();
}

class _AddCauseActionState extends State<AddCauseAction> {

  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  bool checkAmdec = false;
  int amdec = 0;

  CauseActionService service = CauseActionService();
  TextEditingController  typeCauseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: RaisedButton(
          onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context, CauseScreen.causeActionScreen, (route) => false);
          },
          elevation: 0.0,
          child: Icon(Icons.arrow_back, color: Colors.white,),
          color: Colors.blue,
        ),
        title: Center(
          child: Text("Ajouter Cause Action"),
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
                          controller: typeCauseController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) => Validator.validateField(
                              value: value!
                          ),
                          decoration: InputDecoration(
                            labelText: 'Type cause',
                            hintText: 'type cause',
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
                          title: const Text('AMDEC'),
                          value: checkAmdec,
                          onChanged: (bool? value) {
                            setState(() {
                              checkAmdec = value!;
                              if(checkAmdec == true){
                                amdec = 1;
                              }
                              else {
                                amdec = 0;
                              }
                              print('amdec ${amdec}');
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
                            newCauseAction();
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

  Future newCauseAction() async {
    if (_addItemFormKey.currentState!.validate()) {
      try {
        setState(() {
          _isProcessing = true;
        });

        var type = CauseAction();
        type.typecause = typeCauseController.text.trim();
        type.Amdec = amdec;

        var result = await service.saveData(type);
        if (result > 0) {
          //Navigator.pop(context);
          print(result);
          AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.SUCCES,
            body: Center(child: Text(
              'Cause Action save successfully',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),),
            title: 'Cause Action saved',
            btnCancel: Text('Cancel'),
            btnOkOnPress: () {
              Navigator.of(context).pushNamedAndRemoveUntil(CauseScreen.causeActionScreen, (route) => false);
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
