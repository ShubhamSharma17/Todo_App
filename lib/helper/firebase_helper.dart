import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/user_model.dart';

class FirebaseHelper {
  static Future<UserModel?> getUserByID(String uid) async {
    UserModel? currentuser;

    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("user").doc(uid).get();

    if (snapshot.data() != null) {
      currentuser = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    }
    return currentuser;
  }
}
