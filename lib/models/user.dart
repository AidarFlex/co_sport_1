import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserProfile {
  String? userId;
  String? username;
  String? name;
  String? profileImage;
  String? location;
  int? friendCount;
  int? eventCount;
  int? teamsCount;
  String? bio;
  List<String>? userDeviceToken;
  Map<String, dynamic>? phoneNumber;
  List<String>? userSearchIndex;
  String? emailId;
  List? friends;
  String? lat;
  String? long;

  UserProfile(
      {this.userId,
      this.username,
      this.name,
      this.profileImage,
      this.location,
      this.phoneNumber,
      this.emailId,
      this.bio,
      this.friends,
      this.userDeviceToken,
      this.lat,
      this.long});

  UserProfile.loadUser(this.userId, this.username, this.name, this.profileImage,
      this.location, this.phoneNumber, this.emailId, this.bio);

  UserProfile.miniView(this.userId, this.name, this.profileImage);

  UserProfile.newuser(this.userId, this.username, this.name, this.profileImage,
      this.emailId, userDeviceToken, this.lat, this.long, this.location) {
    this.userDeviceToken = [userDeviceToken];
    bio = 'Новый пользователь';
    friendCount = 0;
    teamsCount = 0;
    eventCount = 0;
    friends = [];
    phoneNumber = {'show': false, 'ph': ""};
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

List<String>? setSearchParam(String username) {
  List<String>? userSearchList;
  String temp = "";
  for (int i = 0; i < username.length; i++) {
    temp = temp + username[i];
    userSearchList!.add(temp);
  }
  return userSearchList;
}

// Future<double> getLatitude(double? lat) async {
//   Position _currentPosition = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.best,
//       forceAndroidLocationManager: true);

//   lat = _currentPosition.latitude;

//   return lat;
// }

// Future<double> getLongitude(double? long) async {
//   Position _currentPosition = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.best,
//       forceAndroidLocationManager: true);

//   long = _currentPosition.longitude;

//   return long;
// }

// Future<String> getLocation(double lat, double long) async {
//   String currentLocation;
//   List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
//   Placemark plase = placemarks[0];
//   currentLocation = '${plase.locality}';
//   return currentLocation;
// }
