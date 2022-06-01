class Employe {
  int? id;
  late String Mat;
  late String Nompre;
  late String Adresse_mail;
  late String Tel;


  prioriteMap(){
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['Mat'] = Mat;
    mapping['Nompre'] = Nompre;
    mapping['Adresse_mail'] = Adresse_mail;
    mapping['Tel'] = Tel;

    return mapping;
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(Employe? model) {
    return this.id == model?.id;
  }

  @override
  String toString() => Mat;
}