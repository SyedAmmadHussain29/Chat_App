import 'package:chat_app/Model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  //Firebase auth
  static FirebaseAuth auth = FirebaseAuth.instance;
  //for firebase cloud database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  // for checking if user exists or not?
  static FirebaseStorage storage = FirebaseStorage.instance;
  //to get current user
  static User get user => auth.currentUser!;

  //to get self user
  static late UserModel me;

  //for checking if user exist or not
  static Future<bool> userExist() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //get self into
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = UserModel.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = UserModel(
        id: user.uid,
        name: user.displayName.toString(),
        email: user.email.toString(),
        about: "Hey, I'm using We Chat!",
        image: user.photoURL.toString(),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '');

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection("users")
        .where("id", isNotEqualTo: user.uid)
        .snapshots();
  }

  //for updating user information
  static Future<void> UpdateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      "name": me.name,
      "about": me.about,
    });
  }
}
