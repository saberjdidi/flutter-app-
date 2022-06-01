class CauseAction {
  int? codetypecause;
  late String typecause;
  late int Amdec;

  causeActionMap(){
    var mapping = Map<String, dynamic>();
    mapping['codetypecause'] = codetypecause;
    mapping['typecause'] = typecause;
    mapping['Amdec'] = Amdec;

    return mapping;
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(CauseAction? model) {
    return this.codetypecause == model?.codetypecause;
  }

}