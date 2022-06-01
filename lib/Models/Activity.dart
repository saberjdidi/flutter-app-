class Activity {
  int? Code_domaine;
  late String domaine;
  late String abreviation;

  activityMap(){
    var mapping = Map<String, dynamic>();
    mapping['Code_domaine'] = Code_domaine;
    mapping['domaine'] = domaine;
    mapping['abreviation'] = abreviation;

    return mapping;
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(Activity? model) {
    return this.Code_domaine == model?.Code_domaine;
  }

  @override
  String toString() => domaine;
}