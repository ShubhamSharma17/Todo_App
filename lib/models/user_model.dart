class UserModel {
  String? uid;
  String? noteID;
  String? name;
  String? phoneNumber;
  String? email;

  UserModel({
    this.noteID,
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
    noteID = map["noteID"];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "noteID": noteID,
      "email": email,
      "phoneNumber": phoneNumber,
      "uid": uid,
    };
  }
}
