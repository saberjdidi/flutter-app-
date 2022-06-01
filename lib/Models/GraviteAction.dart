class GraviteAction {
  int? codegravite;
  late String gravite;

  graviteActionMap(){
    var mapping = Map<String, dynamic>();
    mapping['codegravite'] = codegravite;
    mapping['gravite'] = gravite;

    return mapping;
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(GraviteAction? model) {
    return this.codegravite == model?.codegravite;
  }
}