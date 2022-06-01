

import 'package:cloud_firestore/cloud_firestore.dart';

///  1-pour définir la collection principale qui stocke tout le contenu; après avoir ajouté un message et exécuté l'application.
///  Il sera visible dans votre console Firebase.
final CollectionReference _mainCollection = FirebaseFirestore.instance.collection('posts');

/// 2- dans cette classe, nous allons coder les méthodes CRUD
class Database {

  /// 3- Nous allons commencer à coder l'opération d'ajout de méthode pour ajouter du contenu de données à firebase.
  static Future<void> addItem({
    /// 4- définir le contenu du post ///
    required String title,
    required String description,
    required String image,
  }) async {
    /// 5-le chemin des données stockées dans cloud firestore ///
    DocumentReference documentReferencer =
    _mainCollection.doc();

    /// 6-pour convertir les données en map ///
    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
      "image": image,
    };

    /// 7- Nous utilisons la méthode set() sur le documentReferencer pour écrire de nouvelles données sur le Firestore,
    /// et nous avons transmis les données sous forme de carte ///
    await documentReferencer
        .set(data)
        .whenComplete(() => print("item added to the database"))
        .catchError((e) => print(e));
  }

  /// 8- Nous allons coder l'opération de méthode de mise à jour pour mettre à jour le contenu des données vers firebase.///
  static Future<void> updateItem({
    required String title,
    required String description,
    required String docId,
    required String image,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
      "image": image,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("item updated in the database"))
        .catchError((e) => print(e));
  }

  /// 9- Nous allons coder l'opération de méthode de lecture pour lire le contenu des données sur firebase.///
  /// 10- ici Nous utiliserons Stream au lieu de Future pour obtenir les dernières données disponibles dans la base de données pour synchroniser automatiquement les données ///

  static Stream<QuerySnapshot> readItems() {

    return _mainCollection.snapshots();
  }

  /// 11- Nous allons coder l'opération de méthode de suppression pour supprimer le contenu des données sur firebase.///

  static Future<void> deleteItem({
    required String docId,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
}
