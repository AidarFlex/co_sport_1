import 'package:co_sport_map/models/message.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatroomService {
  searchByName(String searchField) {
    return FirebaseDatabase.instance
        .ref("users/username")
        .equalTo(searchField)
        .onValue;
  }

  addChatRoom(Map<String, dynamic> chatRoom, String chatRoomId) {
    FirebaseDatabase.instance
        .ref("DirectChats/$chatRoomId")
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  void sendNewMessage(DateTime dateTime, String sentby, String message,
      String sentByName, chatRoomId) {
    FirebaseDatabase.instance
        .ref("DirectChats/$chatRoomId/chats")
        .push()
        .set(Message.newMessage(dateTime, sentby, message, sentByName).toJson())
        .catchError((e) {
      print(e.toString());
    });
  }

  void sendNewMessageTeam(DateTime dateTime, String sentby, String message,
      String sentByName, teamId) {
    FirebaseDatabase.instance
        .ref("teams/$teamId/chats")
        .push()
        .set(Message.newMessage(dateTime, sentby, message, sentByName).toJson())
        .catchError((e) {
      print(e.toString());
    });
  }

  void sendNewMessageEvent(DateTime dateTime, String sentby, String message,
      String sentByName, eventId) {
    FirebaseDatabase.instance
        .ref("events/$eventId/chats")
        .push()
        .set(Message.newMessage(dateTime, sentby, message, sentByName).toJson())
        .catchError((e) {
      print(e.toString());
    });
  }

  getTeamMessages(String teamId, int limit) async {
    return FirebaseDatabase.instance
        .ref("teams/$teamId/chats")
        .orderByChild('dateTime')
        .limitToLast(limit)
        .onValue;
  }

  getEventMessages(String eventId, int limit) async {
    return FirebaseDatabase.instance
        .ref("events/$eventId/chats")
        .orderByChild('dateTime')
        .limitToLast(limit)
        .onValue;
  }

  getDirectMessages(String chatRoomId, int limit) async {
    return FirebaseDatabase.instance
        .ref("DirectChats/$chatRoomId/chats")
        .orderByChild('dateTime')
        .limitToLast(limit)
        .onValue;
  }

  // getUsersDirectChats() async {
  //   return FirebaseDatabase.instance
  //       .ref("DirectChats")
  //       .orderByChild('users')
  //       .equalTo(Constants.prefs.getString('userId'))
  //       .onValue;
  // }

  deleteThisMessage(
      String chatroomType, String chatRoomId, String messageId) async {
    FirebaseDatabase.instance
        .ref('$chatroomType/$chatRoomId/chats/messageId')
        .remove();
  }
}
