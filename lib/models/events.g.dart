// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Events _$EventsFromJson(Map<String, dynamic> json) => Events(
      eventId: json['eventId'] as String?,
      eventName: json['eventName'] as String?,
      creatorId: json['creatorId'] as String?,
      creatorName: json['creatorName'] as String?,
      location: json['location'] as String?,
      sportName: json['sportName'] as String?,
      description: json['description'] as String?,
      playersId: json['playersId'] as List<dynamic>?,
      participants: json['participants'] as List<dynamic>?,
      playerInfo: json['playerInfo'] as List<dynamic>?,
      teamInfo: json['teamInfo'] as List<dynamic>?,
      dateTime: json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
      maxMembers: json['maxMembers'] as int?,
      status: json['status'] as String?,
      notification: json['notification'] as List<dynamic>?,
      type: json['type'] as int?,
      teamId: json['teamId'] as String?,
      teamName: json['teamName'] as String?,
    );

Map<String, dynamic> _$EventsToJson(Events instance) => <String, dynamic>{
      'eventName': instance.eventName,
      'eventId': instance.eventId,
      'creatorId': instance.creatorId,
      'creatorName': instance.creatorName,
      'location': instance.location,
      'sportName': instance.sportName,
      'description': instance.description,
      'playersId': instance.playersId,
      'participants': instance.participants,
      'playerInfo': instance.playerInfo,
      'teamId': instance.teamId,
      'teamInfo': instance.teamInfo,
      'notification': instance.notification,
      'dateTime': instance.dateTime?.toIso8601String(),
      'maxMembers': instance.maxMembers,
      'status': instance.status,
      'type': instance.type,
      'teamName': instance.teamName,
    };
