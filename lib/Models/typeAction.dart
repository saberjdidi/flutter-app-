class TypeAction {
  int? CodetypeAct;
  late String TypeAct;
  late int codif_auto;
  late int act_simpl;
  late int Supp;
  late int analyse_cause;

  typeActionMap(){
    var mapping = Map<String, dynamic>();
    mapping['CodetypeAct'] = CodetypeAct;
    mapping['TypeAct'] = TypeAct;
    mapping['codif_auto'] = codif_auto;
    mapping['act_simpl'] = act_simpl;
    mapping['Supp'] = Supp;
    mapping['analyse_cause'] = analyse_cause;

    return mapping;
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(TypeAction? model) {
    return this.CodetypeAct == model?.CodetypeAct;
  }

  @override
  String toString() => TypeAct;
}