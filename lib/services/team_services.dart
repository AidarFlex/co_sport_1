import 'package:co_sport_map/models/friends.dart';
import 'package:co_sport_map/models/teams.dart';
import 'package:co_sport_map/models/verigication_app.dart';
import 'package:co_sport_map/services/custom_message.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:firebase_database/firebase_database.dart';

class TeamService {
  final _teamCollectionReference = FirebaseDatabase.instance;

  final Friends me = Friends.newFriend(
      Constants.prefs.getString('userId') as String,
      Constants.prefs.getString('name'),
      Constants.prefs.getString('profileImage'));
  Teams createNewTeam(
      String sport, String teamName, String bio, String status) {
    var newDoc = _teamCollectionReference.ref('teams').push();
    String id = newDoc.key.toString();
    final Teams team = Teams.newTeam(id, sport, teamName, bio, status);
    final TeamView teamsView = TeamView.newTeam(id, sport, teamName);
    newDoc.set(team.toJson());
    setManager("me", me.friendId!, teamsView);
    return team;
  }

  getAllTeamsFeed() async {
    return FirebaseDatabase.instance.ref("teams").onValue;
  }

  getSpecificCategoryFeed(String sportName) async {
    return FirebaseDatabase.instance
        .ref("team/sport")
        .equalTo(sportName)
        .onValue;
  }

  Stream<void> getTeamsChatRoom() {
    return FirebaseDatabase.instance
        .ref("teams")
        .orderByChild('playerId')
        .equalTo(me.friendId)
        .onValue;
  }

  setManager(String previousManager, String newManager, TeamView team) async {
    if (previousManager != 'me') {
      await FirebaseDatabase.instance
          .ref('users$previousManager/teams/${team.teamId}')
          .remove();
      await FirebaseDatabase.instance
          .ref('teams/${team.teamId}')
          .update({'manager': newManager});
    }

    await FirebaseDatabase.instance
        .ref('users/$newManager/teams/${team.teamId}')
        .set(team.toJson());
  }

  setCaptain(String newCaptain, String teamId, String nameOfnewCap) async {
    await FirebaseDatabase.instance
        .ref('teams/$teamId')
        .update({'captain': newCaptain});
    CustomMessageServices().captainChangeMessage(teamId, nameOfnewCap);
  }

  addMeInTeam(String teamId) async {
    await FirebaseDatabase.instance.ref('teams/$teamId').update({
      'playerId': [me.friendId],
      'players': [me.toJson()],
    });
    CustomMessageServices().sendTeamNewMemberJoinMessage(
        teamId, Constants.prefs.getString('name') as String);
  }

  removeMeFromTeam(String teamId) async {
    await FirebaseDatabase.instance.ref('teams/$teamId').update({
      'playerId': [me.friendId],
      'players': [me.toJson()],
    });
    CustomMessageServices().sendTeamLeaveMemberMessage(
        teamId, Constants.prefs.getString('name') as String);
  }

  removePlayerFromTeam(
    String teamId,
    String userId,
    String userName,
    String profilePic,
  ) async {
    Friends player = Friends.newFriend(userId, userName, profilePic);
    await FirebaseDatabase.instance.ref('teams/$teamId').update({
      'playerId': [player.friendId],
      'players': [player.toJson()],
    });
    CustomMessageServices().sendTeamLeaveMemberMessage(teamId, userName);
  }

  deleteTeam(String manager, String teamId) async {
    if (manager == Constants.prefs.getString('userId')) {
      await FirebaseDatabase.instance.ref('teams/$teamId').remove();
      await FirebaseDatabase.instance
          .ref('users/$manager/teams/$teamId')
          .remove();
    }
  }

  makeTeamClosed(String teamId) async {
    await FirebaseDatabase.instance.ref('teams/$teamId').update({
      'status': 'closed',
    });
  }

  makeTeamPublic(String teamId) async {
    await FirebaseDatabase.instance.ref('teams/$teamId').update({
      'status': 'public',
    });
  }

  makeTeamPrivate(String teamId) async {
    await FirebaseDatabase.instance.ref('teams/$teamId').update({
      'status': 'private',
    });
  }

  sendVerificationApplication(
      String teamId, String sport, String teamName) async {
    var newDoc =
        FirebaseDatabase.instance.ref('verificationApplications').push();
    String id = newDoc.key.toString();
    final VerificationApplication newApp =
        VerificationApplication.newApplication(teamId, sport, teamName, id);
    newDoc.set(newApp.toJson());

    await FirebaseDatabase.instance
        .ref('teams/$teamId')
        .update({'verified': 'P'});
  }
}
