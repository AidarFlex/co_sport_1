import 'package:cloud_firestore/cloud_firestore.dart';
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

  factory Friends.fromJson(QueryDocumentSnapshot data) =>
      _$FriendsFromJson(data.data() as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$FriendsToJson(this);
}
