class Note {
  int? id;
  late String name;
  late String description;
  late String image;

  toMap(){
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['description'] = description;
    mapping['image'] = image;

    return mapping;
  }

  /*Note.fromMap(Map<String, dynamic> map){
    id = map['id'];
    name = map['name'];
    description = map['description'];
    image = map['image'];
  } */
}