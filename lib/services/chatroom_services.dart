import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co_sport_map/models/message.dart';
import 'package:co_sport_map/utils/contansts.dart';

class ChatroomService {
  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('username', isEqualTo: searchField)
        .snapshots();
  }

  addChatRoom(Map<String, dynamic> chatRoom, String chatRoomId) {
    FirebaseFirestore.instance
        .collection("DirectChats")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  void sendNewMessage(DateTime dateTime, String sentby, String message,
      String sentByName, chatRoomId) {
    FirebaseFirestore.instance
        .collection("DirectChats")
        .doc(chatRoomId)
        .collection("chats")
        .add(Message.newMessage(dateTime, sentby, message, sentByName).toJson())
        .catchError((e) {
      print(e.toString());
    });
  }

  void sendNewMessageTeam(DateTime dateTime, String sentby, String message,
      String sentByName, teamId) {
    FirebaseFirestore.instance
        .collection("teams")
        .doc(teamId)
        .collection("chats")
        .add(Message.newMessage(dateTime, sentby, message, sentByName).toJson())
        .catchError((e) {
      print(e.toString());
    });
  }

  void sendNewMessageEvent(DateTime dateTime, String sentby, String message,
      String sentByName, eventId) {
    FirebaseFirestore.instance
        .collection("events")
        .doc(eventId)
        .collection("chats")
        .add(Message.newMessage(dateTime, sentby, message, sentByName).toJson())
        .catchError((e) {
      print(e.toString());
    });
  }

  getTeamMessages(String teamId, int limit) async {
    return FirebaseFirestore.instance
        .collection("teams")
        .doc(teamId)
        .collection("chats")
        .orderBy('dateTime', descending: true)
        .limit(limit)
        .snapshots();
  }

  getEventMessages(String eventId, int limit) async {
    return FirebaseFirestore.instance
        .collection("events")
        .doc(eventId)
        .collection("chats")
        .orderBy('dateTime', descending: true)
        .limit(limit)
        .snapshots();
  }

  getDirectMessages(String chatRoomId, int limit) async {
    return FirebaseFirestore.instance
        .collection("DirectChats")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('dateTime', descending: true)
        .limit(limit)
        .snapshots();
  }

  getUsersDirectChats() async {
    print("I am here");
    return FirebaseFirestore.instance
        .collection("DirectChats")
        .where('users', arrayContains: Constants.prefs!.getString('userId'))
        .snapshots();
  }

  deleteThisMessage(
      String chatroomType, String chatRoomId, String messageId) async {
    FirebaseFirestore.instance
        .collection(chatroomType)
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .delete();
  }
}
