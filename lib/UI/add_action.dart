import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:first_app_flutter/Models/category.dart';
import 'package:first_app_flutter/PopupList/source_list.dart';
import 'package:first_app_flutter/Services/activity_service.dart';
import 'package:first_app_flutter/Services/category_service.dart';
import 'package:first_app_flutter/Services/source_service.dart';
import 'package:first_app_flutter/Services/type_action_service.dart';
import 'package:first_app_flutter/UI/actions_page.dart';
import 'package:first_app_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Config/customcolors.dart';
import '../Config/shared_preference.dart';
import '../Models/Action.dart';
import '../Models/Activity.dart';
import '../Models/Source.dart';
import '../Models/site.dart';
import '../Models/typeAction.dart';
import '../Models/user_model.dart';
import '../Services/action_service.dart';
import '../Services/site_service.dart';
import '../Validators/validator.dart';
import 'actions_screen.dart';

class AddAction extends StatefulWidget {

  AddAction({Key? key}) : super(key: key);

  @override
  State<AddAction> createState() => _AddActionState();
}

class _AddActionState extends State<AddAction> {

  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  ActionService actionService = ActionService();
  SiteService siteService = SiteService();
  TypeActionService typeActionService = TypeActionService();
  SourceService sourceService = SourceService();
  ActivityService activityService = ActivityService();
  CategoryService categoryService = CategoryService();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  TextEditingController  declencheurController = TextEditingController();
  TextEditingController  dateController = TextEditingController();
  TextEditingController  designationController = TextEditingController();
  TextEditingController  descriptionController = TextEditingController();
  TextEditingController  causeController = TextEditingController();
  //TextEditingController  siteController = TextEditingController();
  //TextEditingController  sourceController = TextEditingController();
  DateTime dateTime = DateTime.now();

  //final String? declencheur = sharedPref.getString('email');
  String name = '';

  //var _categories = List<DropdownMenuItem>.empty(growable: true);
  
  List<TypeAction> _typesList = List<TypeAction>.empty(growable: true);
  List<TypeAction> _typesDisplay = <TypeAction>[];
  late int? selectedCodetypeAct;
  var selectedTypeAct = null;

  List<Site> siteList = List<Site>.empty(growable: true);
  List<Site> sitesDisplay = <Site>[];
  var selectedSiteCode;
  var selectedSiteDescription;

  List categories = [];
  List<String> dropDown = [];
  var selectedNumAudit;

  List<Source> _sourcesList = List<Source>.empty(growable: true);
  List<Source> _sourcesDisplay = <Source>[];
  late int? selectedCodeSourceAct;
  var selectedSourceAct = null;

  List<Activity> _activitiesList = List<Activity>.empty(growable: true);
  List<Activity> _activitiesDisplay = <Activity>[];
  late int? selectedIdActivity;
  var selectedDomaineAct = null;

  @override
  void initState(){
    dateController.text = DateFormat('dd/MM/yyyy').format(dateTime);
    //dateController.text = DateFormat.yMMMMd().format(dateTime);
    //declencheurController.text = declencheur!;
    name = SharedPreference.getUsername() ?? 'test';
    declencheurController.text = name;

    /*if(widget.category == null){
      source = '';
    }
    else if (widget.category != null) {
      source = widget.category.description;
    }
    sourceController.text = source; */
    getCategories();
    super.initState();
  }


  getCategories() async {
    List<Map> response = await categoryService.readData();
    categories.addAll(response);
    categories.forEach((data){
      setState(() {
        dropDown.add(data['name']);
      });
    });
  }

