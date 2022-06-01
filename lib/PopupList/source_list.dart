import 'package:first_app_flutter/UI/add_action.dart';
import 'package:flutter/material.dart';

import '../Models/category.dart';
import '../Services/category_service.dart';
import '../Services/site_service.dart';

class SourceList extends StatefulWidget {
  const SourceList({Key? key}) : super(key: key);

  @override
  State<SourceList> createState() => _SourceListState();
}

class _SourceListState extends State<SourceList> {

  CategoryService _categoryService = CategoryService();
  List<Category> _categoryList = List<Category>.empty(growable: true);

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

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          ListView.builder(
              itemCount: _categoryList.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index){
                return Card(
                  color: Colors.white60,
                  child: ListTile(
                    textColor: Colors.black87,
                    title: Text("${_categoryList[index].name}"),
                    subtitle: Text(_categoryList[index].description),
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context) => AddAction(),
                       settings: RouteSettings(
                         arguments: _categoryList[index]
                       )
                     ));
                   },
                  ),
                );
              }
          )
        ],
      ),
    );
  }
}
