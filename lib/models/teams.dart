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
  List? notification;
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
      this.notification,
      this.status,
      this.verified});

  Teams.newTeam(this.teamId, this.sport, this.teamName, this.bio, this.status) {
    final Friends myprofile = Friends.newFriend(
        Constants.prefs.getString('userId') as String,
        Constants.prefs.getString('name'),
        Constants.prefs.getString('profileImage'));

    final mapOfProfile = myprofile.toJson();
    captain = Constants.prefs.getString('userId');
    manager = myprofile.friendId;
    image = "";
    player = [mapOfProfile];
    playerId = [myprofile.friendId!];
    notification = ['1'];
    verified = 'N';
  }

  factory Teams.fromJson(Map<dynamic, dynamic> data) {
    var parsedJson = data;
    return Teams(
        teamId: parsedJson['teamId'],
        sport: parsedJson['sport'],
        teamName: parsedJson['teamName'],
        captain: parsedJson['captain'],
        bio: parsedJson['bio'],
        manager: parsedJson['manager'],
        image: parsedJson['image'],
        player: parsedJson['players'],
        playerId: parsedJson['playerId'],
        notification: parsedJson['notificationPlayers'],
        status: parsedJson['status'],
        verified: parsedJson['verified']);
  }

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

  // factory TeamView.fromJson(Map<dynamic, dynamic> data) =>
  //     _$TeamViewFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$TeamViewToJson(this);

  factory TeamView.fromJson(Map<dynamic, dynamic> data) {
    var parsedJson = data;
    return TeamView(
      teamId: parsedJson['teamId'],
      sport: parsedJson['sport'],
      teamName: parsedJson['teamName'],
    );
  }
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
