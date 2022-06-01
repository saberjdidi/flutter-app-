import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:first_app_flutter/Models/Activity.dart';
import 'package:first_app_flutter/Services/activity_service.dart';
import 'package:first_app_flutter/Services/sous_action_service.dart';
import 'package:first_app_flutter/UI/activities_screen.dart';
import 'package:first_app_flutter/UI/sous_action_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Config/customcolors.dart';
import '../Models/Action.dart';
import '../Models/Source.dart';
import '../Models/SousAction.dart';
import '../Services/source_service.dart';
import '../Validators/validator.dart';
import 'sources_screen.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class AddSousAction extends StatefulWidget {
  //final idAction;
  ActionModel actionModel;
  AddSousAction({Key? key, required this.actionModel}) : super(key: key);

  @override
  State<AddSousAction> createState() => _AddSousActionState();
}

class _AddSousActionState extends State<AddSousAction> {

  GlobalKey<FormState>  _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  SousActionService service = SousActionService();

  TextEditingController  designationController = TextEditingController();
  TextEditingController  dateRealisationController = TextEditingController();
  TextEditingController  dateSuiviController = TextEditingController();
  TextEditingController  risqueController = TextEditingController();

  DateTime dateTime = DateTime.now();
  DateTime datePickerReal = DateTime.now();
  DateTime datePickerSuivi = DateTime.now();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //dateRealisationController.text = DateFormat.yMMMMd().format(datePickerReal);
    dateRealisationController.text = DateFormat('dd/MM/yyyy').format(datePickerReal);
    dateSuiviController.text = DateFormat('dd/MM/yyyy').format(datePickerSuivi);
  }
  
  selectedDateReal(BuildContext context) async {
    datePickerReal = (await showDatePicker(
        context: context,
        initialDate: datePickerReal,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100)
      //lastDate: DateTime.now()
    ))!;
    if(datePickerReal != null){
      setState(() {
        //dateTime = datePicker;
        dateRealisationController.text = DateFormat('dd/MM/yyyy').format(datePickerReal);
        //dateRealisationController.text = DateFormat.yMMMMd().format(datePickerReal);
      });
    }
  }

  selectedDateSuivi(BuildContext context) async {
    datePickerSuivi = (await showDatePicker(
        context: context,
        initialDate: datePickerSuivi,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100)
        //firstDate: datePickerReal,
      //lastDate: DateTime.now()
    ))!;
    if(datePickerSuivi != null){
      setState(() {
        //dateTime = datePicker;
        dateSuiviController.text = DateFormat('dd/MM/yyyy').format(datePickerSuivi);
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: RaisedButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          elevation: 0.0,
          child: Icon(Icons.arrow_back, color: Colors.white,),
          color: Colors.blue,
        ),
        title: Center(
          child: Text("Ajouter Sous Action ${widget.actionModel.NAct}"),
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
                          controller: designationController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) => Validator.validateField(
                              value: value!
                          ),
                          decoration: InputDecoration(
                            labelText: 'Designation',
                            hintText: 'designation',
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
                          controller: risqueController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) => Validator.validateField(
                              value: value!
                          ),
                          decoration: InputDecoration(
                            labelText: 'Risques',
                            hintText: 'risques',
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
                          controller: dateRealisationController,
                          keyboardType: TextInputType.datetime,
                          textInputAction: TextInputAction.next,
                          validator: (value) => Validator.validateField(
                              value: value!
                          ),
                          onChanged: (value){
                            selectedDateReal(context);
                          },
                          decoration: InputDecoration(
                              labelText: 'Date realisation',
                              hintText: 'date realisation',
                              labelStyle: TextStyle(
                                fontSize: 14.0,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0,
                              ),
                              suffixIcon: InkWell(
                                onTap: (){
                                  selectedDateReal(context);
                                },
                                child: Icon(Icons.calendar_today),
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              )
                          ),
                          style: TextStyle(fontSize: 14.0),
                        ),
                        SizedBox(height: 10.0,),
                        TextFormField(
                          controller: dateSuiviController,
                          keyboardType: TextInputType.datetime,
                          textInputAction: TextInputAction.next,
                          validator: (value) => Validator.validateField(
                              value: value!
                          ),
                          onChanged: (value){
                            selectedDateSuivi(context);
                          },
                          decoration: InputDecoration(
                              labelText: 'Date Suivi',
                              hintText: 'date suivi',
                              labelStyle: TextStyle(
                                fontSize: 14.0,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0,
                              ),
                              suffixIcon: InkWell(
                                onTap: (){
                                  selectedDateSuivi(context);
                                },
                                child: Icon(Icons.calendar_today),
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              )
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
                            setState(() {
                              newSousAction();
                            });
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

  Future newSousAction() async {
    if (_addItemFormKey.currentState!.validate()) {
      try {
        if(datePickerSuivi.isBefore(datePickerReal)){
          AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.ERROR,
            body: Center(child: Text(
              'Le delai de suivi doit être supérieur au délai de réalisation',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),),
            title: 'Error',
            btnOkOnPress: () {
              //Navigator.of(context).pop();
            },
          )..show();
          _isProcessing = false;
          return;
        }

        _isProcessing = true;
        var model = SousAction();
        model.NAct = widget.actionModel.NAct!;
        model.Designation = designationController.text.trim();
        model.risque = risqueController.text.trim();
        model.date_real = dateRealisationController.text;
        model.date_suivi = dateSuiviController.text;

        print('num Action : ${model.NAct}');
        print('Designation : ${model.Designation}');
        print('risque : ${model.risque}');
        print('date_real : ${model.date_real}');
        print('date_suivi : ${model.date_suivi}');

          var result = await service.saveData(model);
          if (result > 0) {
            print(result);
            AwesomeDialog(
              context: context,
              animType: AnimType.SCALE,
              dialogType: DialogType.SUCCES,
              body: Center(child: Text(
                'SousAction save successfully',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),),
              title: 'SousAction saved',
              btnOkOnPress: () {
                //Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context)=>SousActionList(actionModel: widget.actionModel)),
                        (route) => false);
              },
            )..show();
          }
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
        _isProcessing = false;
      }

    }
  }
}
