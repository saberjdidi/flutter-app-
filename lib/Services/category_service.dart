import 'package:first_app_flutter/Models/category.dart';
import 'package:first_app_flutter/Repositories/repository.dart';

import '../Repositories/db_helper.dart';

class CategoryService {

  DBHelper dbHelper = DBHelper();

  readData() async {
    return await dbHelper.readCategory("categorie");
  }

  saveData(Category category) async {
    return await dbHelper.insertCategory("categorie", {
      "name": "${category.name}",
      "description": "${category.description}"
    });
  }

  editData(Category category) async {
    return await dbHelper.updateCategory(
        "categorie",
        category.categoryMap()
    );
  }

  deleteData(final id) async{
    return await dbHelper.deleteCategory(
        "categorie",
        "id = ${id}"
    );
  }

  getCategoryById(categoryId) async {
    return await dbHelper.readCategoryById("categorie",categoryId);
  }
}