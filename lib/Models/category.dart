class Category {
  late int id;
  late String name;
  late String description;

  categoryMap(){
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['description'] = description;

    return mapping;
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(Category? model) {
    return this.id == model?.id;
  }

  @override
  String toString() => name;
}