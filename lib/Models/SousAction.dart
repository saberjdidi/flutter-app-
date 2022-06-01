class SousAction {
  int? id;
  late int NAct;
  late String Designation;
  late String date_real;
  late String date_suivi;
  late String risque;

  sousActionMap(){
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['NAct'] = NAct;
    mapping['Designation'] = Designation;
    mapping['date_real'] = date_real;
    mapping['date_suivi'] = date_suivi;
    mapping['risque'] = risque;

    return mapping;
  }
}