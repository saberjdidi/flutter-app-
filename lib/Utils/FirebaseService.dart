import 'package:firebase_database/firebase_database.dart';

/// 1-to define the main collection that stored all content ; after add a post and run the app . It will be visible in your firebase console .
final productReference = FirebaseDatabase.instance.reference().child('product');

/// 2- in this class we will coding of CRUD methods . ///
class Database {
  ///  3- define the variable of ID document to divide the categories of posts ///
  static String? idDocs;

  /// 4- We will start coding the add method operation to add data content to firebase.///
  static Future<void> addItem({
    /// 5- define the content of post ///
    required String title,
    required String description,
    required String image,
  }) async {
    /// 6-the path of stored data in cloud firestore ///

    productReference.push().set({
      'name': title,
      'code': description,
      'description': image,
      'price': title,
      'ProductImage': 'https://icones8.fr/icon/pCvIfmctRaY8/flutter'
    }).whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));

  }

  /// 9- We will  coding the update method operation to update data content to firebase.///
  static Future<void> updateItem({
    required String title,
    required String description,
    required String docId,
    required String image,
  }) async {

    productReference.child(docId).push().set({
      'name': title,
      'code': description,
      'description': image,
      'price': title,
      'ProductImage': 'https://icones8.fr/icon/pCvIfmctRaY8/flutter'
    }).whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

  /// 10- We will  coding the read method operation to read data content to firebase.///
  /// 11- here We will use Stream instead of Future to get latest data available in the database for automatically synchronize data ///

  /*static Stream<DataSnapshot> readItems() {
    Query query = FirebaseDatabase.instance
        .reference()
        .child("posts")
        .orderByKey();

    return query;
  } */

  /// 12- We will coding the delete method operation to delete data content to firebase.///

  static Future<void> deleteItem({
    required String docId,
  }) async {

    productReference.child(docId).push().remove().whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

}
