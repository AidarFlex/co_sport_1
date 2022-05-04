import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co_sport_map/models/friends.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:json_annotation/json_annotation.dart';

part 'teams.g.dart';

@JsonSerializable()
class Teams {
  String? teamId;
  String? sport;
  String? teamName;
  String? captain;
  String? manager;
  String? image;
  String? bio;
  List? player;
  List? playerId;
  List? notificationPlayers;
  String? status;
  String? verified;

  Teams(
      {this.teamId,
      this.sport,
      this.teamName,
      this.captain,
      this.manager,
      this.image,
      this.bio,
      this.player,
      this.playerId,
      this.notificationPlayers,
      this.status,
      this.verified});

  Teams.newTeam(this.teamId, this.sport, this.teamName, this.bio, this.status) {
    final Friends myprofile = Friends.newFriend(
        Constants.prefs!.getString('userId') as String,
        Constants.prefs!.getString('name'),
        Constants.prefs!.getString('profileImage'));

    final mapOfProfile = myprofile.toJson();
    captain = Constants.prefs!.getString('userId');
    manager = myprofile.friendId;
    image = "";
    player = [mapOfProfile];
    playerId = [myprofile.friendId];
    notificationPlayers = [];
    verified = 'N';
  }

  factory Teams.fromJson(QueryDocumentSnapshot data) =>
      _$TeamsFromJson(data.data() as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$TeamsToJson(this);
}

@JsonSerializable()
class TeamView {
  String? teamId;
  String? sport;
  String? teamName;

  TeamView({this.teamId, this.sport, this.teamName});

  TeamView.newTeam(
    this.teamId,
    this.sport,
    this.teamName,
  );

  factory TeamView.fromJson(QueryDocumentSnapshot data) =>
      _$TeamViewFromJson(data.data() as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$TeamViewToJson(this);
}

class TeamChallengeNotification {
  String? teamId;
  String? manager;
  String? teamName;
  TeamChallengeNotification({this.teamId, this.manager, this.teamName});

  TeamChallengeNotification.newTeam(
    this.teamId,
    this.manager,
    this.teamName,
  );
}
