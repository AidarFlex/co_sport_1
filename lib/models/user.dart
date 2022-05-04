import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserProfile {
  String? userId;
  String? username;
  String? name;
  String? profileImage;
  String? location;
  String? age;
  String? bio;
  int? friendCount;
  int? eventCount;
  int? teamsCount;
  List<String>? userDeviceToken;
  Map<String, dynamic>? phoneNumber;
  List<String>? userSearchIndex;
  String? emailId;
  List? friends;

  UserProfile(
      {this.userId,
      this.username,
      this.name,
      this.profileImage,
      this.location,
      this.phoneNumber,
      this.emailId,
      this.bio,
      this.age,
      this.friends,
      this.userDeviceToken});

  UserProfile.loadUser(this.userId, this.username, this.name, this.profileImage,
      this.location, this.phoneNumber, this.emailId, this.bio, this.age);

  UserProfile.miniView(this.userId, this.name, this.profileImage);

  UserProfile.newuser(this.userId, this.username, this.name, this.profileImage,
      this.emailId, userDeviceToken) {
    location = '';
    this.userDeviceToken = [userDeviceToken];
    phoneNumber = {'show': false, 'ph': ""};
    bio = 'Новый пользователь';
    age = '';
    friendCount = 0;
    teamsCount = 0;
    eventCount = 0;
    friends = [];
  }

  Map<String, dynamic> miniJson() =>
      {'userId': userId, 'name': name, 'profileImage': profileImage};

  factory UserProfile.fromMap(Map data) {
    return UserProfile(
        userId: data['userId'] ?? "",
        username: data['username'] ?? "",
        name: data['name'] ?? "",
        profileImage: data['profileImage'] ?? "",
        location: data['location'] ?? "",
        phoneNumber: data['phoneNumber'] ?? "",
        emailId: data['emailId'] ?? "");
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

String generateusername(String email) {
  String result = email.replaceAll(RegExp(r'@.+'), "");
  result = result.replaceAll(RegExp(r'\\W+'), " ");
  return result;
}

setSearchParam(String username) {
  List<String>? userSearchList;
  String temp = "";
  for (int i = 0; i < username.length; i++) {
    temp = temp + username[i];
    userSearchList!.add(temp);
  }
  return userSearchList;
}
