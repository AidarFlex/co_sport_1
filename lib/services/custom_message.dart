import 'package:firebase_database/firebase_database.dart';

class CustomMessageServices {
  sendEventAcceptEventChatCustomMessage(String docId, String team) async {
    await FirebaseDatabase.instance.ref('events/$docId/chats').push().set({
      'message': team + " just Joined!",
      'type': 'custom',
      'dateTime': DateTime.now(),
    });
  }

  sendEventAcceptTeamChatCustomMessage(
      String docId, String name, String eventName) async {
    await FirebaseDatabase.instance.ref('teams/$docId/chats').push().set({
      'message': "Team sucessfully got registered for " + eventName,
      'type': 'custom',
      'dateTime': DateTime.now(),
    });
  }

  sendTeamNewMemberJoinMessage(String docId, String name) async {
    await FirebaseDatabase.instance.ref('teams/$docId/chats').push().set({
      'message': "Welcome " + name + " to the team",
      'type': 'custom',
      'dateTime': DateTime.now(),
    });
  }

  sendTeamLeaveMemberMessage(String docId, String name) async {
    await FirebaseDatabase.instance.ref('teams/$docId/chats').push().set({
      'message': name + " says goodbye!",
      'type': 'custom',
      'dateTime': DateTime.now(),
    });
  }

  sendChallegeFirstRoomMessage(String docId) async {
    await FirebaseDatabase.instance.ref('events/$docId/chats').push().set({
      'message':
          "This chat room is to connect the managers of the respective teams",
      'type': 'custom',
      'dateTime': DateTime.now(),
    });
  }

  userLeftEventMessage(String id, String name) async {
    await FirebaseDatabase.instance.ref('events/$id/chats').push().set({
      'message': name + " has left the event",
      'type': 'custom',
      'dateTime': DateTime.now(),
    });
  }

  captainChangeMessage(String teamId, String newCapName) async {
    await FirebaseDatabase.instance.ref('teams/$teamId/chats').push().set({
      'message': newCapName + " is the new Captain!",
      'type': 'custom',
      'dateTime': DateTime.now(),
    });
  }
}
