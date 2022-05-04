import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co_sport_map/models/events.dart';
import 'package:co_sport_map/models/friends.dart';
import 'package:co_sport_map/models/teams.dart';
import 'package:co_sport_map/services/custom_message.dart';
import 'package:co_sport_map/services/user_services.dart';
import 'package:co_sport_map/utils/contansts.dart';

class EventService {
  final CollectionReference _eventCollectionReference =
      FirebaseFirestore.instance.collection('events');

  addUserToEvent(String id) {
    var userId = Constants.prefs!.get('userId') as String;
    var userName = Constants.prefs!.get('name') as String;
    var profileImage = Constants.prefs!.get('profileImage') as String;
    Friends friend = Friends.newFriend(userId, userName, profileImage);
    _eventCollectionReference.doc(id).set({
      "playersId": FieldValue.arrayUnion([userId]),
      'playerInfo': FieldValue.arrayUnion([friend.toJson()]),
      'participants': FieldValue.arrayUnion([userId]),
    }, SetOptions(merge: true));
  }

  addGivenUsertoEvent(String id, String userId) {
    _eventCollectionReference.doc(id).set({
      "playersId": FieldValue.arrayUnion([userId]),
      'participants': FieldValue.arrayUnion([userId]),
    }, SetOptions(merge: true));
  }

  getCurrentFeed() async {
    return FirebaseFirestore.instance
        .collection("events")
        .where('type', isLessThan: 3)
        // .orderBy('dateTime', descending: true)
        .snapshots();
  }

  getSpecificFeed(String sportName) async {
    return FirebaseFirestore.instance
        .collection("events")
        .where('sportName', isEqualTo: sportName)
        // .orderBy('dateTime', descending: true)
        .snapshots();
  }

  getCurrentUserFeed() async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Constants.prefs!.get('userId') as String)
        .collection('userEvent')
        .orderBy('dateTime')
        .snapshots();
  }

  getCurrentUserEventChats() async {
    return FirebaseFirestore.instance
        .collection("events")
        .where('participants', arrayContains: Constants.prefs!.get('userId'))
        .snapshots();
  }
}

String createNewEvent(
  String eventName,
  String creatorId,
  String creatorName,
  String location,
  String sportName,
  String description,
  List<dynamic> playersId,
  DateTime dateTime,
  int maxMembers,
  String status,
  int type,
  bool challenge,
) {
  var newDoc = FirebaseFirestore.instance.collection('events').doc();
  String id = newDoc.id;
  newDoc.set(Events.newEvent(id, eventName, location, sportName, description,
          dateTime, maxMembers, status, type)
      .toJson());

  EventService().addUserToEvent(id);
  return id;
}

addEventToUser(
    String id,
    String eventName,
    String sportName,
    String location,
    DateTime dateTime,
    String creatorId,
    String creatorName,
    String status,
    int type,
    List<dynamic> playersId) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(Constants.prefs!.get('userId') as String)
      .collection('userEvent')
      .doc(id)
      .set(Events.miniView(id, eventName, sportName, location, dateTime, status,
              creatorId, creatorName, type, playersId)
          .minitoJson());
}

addTeamEventToUser(
  String id,
  String eventName,
  String sportName,
  String location,
  DateTime dateTime,
  String creatorId,
  String creatorName,
  String status,
  int type,
  List<dynamic> playersId,
  String teamName,
  String teamId,
) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(Constants.prefs!.get('userId') as String)
      .collection('userEvent')
      .doc(id)
      .set(Events.miniTeamView(
        id,
        eventName,
        sportName,
        location,
        dateTime,
        status,
        creatorId,
        creatorName,
        type,
        playersId,
        teamName,
        teamId,
      ).miniTeamtoJson());
}

registerUserToEvent(
  String id,
  String eventName,
  String sportName,
  String location,
  DateTime dateTime,
  String creatorId,
  String creatorName,
  String status,
  int type,
  List<dynamic> playersId,
) {
  addEventToUser(id, eventName, sportName, location, dateTime, creatorId,
      creatorName, status, type, playersId);
}

