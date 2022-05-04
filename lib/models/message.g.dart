// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      dateTime: json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
      sentby: json['sentby'] as String?,
      message: json['message'] as String?,
      sentByName: json['sentByName'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'dateTime': instance.dateTime?.toIso8601String(),
      'sentby': instance.sentby,
      'message': instance.message,
      'sentByName': instance.sentByName,
      'type': instance.type,
    };
