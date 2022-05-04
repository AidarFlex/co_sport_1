// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teams.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Teams _$TeamsFromJson(Map<String, dynamic> json) => Teams(
      teamId: json['teamId'] as String?,
      sport: json['sport'] as String?,
      teamName: json['teamName'] as String?,
      captain: json['captain'] as String?,
      manager: json['manager'] as String?,
      image: json['image'] as String?,
      bio: json['bio'] as String?,
      player: json['player'] as List<dynamic>?,
      playerId: json['playerId'] as List<dynamic>?,
      notificationPlayers: json['notificationPlayers'] as List<dynamic>?,
      status: json['status'] as String?,
      verified: json['verified'] as String?,
    );

Map<String, dynamic> _$TeamsToJson(Teams instance) => <String, dynamic>{
      'teamId': instance.teamId,
      'sport': instance.sport,
      'teamName': instance.teamName,
      'captain': instance.captain,
      'manager': instance.manager,
      'image': instance.image,
      'bio': instance.bio,
      'player': instance.player,
      'playerId': instance.playerId,
      'notificationPlayers': instance.notificationPlayers,
      'status': instance.status,
      'verified': instance.verified,
    };

TeamView _$TeamViewFromJson(Map<String, dynamic> json) => TeamView(
      teamId: json['teamId'] as String?,
      sport: json['sport'] as String?,
      teamName: json['teamName'] as String?,
    );

Map<String, dynamic> _$TeamViewToJson(TeamView instance) => <String, dynamic>{
      'teamId': instance.teamId,
      'sport': instance.sport,
      'teamName': instance.teamName,
    };