addScheduleToUser(
  String userId,
  String eventName,
  String sportName,
  String location,
  DateTime dateTime,
  String creatorId,
  String creatorName,
  String eventId,
  String status,
  int type,
  List<dynamic> playersId,
) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('userEvent')
      .doc(eventId)
      .set(Events.miniView(eventId, eventName, sportName, location, dateTime,
              status, creatorId, creatorName, type, playersId)
          .minitoJson());
  UserService().updateEventCount(1, userId);
}

Future<Events> getEventDetails(String notificationId) async {
  var snap = await FirebaseFirestore.instance
      .collection('events')
      .doc(notificationId)
      .get();
  Map<String, dynamic>? map = snap.data();
  Events event = Events.fromMap(map!);
  return event;
}

Future<bool> addTeamToEvent(Events event, TeamView team) async {
  bool availability = await Events().checkingAvailability(event.eventId!);
  if (availability) {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(event.eventId)
        .update({
      'playersId':
          FieldValue.arrayUnion([Constants.prefs!.getString('userId')]),
      'participants':
          FieldValue.arrayUnion([Constants.prefs!.getString('userId')]),
      'teamsId': FieldValue.arrayUnion([team.teamId]),
      'teamInfo': FieldValue.arrayUnion([
        {'teamName': team.teamName, 'teamId': team.teamId}
      ])
    });
    addTeamEventToUser(
      event.eventId!,
      event.eventName!,
      event.sportName!,
      event.location!,
      event.dateTime!,
      event.creatorId!,
      event.creatorName!,
      event.status!,
      event.type!,
      event.playersId!,
      team.teamName!,
      team.teamId!,
    );
    await CustomMessageServices()
        .sendEventAcceptEventChatCustomMessage(event.eventId!, team.teamName!);
    await CustomMessageServices().sendEventAcceptTeamChatCustomMessage(
        team.teamId!,
        Constants.prefs!.getString('name') as String,
        event.eventName!);
    return true;
  }

  return false;
}

leaveEvent(Events data) async {
  var userId = Constants.prefs!.get('userId');
  var userName = Constants.prefs!.get('name') as String;
  var profileImage = Constants.prefs!.get('profileImage') as String;
  FirebaseFirestore.instance
      .collection('users')
      .doc(userId as String)
      .collection('userEvent')
      .doc(data.eventId)
      .delete();
  if (data.status == 'individual') {
    Friends friend = Friends.newFriend(userId, userName, profileImage);
    FirebaseFirestore.instance.collection('events').doc(data.eventId).set({
      'playersId': FieldValue.arrayRemove([userId]),
      'playerInfo': FieldValue.arrayRemove([friend.toJson()]),
      'participants': FieldValue.arrayRemove([userId]),
    }, SetOptions(merge: true));
  } else if (data.status == 'team') {
    FirebaseFirestore.instance.collection('events').doc(data.eventId).set({
      'playersId': FieldValue.arrayRemove([userId]),
      'participants': FieldValue.arrayRemove([userId]),
      'teamsId': FieldValue.arrayRemove([data.teamId]),
      'teamInfo': FieldValue.arrayRemove([
        {'teamName': data.teamName, 'teamId': data.teamId}
      ])
    }, SetOptions(merge: true));
  }
  CustomMessageServices().userLeftEventMessage(
      data.eventId!, Constants.prefs!.get('name') as String);
}

deleteEvent(id) async {
  getEventInfo(id);
  await FirebaseFirestore.instance
      .collection('users')
      .doc(Constants.prefs!.get('userId') as String)
      .collection('userEvent')
      .doc(id)
      .delete();
  UserService().updateEventCount(-1, Constants.prefs!.get('userId') as String);
  await FirebaseFirestore.instance.collection('events').doc(id).delete();
}

getEventInfo(String eventId) async {
  List<dynamic> players = await Events().players(eventId);
  for (int i = 0; i < players.length; i++) {
    if (players[i] != Constants.prefs!.get('userId')) {
      deleteIndividualUserMini(eventId, players[i]);
    }
  }
}

deleteIndividualUserMini(String eventId, String userId) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('userEvent')
      .doc(eventId)
      .delete();
  UserService().updateEventCount(-1, userId);
}
