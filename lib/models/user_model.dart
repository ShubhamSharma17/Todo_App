class UserModel {
  String? uid;
  String? name;
  String? phoneNumber;
  String? email;

  UserModel({
    this.email,
    this.name,
    this.phoneNumber,
    this.uid,
  });

  UserModel.fromMap(Map<String, dynamic> map) {
    name = map["name"];
    email = map["email"];
    phoneNumber = map["phoneNumber"];
    uid = map["uid"];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "uid": uid,
    };
  }
}
