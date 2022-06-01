class Book {
  String? id;
  String? fullName;
  String? email;
  String? job;
  String? createdAt;
  String? updatedAt;

  Book(
      {this.id,
        this.fullName,
        this.email,
        this.job,
        this.createdAt,
        this.updatedAt});

  Book.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    fullName = json['fullName'];
    email = json['email'];
    job = json['job'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['fullName'] = this.fullName;
    data['email'] = this.email;
    data['job'] = this.job;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}