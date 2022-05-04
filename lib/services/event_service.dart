import 'dart:async';

import 'package:co_sport_map/models/events.dart';
import 'package:co_sport_map/models/friends.dart';
import 'package:co_sport_map/models/teams.dart';
import 'package:co_sport_map/services/custom_message.dart';
import 'package:co_sport_map/services/user_services.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:firebase_database/firebase_database.dart';

final _eventCollectionReference = FirebaseDatabase.instance;

class EventService {
void addUserToEvent(String id) {
    var userId = Constants.prefs.get('userId') as String;
    var userName = Constants.prefs.get('name') as String;
    var profileImage = Constants.prefs.get('profileImage') as String;
    Friends friend = Friends.newFriend(userId, userName, profileImage);
    _eventCollectionReference.ref('events/$id').update(
      {
        "playersId": [userId],
        'playerInfo': [friend.toJson()],
        'participants': [userId],
      },
    );
  }

 void addGivenUsertoEvent(String id, String userId) {
    _eventCollectionReference.ref(id).update(
      {
        "playersId": [userId],
        'participants': [userId],
      },
    );
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
  var newDoc = _eventCollectionReference.ref('events').push();
  var id = newDoc.key.toString();
  newDoc.set(Events.newEvent(id, eventName, location, sportName, description,
          dateTime, maxMembers, status, type)
      .toJson());
  if (challenge) {
    addEventToUser(id, eventName, sportName, location, dateTime, creatorId,
        creatorName, status, type, playersId);
  } else if (status == 'individual') {
    EventService().addUserToEvent(id);
  }
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
  _eventCollectionReference
      .ref('users/${Constants.prefs.get('userId')}/userEvent/$id')
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
  _eventCollectionReference
      .ref('users/${Constants.prefs.get('userId')}/userEvents/$id')
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
  _eventCollectionReference.ref('users/$userId/userEvent/eventId').set(
      Events.miniView(eventId, eventName, sportName, location, dateTime, status,
              creatorId, creatorName, type, playersId)
          .minitoJson());
  UserService().updateEventCount(1, userId);
}

Future<bool> addTeamToEvent(Events event, TeamView team) async {
  bool availability = await Events().checkingAvailability(event.eventId!);
  if (availability) {
    await _eventCollectionReference
        .ref('events/${event.eventId.toString()}')
        .update({
      'playersId': [Constants.prefs.getString('userId')],
      'participants': [Constants.prefs.getString('userId')],
      'teamsId': [team.teamId],
      'teamInfo': [
        {'teamName': team.teamName, 'teamId': team.teamId}
      ]
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
        Constants.prefs.getString('name') as String,
        event.eventName!);
    return true;
  }

  return false;
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

leaveEvent(Events data) async {
  var userId = Constants.prefs.get('userId');
  var userName = Constants.prefs.get('name') as String;
  var profileImage = Constants.prefs.get('profileImage') as String;
  _eventCollectionReference
      .ref('users/${userId as String}/userEvent/${data.eventId.toString()}')
      .remove();
  if (data.status == 'individual') {
    Friends friend = Friends.newFriend(userId, userName, profileImage);
    _eventCollectionReference.ref('events/${data.eventId.toString()}').update(
      {
        'playersId': [userId].remove(userId),
        'playerInfo': [friend.toJson()].remove(friend.toJson()),
        'participants': [userId].remove(userId),
      },
    );
  } else if (data.status == 'team') {
    _eventCollectionReference.ref('events/${data.eventId.toString()}').set(
      {
        'playersId': [userId],
        'participants': [userId],
        'teamsId': [data.teamId],
        'teamInfo': [
          {'teamName': data.teamName, 'teamId': data.teamId}
        ]
      },
    );
  }
  CustomMessageServices().userLeftEventMessage(
      data.eventId!, Constants.prefs.get('name') as String);
}

deleteEvent(id) async {
  getEventInfo(id);
  _eventCollectionReference
      .ref('users/${Constants.prefs.get('userId') as String}/userEvent/$id')
      .remove();
  UserService().updateEventCount(-1, Constants.prefs.get('userId') as String);
  await _eventCollectionReference.ref('events/$id').remove();
}

getEventInfo(String eventId) async {
  List<dynamic> players = await Events().players(eventId);
  for (int i = 0; i < players.length; i++) {
    if (players[i] != Constants.prefs.get('userId')) {
      deleteIndividualUserMini(eventId, players[i]);
    }
  }
}

deleteIndividualUserMini(String eventId, String userId) async {
  await _eventCollectionReference
      .ref('users/$userId/userEvent/$eventId')
      .remove();
  UserService().updateEventCount(-1, userId);
}
