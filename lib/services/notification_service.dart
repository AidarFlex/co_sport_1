import 'package:co_sport_map/models/events.dart';
import 'package:co_sport_map/models/friends.dart';
import 'package:co_sport_map/models/notification.dart';
import 'package:co_sport_map/models/teams.dart';
import 'package:co_sport_map/services/custom_message.dart';
import 'package:co_sport_map/services/event_service.dart';
import 'package:co_sport_map/services/frinds_services.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:firebase_database/firebase_database.dart';

class NotificationServices {
  final _id = Constants.prefs.getString('userId').toString();
  final _name = Constants.prefs.getString('name').toString();
  final String _profileImage =
      Constants.prefs.getString('profileImage').toString();

  createRequest(String uid) {
    var db = FirebaseDatabase.instance.ref('users/$uid/notification');
    var doc = db.push();
    String id = doc.key.toString();
    doc.set(NotificationClass.createNewRequest(
            "friend", id, _id, _name, _profileImage)
        .toJson());
    FirebaseDatabase.instance.ref('users/$uid').update({
      'notification': [_id]
    });
  }

  declineRequest(String id, String uid) {
    var db = FirebaseDatabase.instance.ref('users/$_id/notification');
    FirebaseDatabase.instance.ref('users/$_id').update({
      'notification': [uid]
    });
    db.child(id).remove();
  }

  acceptFriendRequest(NotificationClass data) {
    var db = FirebaseDatabase.instance.ref('users');
    db.child('$_id/friends/${data.senderId}').set(Friends.newFriend(
            data.senderId!, data.senderName, data.senderProfieImage)
        .toJson());

    db
        .child('${data.senderId}/friends/$_id')
        .set(Friends.newFriend(_id, _name, _profileImage).toJson());
    declineRequest(data.notificationId!, data.senderId!);

    FriendServices().addUpdateMyFriendCount(1, data.senderId!, _id);
    FriendServices().addUpdateMyFriendCount(1, _id, data.senderId!);
  }

  getNotification() async {
    return FirebaseDatabase.instance.ref("users/$_id/notification").onValue;
  }

  createIndividualNotification(Events event) async {
    var db =
        FirebaseDatabase.instance.ref('users/${event.creatorId}/notification');

    var doc = db.push();
    String id = doc.key.toString();
    final EventNotification eventNotification =
        EventNotification.createIndividualNotification(
            id, event.eventId, event.eventName);
    doc.set(eventNotification.toUserJson());
    await FirebaseDatabase.instance.ref('events/${event.eventId}').update({
      'notificationPlayers': [_id]
    });
  }

  Future<Events> checkPlayerCount(String notificationId) async {
    var snap =
        await FirebaseDatabase.instance.ref('events/$notificationId').get();
    Map map = snap as Map;
    Events event = Events.fromMap(map);
    return event;
  }

  acceptIndividualNotification(EventNotification notification) async {
    Events event = await checkPlayerCount(notification.eventId!);
    Friends friend = Friends.newFriend(notification.senderId!,
        notification.senderName, notification.senderPic);
    if (event.playersId!.length < event.maxMembers!) {
      await FirebaseDatabase.instance
          .ref('events/${notification.eventId}')
          .update({
        'playersId': [notification.senderId],
        'notificationPlayers': [notification.senderId],
        'playerInfo': [friend.toJson()]
      });
      await addScheduleToUser(
        notification.senderId!,
        event.eventName!,
        event.sportName!,
        event.location!,
        event.dateTime!,
        event.creatorId!,
        event.creatorName!,
        event.eventId!,
        event.status!,
        event.type!,
        event.playersId!,
      );

      declineNotification(notification.notificationId!);
      return true;
    }

    return false;
  }

  declineEventNotification(EventNotification notificationData) async {
    declineNotification(notificationData.notificationId!);
    await FirebaseDatabase.instance
        .ref('events/${notificationData.eventId}')
        .update({
      'notificationPlayers': [notificationData.senderId]
    });
  }

  teamEventNotification(Events event, TeamView teamView) async {
    var db =
        FirebaseDatabase.instance.ref('users/${event.creatorId}/notification');

    var doc = db.push();
    String id = doc.key.toString();
    final EventNotification eventNotification =
        EventNotification.createTeamsNotification(id, event.eventId,
            event.eventName, teamView.teamId, teamView.teamName);
    doc.set(eventNotification.toTeamJson());
    await FirebaseDatabase.instance.ref('events/${event.eventId}').update({
      'notificationPlayers': [_id]
    });
  }

