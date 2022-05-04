import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co_sport_map/models/teams.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class NotificationClass {
  String? senderId;
  String? senderName;
  String? senderProfieImage;
  String? notificationId;
  String? type;

  NotificationClass(
      {this.notificationId,
      this.senderId,
      this.senderName,
      this.senderProfieImage,
      this.type});

  NotificationClass.createNewRequest(this.type, String nortificationId,
      this.senderId, this.senderName, String senderProfileImage) {
    notificationId = nortificationId;
    senderProfieImage = senderProfileImage;
  }
  factory NotificationClass.fromJson(QueryDocumentSnapshot data) =>
      _$NotificationClassFromJson(data.data() as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$NotificationClassToJson(this);
}

@JsonSerializable()
class TeamNotification {
  String? notificationId;
  String? teamId;
  String? senderId;
  String? senderName;
  String? senderPic;
  String? type;
  String? teamName;
  String? teamSport;

  TeamNotification(
      {this.notificationId,
      this.teamId,
      this.senderId,
      this.senderName,
      this.senderPic,
      this.type,
      this.teamName,
      this.teamSport});
  TeamNotification.newNotification(
      this.notificationId, this.teamId, this.teamName, this.teamSport) {
    senderId = Constants.prefs!.getString('userId');
    senderName = Constants.prefs!.getString('name');
    senderPic = Constants.prefs!.getString('profileImage');
    type = "inviteTeams";
  }

  factory TeamNotification.fromJson(QueryDocumentSnapshot json) =>
      _$TeamNotificationFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$TeamNotificationToJson(this);
}

@JsonSerializable()
class ChallengeNotification {
  String? notificationId;
  String? senderId;
  String? senderName;
  String? sport;
  String? opponentTeamName;
  String? myTeamName;
  String? type;
  String? myTeamId;
  String? opponentTeamId;

  ChallengeNotification(
      {this.notificationId,
      this.senderId,
      this.senderName,
      this.sport,
      this.myTeamName,
      this.opponentTeamName,
      this.type,
      this.myTeamId,
      this.opponentTeamId});

  ChallengeNotification.createNewRequest(
      this.notificationId,
      this.sport,
      TeamChallengeNotification myteam,
      TeamChallengeNotification opponentTeam) {
    senderId = Constants.prefs!.getString('userId');
    senderName = Constants.prefs!.getString('name');
    myTeamName = myteam.teamName;
    opponentTeamName = opponentTeam.teamName;
    myTeamId = myteam.teamId;
    opponentTeamId = opponentTeam.teamId;
    type = "challenge";
  }

  factory ChallengeNotification.fromJson(QueryDocumentSnapshot json) =>
      _$ChallengeNotificationFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$ChallengeNotificationToJson(this);
}

@JsonSerializable()
class EventNotification {
  String? notificationId;
  String? senderId;
  String? senderName;
  String? eventId;
  String? eventName;
  String? teamName;
  String? teamId;
  String? senderPic;
  String? type;
  String? subtype;

  EventNotification({
    this.eventId,
    this.eventName,
    this.notificationId,
    this.senderId,
    this.senderName,
    this.senderPic,
    this.subtype,
    this.teamId,
    this.teamName,
    this.type,
  });

  EventNotification.createIndividualNotification(
      this.notificationId, this.eventId, this.eventName) {
    senderId = Constants.prefs!.getString('userId');
    senderName = Constants.prefs!.getString('name');
    senderPic = Constants.prefs!.getString('profileImage');
    type = 'event';
    subtype = 'individual';
  }

  EventNotification.createTeamsNotification(this.notificationId, this.eventId,
      this.eventName, this.teamId, this.teamName) {
    senderId = Constants.prefs!.getString('userId');
    senderName = Constants.prefs!.getString('name');
    type = 'event';
    subtype = 'team';
  }

  Map<String, dynamic> toUserJson() => {
        'notificationId': notificationId,
        'senderId': senderId,
        'senderName': senderName,
        'eventId': eventId,
        'eventName': eventName,
        'senderPic': senderPic,
        'type': type,
        'subtype': subtype,
      };

  Map<String, dynamic> toTeamJson() => {
        'notificationId': notificationId,
        'senderId': senderId,
        'senderName': senderName,
        'eventId': eventId,
        'eventName': eventName,
        'type': type,
        'subtype': subtype,
        'teamName': teamName,
        'teamId': teamId
      };

  EventNotification.team(
      {this.notificationId,
      this.senderId,
      this.senderName,
      this.eventId,
      this.eventName,
      this.teamId,
      this.teamName,
      this.subtype});

  EventNotification.individual(
      {this.notificationId,
      this.senderId,
      this.senderName,
      this.senderPic,
      this.eventId,
      this.eventName,
      this.subtype});

  factory EventNotification.fromJson(QueryDocumentSnapshot data) {
    var parsedJson = data.data() as Map<String, dynamic>;
    if (parsedJson['subtype'] == 'individual') {
      return EventNotification.individual(
          notificationId: parsedJson['notificationId'],
          senderId: parsedJson['senderId'],
          senderName: parsedJson['senderName'],
          senderPic: parsedJson['senderPic'],
          eventId: parsedJson['eventId'],
          eventName: parsedJson['eventName'],
          subtype: parsedJson['subtype']);
    }

    return EventNotification.team(
        notificationId: parsedJson['notificationId'],
        senderId: parsedJson['senderId'],
        senderName: parsedJson['senderName'],
        eventId: parsedJson['eventId'],
        eventName: parsedJson['eventName'],
        teamId: parsedJson['teamId'],
        teamName: parsedJson['teamName'],
        subtype: parsedJson['subtype']);
  }
}
