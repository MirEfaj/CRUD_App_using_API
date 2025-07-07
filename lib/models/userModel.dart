class UserModel {
  String? createdAt;
  String? name;
  String? email;
  String? imageURL;
  String? id;

  UserModel({this.createdAt, this.name, this.email, this.imageURL, this.id});

  UserModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    name = json['name'];
    email = json['email'];
    imageURL = json['imageURL'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['name'] = this.name;
    data['email'] = this.email;
    data['imageURL'] = this.imageURL;
    data['id'] = this.id;
    return data;
  }
}