  createTeamNotification(String from, String to, Teams teamView) async {
    var db = FirebaseDatabase.instance.ref('users/$to/notification');
    var doc = db.push();
    String id = doc.key.toString();
    doc.set(TeamNotification.newNotification(
            id, teamView.teamId, teamView.teamName, teamView.sport)
        .toJson());
    await FirebaseDatabase.instance.ref('teams/${teamView.teamId}').update({
      'notificationPlayers': [from]
    });
  }

  acceptTeamInviteNotification(TeamNotification team) async {
    final Friends user = Friends.newFriend(_id, _name, _profileImage);
    await FirebaseDatabase.instance.ref('users/$_id').update({
      'teams': [team.teamId]
    });
    await FirebaseDatabase.instance.ref('teams/${team.teamId}').update({
      'players': [user.toJson()],
      'playerId': [user.friendId],
      'notificationPlayers': [user.friendId],
    });
    CustomMessageServices().sendTeamNewMemberJoinMessage(team.teamId!, _name);
    declineTeamInviteNotification(team);
  }

  declineTeamInviteNotification(TeamNotification teams) async {
    declineNotification(teams.notificationId!);
    await FirebaseDatabase.instance.ref('teams/${teams.teamId}').update({
      'notificationPlayers': [teams.senderId]
    });
  }

  void challengeTeamNotification(
      String sport,
      TeamChallengeNotification teamViewOpponent,
      TeamChallengeNotification teamViewMe) async {
    var db = FirebaseDatabase.instance
        .ref('users/${teamViewOpponent.manager}/notification');

    var doc = db.push();
    String id = doc.key.toString();
    final ChallengeNotification challenge =
        ChallengeNotification.createNewRequest(
            id, sport, teamViewOpponent, teamViewMe);

    doc.set(challenge.toJson());
  }

  Future<bool> acceptTeamEventNotification(
      EventNotification notification) async {
    Events event = await checkPlayerCount(notification.eventId!);
    if (event.playersId!.length < event.maxMembers!) {
      await FirebaseDatabase.instance
          .ref('events/${notification.eventId}')
          .update({
        'playersId': [notification.senderId],
        'teamsId': [notification.teamId],
        'notificationPlayers': [notification.senderId],
        'teamInfo': [
          {'teamName': notification.teamName, 'teamId': notification.teamId}
        ]
      });
      await addScheduleToUser(
        notification.senderId!,
        event.eventName!,
        event.sportName!,
        event.location!,
        event.dateTime!,
        event.creatorId!,
        event.creatorName!,
        event.eventId!,
        event.status!,
        event.type!,
        event.playersId!,
      );
      declineTeamRequest(notification.eventId!, notification.notificationId!,
          notification.senderId!);
      await CustomMessageServices().sendEventAcceptEventChatCustomMessage(
          notification.eventId!, notification.teamName!);
      await CustomMessageServices().sendEventAcceptTeamChatCustomMessage(
          notification.teamId!,
          notification.senderName!,
          notification.eventName!);
      return true;
    }
    return false;
  }

  void acceptChallengeTeamNotification(
      ChallengeNotification notificationData) async {
    String nameOftheEvent = notificationData.myTeamName! +
        ' Vs ' +
        notificationData.opponentTeamName!;
    String eventId = createNewEvent(
      nameOftheEvent,
      notificationData.senderId!,
      notificationData.senderName!,
      "Challenge",
      notificationData.sport!,
      "Challenge",
      [_id],
      DateTime.now(),
      2,
      "private",
      3,
      true,
    );
    EventService().addGivenUsertoEvent(eventId, notificationData.senderId!);
    CustomMessageServices().sendChallegeFirstRoomMessage(eventId);
    declineNotification(notificationData.notificationId!);
  }

  void declineNotification(String notificationId) async {
    await FirebaseDatabase.instance
        .ref('users/$_id/notification/$notificationId')
        .remove();
  }

  void declineTeamRequest(String eventId, String id, String uid) {
    var db = FirebaseDatabase.instance.ref('users/$_id/notification');
    FirebaseDatabase.instance.ref('events/$eventId').update({
      'notificationPlayers': [uid]
    });
    db.child(id).remove();
  }
}
