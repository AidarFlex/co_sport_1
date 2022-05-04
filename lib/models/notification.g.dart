// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationClass _$NotificationClassFromJson(Map<String, dynamic> json) =>
    NotificationClass(
      notificationId: json['notificationId'] as String?,
      senderId: json['senderId'] as String?,
      senderName: json['senderName'] as String?,
      senderProfieImage: json['senderProfieImage'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$NotificationClassToJson(NotificationClass instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderProfieImage': instance.senderProfieImage,
      'notificationId': instance.notificationId,
      'type': instance.type,
    };

TeamNotification _$TeamNotificationFromJson(Map<String, dynamic> json) =>
    TeamNotification(
      notificationId: json['notificationId'] as String?,
      teamId: json['teamId'] as String?,
      senderId: json['senderId'] as String?,
      senderName: json['senderName'] as String?,
      senderPic: json['senderPic'] as String?,
      type: json['type'] as String?,
      teamName: json['teamName'] as String?,
      teamSport: json['teamSport'] as String?,
    );

Map<String, dynamic> _$TeamNotificationToJson(TeamNotification instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'teamId': instance.teamId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderPic': instance.senderPic,
      'type': instance.type,
      'teamName': instance.teamName,
      'teamSport': instance.teamSport,
    };

ChallengeNotification _$ChallengeNotificationFromJson(
        Map<String, dynamic> json) =>
    ChallengeNotification(
      notificationId: json['notificationId'] as String?,
      senderId: json['senderId'] as String?,
      senderName: json['senderName'] as String?,
      sport: json['sport'] as String?,
      myTeamName: json['myTeamName'] as String?,
      opponentTeamName: json['opponentTeamName'] as String?,
      type: json['type'] as String?,
      myTeamId: json['myTeamId'] as String?,
      opponentTeamId: json['opponentTeamId'] as String?,
    );

Map<String, dynamic> _$ChallengeNotificationToJson(
        ChallengeNotification instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'sport': instance.sport,
      'opponentTeamName': instance.opponentTeamName,
      'myTeamName': instance.myTeamName,
      'type': instance.type,
      'myTeamId': instance.myTeamId,
      'opponentTeamId': instance.opponentTeamId,
    };

EventNotification _$EventNotificationFromJson(Map<String, dynamic> json) =>
    EventNotification(
      eventId: json['eventId'] as String?,
      eventName: json['eventName'] as String?,
      notificationId: json['notificationId'] as String?,
      senderId: json['senderId'] as String?,
      senderName: json['senderName'] as String?,
      senderPic: json['senderPic'] as String?,
      subtype: json['subtype'] as String?,
      teamId: json['teamId'] as String?,
      teamName: json['teamName'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$EventNotificationToJson(EventNotification instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'eventId': instance.eventId,
      'eventName': instance.eventName,
      'teamName': instance.teamName,
      'teamId': instance.teamId,
      'senderPic': instance.senderPic,
      'type': instance.type,
      'subtype': instance.subtype,
    };
