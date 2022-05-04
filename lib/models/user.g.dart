// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      userId: json['userId'] as String?,
      username: json['username'] as String?,
      name: json['name'] as String?,
      profileImage: json['profileImage'] as String?,
      location: json['location'] as String?,
      phoneNumber: json['phoneNumber'] as Map<String, dynamic>?,
      emailId: json['emailId'] as String?,
      bio: json['bio'] as String?,
      friends: json['friends'] as List<dynamic>?,
      userDeviceToken: (json['userDeviceToken'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      lat: json['lat'] as String?,
      long: json['long'] as String?,
    )
      ..friendCount = json['friendCount'] as int?
      ..eventCount = json['eventCount'] as int?
      ..teamsCount = json['teamsCount'] as int?
      ..userSearchIndex = (json['userSearchIndex'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList();

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'name': instance.name,
      'profileImage': instance.profileImage,
      'location': instance.location,
      'friendCount': instance.friendCount,
      'eventCount': instance.eventCount,
      'teamsCount': instance.teamsCount,
      'bio': instance.bio,
      'userDeviceToken': instance.userDeviceToken,
      'phoneNumber': instance.phoneNumber,
      'userSearchIndex': instance.userSearchIndex,
      'emailId': instance.emailId,
      'friends': instance.friends,
      'lat': instance.lat,
      'long': instance.long,
    };
