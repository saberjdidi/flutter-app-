import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:first_app_flutter/Models/category.dart';
import 'package:first_app_flutter/UI/actions_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Config/customcolors.dart';
import '../Models/Action.dart';
import '../Models/site.dart';
import '../Services/action_service.dart';
import '../Services/category_service.dart';
import '../Services/site_service.dart';
import '../Validators/validator.dart';
import 'actions_screen.dart';

class EditAction extends StatefulWidget {

  ActionModel actionModel;
  //final declencheur;

  EditAction({Key? key, required this.actionModel}) : super(key: key);

  @override
  State<EditAction> createState() => _EditActionState();
}

class _EditActionState extends State<EditAction> {

  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  SiteService siteService = SiteService();
  ActionService actionService = ActionService();
  CategoryService categoryService = CategoryService();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  final TextEditingController  declencheurController = TextEditingController();
  final TextEditingController  dateController = TextEditingController();
  final TextEditingController  designationController = TextEditingController();
  final TextEditingController  descriptionController = TextEditingController();
  final TextEditingController  causeController = TextEditingController();
  //final TextEditingController  siteController = TextEditingController();
  final TextEditingController  sourceController = TextEditingController();
  //final TextEditingController  typeController = TextEditingController();

  var _selectedSite;
  List sites = [];
  List<String> dropDown = [];

  List<Site> siteList = List<Site>.empty(growable: true);
  List<Site> sitesDisplay = <Site>[];
  var selectedSiteName;
  var selectedSiteDescription;
  Site siteM = Site();
  Category catModel = Category();

  List<Category> _categoryList = List<Category>.empty(growable: true);
  List<Category> _categoriesDisplay = <Category>[];
  var selectedCategoryName = null;
  var selectedCategoryDescription = null;

  getSites() async {
    List<Map> response = await siteService.readData();
    sites.addAll(response);
    sites.forEach((site){
      setState(() {
        dropDown.add(site['name']);
      });
    });
  }

  @override
  void initState(){
    declencheurController.text = widget.actionModel.MatDeclancheur;
    designationController.text = widget.actionModel.Act;
    descriptionController.text = widget.actionModel.DescPb;
    dateController.text = widget.actionModel.Date;
    //causeController.text = widget.actionModel.Cause ?? '';
    //sourceController.text = widget.actionModel.source;
    //typeController.text = widget.actionModel.type;
    //_selectedSite = widget.actionModel.RefAudit;
    //selectedSiteName = widget.actionModel.site;

    /* siteM.id = 1;
    siteM.description = widget.actionModel.site;
    siteM.name = widget.actionModel.site;

    catModel.id = 1;
    catModel.name = widget.actionModel.type;
    catModel.description = widget.actionModel.type; */

    getSites();
    super.initState();
  }

  DateTime dateTime = DateTime.now();
  selectedDate(BuildContext context) async {
    var datePicker = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100)
    );
    if(datePicker != null){
      setState(() {
        dateTime = datePicker;
        //dateController.text = DateFormat('dd/MM/yyyy').format(datePicker);
        dateController.text = DateFormat.yMMMMd().format(datePicker);
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
          child: Text("Update Action"),
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
                            SizedBox(height: 3.0,),
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
                                  )
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
                                  )
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
                              decoration: InputDecoration(
                                  labelText: 'Date',
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
                                  )
                              ),
                              style: TextStyle(fontSize: 14.0),
                            ),

                            /*SizedBox(height: 10.0,),
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
                                  )
                              ),
                              style: TextStyle(fontSize: 14.0),
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
                                selectedSiteName = widget.actionModel.site ?? data?.name;
                                selectedSiteDescription =widget.actionModel.site ?? data!.description;
                                print(selectedSiteName);
                                print(selectedSiteDescription);
                              },
                              dropdownBuilder: _customDropDownSite,
                              popupItemBuilder: _customPopupItemBuilderSite,
                              selectedItem: siteM,
                              validator: (u) =>
                              u == null ? "site is required " : null,
                            ), */

                            SizedBox(height: 10.0,),

                            DropdownSearch<String>(
                              mode: Mode.MENU,
                              showSelectedItems: true,
                              showClearButton: true,
                              showSearchBox: true,
                              items: dropDown,
                              dropdownSearchDecoration: InputDecoration(
                                  labelText: "Site",
                                  hintText: "select site",
                                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                  border: OutlineInputBorder()
                              ),
                              popupItemDisabled: (String s) => s.startsWith('I'),
                              onChanged: (value) {
                                setState(() {
                                  _selectedSite = value;
                                  print(value);
                                });
                              },
                              selectedItem: _selectedSite,
                              validator: (value) => Validator.validateField(
                                  value: value!
                              ),
                            ),

                            SizedBox(height: 10.0,),

                            DropdownSearch<Category>(
                              showSelectedItems: true,
                              showClearButton: true,
                              showSearchBox: true,
                              isFilteredOnline: true,
                              compareFn: (i, s) => i?.isEqual(s) ?? false,
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Type",
                                contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                border: OutlineInputBorder(),
                              ),
                              //onFind: (String? filter) => getCategories(filter),
                              onChanged: (data) {
                                selectedSiteName = data?.name;
                                selectedSiteDescription = data!.description;
                                print(selectedSiteName);
                                print(selectedSiteDescription);
                              },
                              //dropdownBuilder: _customDropDownType,
                              //popupItemBuilder: _customPopupItemBuilderType,
                              //selectedItem: siteM,
                              validator: (u) =>
                              u == null ? "site is required " : null,
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
                                //updateAction();
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

  /*
  void updateAction() async {
    if (_addItemFormKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      var actionObject = ActionModel();
      actionObject.id = widget.actionModel.id;
      actionObject.description = descriptionController.text;
      actionObject.date = dateController.text;
      actionObject.declencheur = declencheurController.text;
      actionObject.designation = designationController.text;
      actionObject.cause = causeController.text;
      actionObject.site = _selectedSite.toString();
      actionObject.source = sourceController.text;
      //actionObject.type = typeController.text;
      actionObject.type = selectedSiteName.toString();
      print(actionObject.type);

      var result = await actionService.editData(actionObject);
      if (result > 0) {
        //Navigator.pop(context);
        //showSuccessSnackBar(Text("Data updated"));
        AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.INFO,
          body: Center(child: Text(
            'Action update successfully',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),),
          title: 'Action updated',
          btnCancel: Text('Cancel'),
          btnOkOnPress: () {
            Navigator.of(context).pushNamedAndRemoveUntil(ActionPage.actionPage, (route) => false);
          },
        )..show();
        print(result);
      }
      setState(() {
        _isProcessing = false;
      });
    }
  }

  //type
  Widget _customDropDownType(BuildContext context, Category? item) {
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
  Widget _customPopupItemBuilderType(
      BuildContext context, Category? item, bool isSelected) {
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

  Future<List<Category>> getCategories(filter) async {
    _categoryList = List<Category>.empty(growable: true);
    var categories = await categoryService.readData();
    categories.forEach((category){
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
    _categoriesDisplay = _categoryList.where((u) {
      var name = u.name.toLowerCase();
      var description = u.description.toLowerCase();
      return name.contains(filter) ||
          description.contains(filter);
    }).toList();
    return _categoriesDisplay;
  }
  //Site
  Widget _selectDropDownSite(BuildContext context, Site? item) {
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
        title: Text(widget.actionModel.site),
        subtitle: Text(
          widget.actionModel.site,
        ),
      ),
    );
  }
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
  */
}
