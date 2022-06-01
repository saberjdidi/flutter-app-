
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../Config/customcolors.dart';
import '../Models/Source.dart';
import '../Services/source_service.dart';
import '../Validators/validator.dart';
import 'sources_screen.dart';

class EditSource extends StatefulWidget {

  Source source;
  EditSource({Key? key, required this.source}) : super(key: key);

  @override
  State<EditSource> createState() => _EditSourceState();
}

class _EditSourceState extends State<EditSource> {
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  late bool checkAction;
  late int actionSimpl;
  late bool checkConstat;
  late int observationConstat;

  SourceService sourceService = SourceService();

  TextEditingController  sourceController = TextEditingController();
  @override
  void initState() {
    super.initState();
    sourceController.text = widget.source.SourceAct;
    actionSimpl = widget.source.act_simp;
    if(actionSimpl == 0){
      checkAction = false;
    }
    else {
      checkAction = true;
    }
    observationConstat = widget.source.obs_constat;
    observationConstat == 0 ? checkConstat=false : checkConstat=true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: RaisedButton(
          onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context, SourceScreen.sourceScreen, (route) => false);
          },
          elevation: 0.0,
          child: Icon(Icons.arrow_back, color: Colors.white,),
          color: Colors.blue,
        ),
        title: Center(
          child: Text("Modifier Source"),
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
                          controller: sourceController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) => Validator.validateField(
                              value: value!
                          ),
                          decoration: InputDecoration(
                            labelText: 'Source',
                            hintText: 'source',
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
                          title: const Text('Observation Constat'),
                          value: checkConstat,
                          onChanged: (bool? value) {
                            setState(() {
                              checkConstat = value!;
                              if(checkConstat == true){
                                observationConstat = 1;
                              }
                              else {
                                observationConstat = 0;
                              }
                              print('Observation Constat ${observationConstat}');
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
                            updateSource();
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

  Future updateSource() async {
    if (_addItemFormKey.currentState!.validate()) {
      try {
        setState(() {
          _isProcessing = true;
        });

        var source = Source();
        source.CodeSourceAct = widget.source.CodeSourceAct;
        source.SourceAct = sourceController.text.trim();
        source.act_simp = actionSimpl;
        source.obs_constat = observationConstat;
        source.Supp = widget.source.Supp;

        var result = await sourceService.editData(source);
        if (result > 0) {
          //Navigator.pop(context);
          print(result);
          AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.SUCCES,
            body: Center(child: Text(
              'Source update successfully',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),),
            title: 'Source updated',
            btnCancel: Text('Cancel'),
            btnOkOnPress: () {
              Navigator.of(context).pushNamedAndRemoveUntil(SourceScreen.sourceScreen, (route) => false);
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
