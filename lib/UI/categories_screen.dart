import 'package:first_app_flutter/Config/customcolors.dart';
import 'package:first_app_flutter/Models/category.dart';
import 'package:first_app_flutter/Services/category_service.dart';
import 'package:first_app_flutter/UI/dashboardscreen.dart';
import 'package:flutter/material.dart';

import '../Authentication/register_screen.dart';
import 'search_categories.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  var _categoryNameController = TextEditingController();
  var _categorydescriptionController = TextEditingController();
  var category;

  var _category = Category();
  CategoryService _categoryService = CategoryService();
  List<Category> _categoryList = List<Category>.empty(growable: true);

   final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState(){
    getData();
    super.initState();
  }

  getData() async {
    _categoryList = List<Category>.empty(growable: true);
    var categories = await _categoryService.readData();
    categories.forEach((category){
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }

  editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.getCategoryById(categoryId);
    setState(() {
      _categoryNameController.text = category[0]['name'] ?? 'No name';
      _categorydescriptionController.text = category[0]['description'] ?? 'No description';
    });
    _editFormDialog(context);
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
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const DashboardScreen()));
          },
          elevation: 0.0,
          child: Icon(Icons.arrow_back, color: Colors.white,),
          color: Colors.blue,
        ),
        title: Text("Categories"),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
              onPressed: (){
                showSearch(
                  context: context,
                  delegate: SearchCategoryDelegate(_categoryList),
                );
              },
              icon: Icon(Icons.search)
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _categoryList.length,
          itemBuilder: (context, index){
            return Card(
              child: ListTile(
                leading: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: (){
                    editCategory(context, _categoryList[index].id);
                  },
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_categoryList[index].name),
                    //Text("${sites[index]['name']}"),
                    IconButton(
                      icon: const Icon(
                          Icons.delete,
                          color: Colors.red,),
                      onPressed: () async {
                        _deleteDialog(context, _categoryList[index].id);
                      },
                    )
                  ],
                ),
              ),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showFormDialog(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,),
        backgroundColor: CustomColors.googleBackground,
      ),
    );
  }

  _showFormDialog(BuildContext context){
  return showDialog(context: context, barrierDismissible: true, builder: (param){
    return AlertDialog(
      //backgroundColor: Colors.white,
      title: Center(
        child: Text(
          "New Category",
          style: TextStyle(
              color: Colors.black,
              fontSize: 20.0
          ),),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _categoryNameController,
              decoration: const InputDecoration(
                hintText: 'Write a name',
                labelText: 'Name',
                fillColor: Colors.black,
                focusColor: Colors.black,
                hoverColor: Colors.blue
              ),
             cursorColor: Colors.black,
              textInputAction: TextInputAction.next,
            ),
            TextField(
              controller: _categorydescriptionController,
              decoration: const InputDecoration(
                  hintText: 'Write a description',
                  labelText: 'Description'
              ),
              textInputAction: TextInputAction.next
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          color: Colors.red,
        ),
        FlatButton(
            onPressed: () async {
              _category.name = _categoryNameController.text;
              _category.description = _categorydescriptionController.text;
              var result = await _categoryService.saveData(_category);
              //var result = await _categoryService.saveData(_categoryNameController.text, _categorydescriptionController.text);
              if(result > 0) {
                Navigator.pop(context);
                showSuccessSnackBar(Text("Data saved"));
                getData();
              }
            },
            child: Text('Save'),
          color: Colors.blue,
        )
      ],
    );
  });
  }

  _editFormDialog(BuildContext context){
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
        //backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Update Category",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0
            ),),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _categoryNameController,
                decoration: const InputDecoration(
                    hintText: 'Write a name',
                    labelText: 'Name',
                    fillColor: Colors.black,
                    focusColor: Colors.black,
                    hoverColor: Colors.blue
                ),
                cursorColor: Colors.black,
                  textInputAction: TextInputAction.next
              ),
              TextField(
                controller: _categorydescriptionController,
                decoration: const InputDecoration(
                    hintText: 'Write a description',
                    labelText: 'Description'
                ),
                  textInputAction: TextInputAction.next
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text('Cancel'),
            color: Colors.red,
          ),
          FlatButton(
            onPressed: () async {
              _category.id = category[0]['id'];
              _category.name = _categoryNameController.text;
              _category.description = _categorydescriptionController.text;
              var result = await _categoryService.editData(_category);
              //var result = await _categoryService.editData(_category.id, _category.name, _category.description);
              if(result > 0) {
                showSuccessSnackBar(Text("Data updated"));
                getData();
                Navigator.pop(context);
              }
            },
            child: Text('Save'),
            color: Colors.blue,
          )
        ],
      );
    });
  }

  void _deleteDialog(context, position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Are you sure to delete this item?'),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                onPressed: () async {
                  int response = await _categoryService.deleteData(position);
                  if(response > 0){
                    _categoryList.removeWhere((element) => element.id == position);
                    setState(() {});
                  }
                  Navigator.of(context).pop();
                }
            ),
            new FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
