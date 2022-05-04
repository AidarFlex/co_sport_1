import 'package:json_annotation/json_annotation.dart';

part 'friends.g.dart';

@JsonSerializable()
class Friends {
  String? name;
  String? profileImage;
  String? friendId;

  Friends({this.friendId, this.name, this.profileImage});

  Friends.newFriend(String id, this.name, this.profileImage) {
    friendId = id;
  }

  factory Friends.fromJson(Map data) {
    var parsedJson = data;
    return Friends(
        friendId: parsedJson['id'],
        name: parsedJson['name'],
        profileImage: parsedJson['profileImage']);
  }

  Map<String, dynamic> toJson() => _$FriendsToJson(this);
}
