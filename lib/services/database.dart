import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: username)
        .get();
  }

  getUserByEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection('users').add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomID, chatRoomMap) {
    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomID)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConverationMessage(String chatRoomID, messageMap) {
    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConverationMessages(String chatRoomID) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomID)
        .collection('messages')
        .snapshots();
  }
}
