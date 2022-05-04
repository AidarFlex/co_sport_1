// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friends _$FriendsFromJson(Map<String, dynamic> json) => Friends(
      friendId: json['friendId'] as String?,
      name: json['name'] as String?,
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$FriendsToJson(Friends instance) => <String, dynamic>{
      'name': instance.name,
      'profileImage': instance.profileImage,
      'friendId': instance.friendId,
    };