  selectedDate(BuildContext context) async {
    var datePicker = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime.now()
        //lastDate: DateTime.now()
    );
    if(datePicker != null){
      setState(() {
        dateTime = datePicker;
        dateController.text = DateFormat('dd/MM/yyyy').format(datePicker);
        //dateController.text = DateFormat.yMMMMd().format(datePicker);
      });
    }
  }

  showSuccessSnackBar(message){
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState!.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: RaisedButton(
          onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context, ActionPage.actionPage, (route) => false);
          },
          elevation: 0.0,
          child: Icon(Icons.arrow_back, color: Colors.white,),
          color: Colors.blue,
        ),
        title: Center(
          child: Text("Ajouter Action"),
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
                              enabled: false,
                              controller: declencheurController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) => Validator.validateField(
                                  value: value!
                              ),
                              decoration: InputDecoration(
                                  labelText: 'Declencheur',
                                  hintText: 'declencheur',
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
                                  )
                              ),
                              style: TextStyle(fontSize: 14.0),
                            ),
                            SizedBox(height: 10.0,),
                            TextFormField(
                              controller: descriptionController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) => Validator.validateField(
                                  value: value!
                              ),
                              decoration: InputDecoration(
                                  labelText: 'Description',
                                  hintText: 'description',
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
                              controller: causeController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) => Validator.validateField(
                                  value: value!
                              ),
                              decoration: InputDecoration(
                                  labelText: 'Cause',
                                  hintText: 'cause',
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
                                )
                              ),
                              style: TextStyle(fontSize: 14.0),
                            ),
                            SizedBox(height: 10.0,),
                            TextFormField(
                              controller: dateController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) => Validator.validateField(
                                  value: value!
                              ),
                              onChanged: (value){
                                selectedDate(context);
                              },
                              decoration: InputDecoration(
                                  labelText: 'Date creation',
                                  hintText: 'date',
                                  labelStyle: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10.0,
                                  ),
                                 suffixIcon: InkWell(
                                   onTap: (){
                                     selectedDate(context);
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
                            Visibility(
                              visible: true,
                                child: DropdownSearch<Source>(
                                  showSelectedItems: true,
                                  showClearButton: true,
                                  showSearchBox: true,
                                  isFilteredOnline: true,
                                  compareFn: (i, s) => i?.isEqual(s) ?? false,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Source",
                                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    border: OutlineInputBorder(),
                                  ),
                                  onFind: (String? filter) => getSources(filter),
                                  onChanged: (data) {
                                    selectedCodeSourceAct = data?.CodeSourceAct;
                                    selectedSourceAct = data!.SourceAct;
                                    print(selectedCodeSourceAct);
                                    print(selectedSourceAct);
                                  },
                                  dropdownBuilder: _customDropDownSource,
                                  popupItemBuilder: _customPopupItemBuilderSource,
                                  validator: (u) =>
                                  u == null ? "type is required " : null,
                                )
                            ),
                            SizedBox(height: 10.0,),
                            /* 
                            SizedBox(height: 3.0,),
                            DropdownSearch<dynamic>(
                              mode: Mode.MENU,
                              showSelectedItems: true,
                              showClearButton: true,
                              showSearchBox: true,
                              items: _typesList.map((e)=>e.name).toList(),
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Type",
                                hintText: "select type",
                              ),
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value;
                                  print(value);
                                });
                              },
                              selectedItem: selectedCategory,
                              validator: (value) => Validator.validateField(
                                  value: value!
                              ),
                            ), */
                            SizedBox(height: 10.0,),
                            DropdownSearch<TypeAction>(
                              showSelectedItems: true,
                              showClearButton: true,
                              showSearchBox: true,
                              isFilteredOnline: true,
                              compareFn: (i, s) => i?.isEqual(s) ?? false,
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Type action",
                                contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                border: OutlineInputBorder(),
                              ),
                              onFind: (String? filter) => getTypes(filter),
                              onChanged: (data) {
                                selectedCodetypeAct = data?.CodetypeAct;
                                selectedTypeAct = data!.TypeAct;
                                print(selectedCodetypeAct);
                                print(selectedTypeAct);
                              },
                              dropdownBuilder: _customDropDownType,
                              popupItemBuilder: _customPopupItemBuilderType,
                              validator: (u) =>
                              u == null ? "type is required " : null,
                            ),
                            SizedBox(height: 10.0,),
                            DropdownSearch<Site>(
                            showSelectedItems: true,
                                showClearButton: true,
                                showSearchBox: true,
                                isFilteredOnline: true,
                                compareFn: (i, s) => i?.isEqual(s) ?? false,
                            dropdownSearchDecoration: InputDecoration(
                              labelText: "Site",
                              contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                              border: OutlineInputBorder(),
                            ),
                            onFind: (String? filter) => getSite(filter),
                            onChanged: (data) {
                              selectedSiteCode = data?.id;
                              selectedSiteDescription = data!.description;
                              print(selectedSiteCode);
                              print(selectedSiteDescription);
                            },
                            dropdownBuilder: _customDropDownSite,
                            popupItemBuilder: _customPopupItemBuilderSite,
                            validator: (u) =>
                            u == null ? "site is required " : null,
                                onBeforeChange: (a, b) {
                                  if (b == null) {
                                    AlertDialog alert = AlertDialog(
                                      title: Text("Are you sure..."),
                                      content: Text("...you want to clear the selection"),
                                      actions: [
                                        TextButton(
                                          child: Text("OK"),
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                        TextButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                      ],
                                    );

                                    return showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alert;
                                        });
                                  }

                                  return Future.value(true);
                                }
                          ),
                            SizedBox(height: 10.0,),
                            DropdownSearch<Activity>(
                                showSelectedItems: true,
                                showClearButton: true,
                                showSearchBox: true,
                                isFilteredOnline: true,
                                compareFn: (i, s) => i?.isEqual(s) ?? false,
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Activity",
                                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                  border: OutlineInputBorder(),
                                ),
                                onFind: (String? filter) => getActivities(filter),
                                onChanged: (data) {
                                  selectedIdActivity = data?.Code_domaine;
                                  selectedDomaineAct = data!.domaine;
                                  print(selectedIdActivity);
                                  print(selectedDomaineAct);
                                },
                                dropdownBuilder: _customDropDownActivity,
                                popupItemBuilder: _customPopupItemBuilderActivity,
                                validator: (u) =>
                                u == null ? "activity is required " : null,
                                onBeforeChange: (a, b) {
                                  if (b == null) {
                                    AlertDialog alert = AlertDialog(
                                      title: Text("Are you sure..."),
                                      content: Text("...you want to clear the selection"),
                                      actions: [
                                        TextButton(
                                          child: Text("OK"),
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                        TextButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                      ],
                                    );

                                    return showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alert;
                                        });
                                  }

                                  return Future.value(true);
                                }
                            ),
                            SizedBox(height: 10.0,),
                            DropdownSearch<String>(
                              mode: Mode.MENU,
                              showSelectedItems: true,
                              showClearButton: true,
                              showSearchBox: true,
                              items: dropDown,
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "reference Audit",
                                hintText: "select Audit",
                                border: OutlineInputBorder(),
                              ),
                              popupItemDisabled: (String s) => s.startsWith('I'),
                              onChanged: (value) {
                                setState(() {
                                  selectedNumAudit = value;
                                  print(value);
                                });
                              },
                              selectedItem: selectedNumAudit,
                              validator: (value) => Validator.validateField(
                                  value: value!
                              ),
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
                                addAction();
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
                          ],
                        )
                    )
                ),
              ),
            ),
          )
      ),
    );
  }

  addAction() async {
    if (_addItemFormKey.currentState!.validate()) {
      try {
        setState(() {
          _isProcessing = true;
        });

        var actionObject = ActionModel();
        actionObject.DescPb = descriptionController.text;
        actionObject.Date = dateController.text;
        //actionObject.Date = dateTime;
        actionObject.MatDeclancheur = declencheurController.text;
        //actionObject.declencheur= declencheur!;
        actionObject.Act = designationController.text;
        actionObject.Cause = causeController.text;
        actionObject.CodeSite = selectedSiteCode;
        actionObject.CodeSourceAct = selectedCodeSourceAct!;
        actionObject.CodeTypeAct = selectedCodetypeAct!;
        actionObject.id_domaine = selectedIdActivity!;
        actionObject.RefAudit = selectedNumAudit;

        print('date : ${actionObject.Date}');
        print('type action : ${actionObject.CodeTypeAct}');
        print('source action : ${actionObject.CodeSourceAct}');
        print('activity action : ${actionObject.id_domaine}');
        print('ref audit : ${actionObject.RefAudit}');

        var result = await actionService.saveData(actionObject);
        if (result > 0) {
          //Navigator.pop(context);
          //showSuccessSnackBar(Text("Data saved"));
          print(result);
          AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.SUCCES,
            body: Center(child: Text(
              'Action save successfully',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),),
            title: 'Action saved',
            btnCancel: Text('Cancel'),
            btnOkOnPress: () {
              Navigator.of(context).pushNamedAndRemoveUntil(ActionPage.actionPage, (route) => false);
            },
          )..show();
        }
        setState(() {
          _isProcessing = false;
        });
      }
      catch (ex){
        _isProcessing = false;
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

  //activity
  Widget _customDropDownActivity(BuildContext context, Activity? item) {
    if (item == null) {
      return Container();
    }

    return Container(
      child: (item.Code_domaine == null)
          ? ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text("No item selected"),
      )
          : ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(item.domaine),
        subtitle: Text(item.abreviation),
      ),
    );
  }
  Widget _customPopupItemBuilderActivity(
      BuildContext context, Activity? item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.domaine ?? ''),
        subtitle: Text(item?.abreviation ?? ''),
      ),
    );
  }
  Future<List<Activity>> getActivities(filter) async {
    _activitiesList = List<Activity>.empty(growable: true);
    var response = await activityService.readData();
    response.forEach((action){
      setState(() {
        var model = Activity();
        model.Code_domaine = action['Code_domaine'];
        model.domaine = action['domaine'];
        model.abreviation = action['abreviation'];
        _activitiesList.add(model);
      });
    });
    _activitiesDisplay = _activitiesList.where((u) {
      var name = u.domaine.toLowerCase();
      var desc = u.abreviation.toLowerCase();
      return name.contains(filter) ||
              desc.contains(filter);
    }).toList();
    return _activitiesDisplay;
  }

  //type action
  Widget _customDropDownType(BuildContext context, TypeAction? item) {
    if (item == null) {
      return Container();
    }

    return Container(
      child: (item.CodetypeAct == null)
          ? ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text("No item selected"),
      )
          : ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(item.TypeAct),
      ),
    );
  }
  Widget _customPopupItemBuilderType(
      BuildContext context, TypeAction? item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.TypeAct ?? ''),
        //subtitle: Text(item?.TypeAct ?? ''),
      ),
    );
  }
  Future<List<TypeAction>> getTypes(filter) async {
    _typesList = List<TypeAction>.empty(growable: true);
    var response = await typeActionService.readData();
    response.forEach((action){
      setState(() {
        var typeModel = TypeAction();
        typeModel.CodetypeAct = action['CodetypeAct'];
        typeModel.TypeAct = action['TypeAct'];
        typeModel.codif_auto = action['codif_auto'];
        typeModel.act_simpl = action['act_simpl'];
        typeModel.Supp = action['Supp'];
        typeModel.analyse_cause = action['analyse_cause'];
        _typesList.add(typeModel);
      });
    });
    _typesDisplay = _typesList.where((u) {
      var name = u.TypeAct.toLowerCase();
      return name.contains(filter);
    }).toList();
    return _typesDisplay;
  }

  //source action
  Widget _customDropDownSource(BuildContext context, Source? item) {
    if (item == null) {
      return Container();
    }

    return Container(
      child: (item.CodeSourceAct == null)
          ? ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text("No item selected"),
      )
          : ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(item.SourceAct),
      ),
    );
  }
  Widget _customPopupItemBuilderSource(
      BuildContext context, Source? item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.SourceAct ?? ''),
        //subtitle: Text(item?.TypeAct ?? ''),
      ),
    );
  }
  Future<List<Source>> getSources(filter) async {
    _sourcesList = List<Source>.empty(growable: true);
    var response = await sourceService.readData();
    response.forEach((action){
      setState(() {
        var sourceModel = Source();
        sourceModel.CodeSourceAct = action['CodeSourceAct'];
        sourceModel.SourceAct = action['SourceAct'];
        sourceModel.act_simp = action['act_simp'];
        sourceModel.obs_constat = action['obs_constat'];
        sourceModel.Supp = action['Supp'];
        _sourcesList.add(sourceModel);
      });
    });
    _sourcesDisplay = _sourcesList.where((u) {
      var name = u.SourceAct.toLowerCase();
      return name.contains(filter);
    }).toList();
    return _sourcesDisplay;
  }
  
  //Site
  Widget _customDropDownSite(BuildContext context, Site? item) {
    if (item == null) {
      return Container();
    }

    return Container(
      child: (item.id == null)
          ? ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text("No item selected"),
      )
          : ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(item.name),
        subtitle: Text(
          item.description,
        ),
      ),
    );
  }
  Widget _customPopupItemBuilderSite(
      BuildContext context, Site? item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.name ?? ''),
        subtitle: Text(item?.description ?? ''),
      ),
    );
  }

  Future<List<Site>> getSite(filter) async {
    siteList = List<Site>.empty(growable: true);
    var sites = await siteService.readData();
    sites.forEach((site){
      setState(() {
        var siteModel = Site();
        siteModel.name = site['name'];
        siteModel.description = site['description'];
        siteModel.id = site['id'];
        siteList.add(siteModel);
      });
    });
    sitesDisplay = siteList.where((u) {
      var name = u.name.toLowerCase();
      var description = u.description.toLowerCase();
      return name.contains(filter) ||
          description.contains(filter);
    }).toList();
    return sitesDisplay;
  }
 
}
