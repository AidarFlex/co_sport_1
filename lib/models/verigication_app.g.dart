// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verigication_app.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationApplication _$VerificationApplicationFromJson(
        Map<String, dynamic> json) =>
    VerificationApplication(
      teamId: json['teamId'] as String?,
      sport: json['sport'] as String?,
      teamName: json['teamName'] as String?,
      applicationId: json['applicationId'] as String?,
    );

Map<String, dynamic> _$VerificationApplicationToJson(
        VerificationApplication instance) =>
    <String, dynamic>{
      'teamId': instance.teamId,
      'sport': instance.sport,
      'teamName': instance.teamName,
      'applicationId': instance.applicationId,
    };
