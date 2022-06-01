class Priorite {
  int? codepriorite;
  late String priorite;

  prioriteMap(){
    var mapping = Map<String, dynamic>();
    mapping['codepriorite'] = codepriorite;
    mapping['priorite'] = priorite;

    return mapping;
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(Priorite? model) {
    return this.codepriorite == model?.codepriorite;
  }

  @override
  String toString() => priorite;
}