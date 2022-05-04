import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co_sport_map/models/friends.dart';
import 'package:co_sport_map/models/teams.dart';
import 'package:co_sport_map/models/verigication_app.dart';
import 'package:co_sport_map/services/custom_message.dart';
import 'package:co_sport_map/utils/contansts.dart';

class TeamService {
  final CollectionReference _teamCollectionReference =
      FirebaseFirestore.instance.collection('teams');

  final Friends me = Friends.newFriend(
      Constants.prefs!.getString('userId') as String,
      Constants.prefs!.getString('name'),
      Constants.prefs!.getString('profileImage'));
  Teams createNewTeam(
      String sport, String teamName, String bio, String status) {
    var newDoc = _teamCollectionReference.doc();
    String id = newDoc.id;
    final Teams team = Teams.newTeam(id, sport, teamName, bio, status);
    final TeamView teamsView = TeamView.newTeam(id, sport, teamName);
    newDoc.set(team.toJson());
    setManager("me", me.friendId!, teamsView);
    return team;
  }

  getAllTeamsFeed() async {
    return FirebaseFirestore.instance.collection("teams").snapshots();
  }

  getSpecificCategoryFeed(String sportName) async {
    return FirebaseFirestore.instance
        .collection("teams")
        .where('sport', isEqualTo: sportName)
        .snapshots();
  }

  getTeamsChatRoom() async {
    return FirebaseFirestore.instance
        .collection("teams")
        .where('playerId', arrayContains: me.friendId)
        .snapshots();
  }

  setManager(String previousManager, String newManager, TeamView team) async {
    if (previousManager != 'me') {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(previousManager)
          .collection('teams')
          .doc(team.teamId)
          .delete();
      await FirebaseFirestore.instance
          .collection('teams')
          .doc(team.teamId)
          .update({'manager': newManager});
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(newManager)
        .collection('teams')
        .doc(team.teamId)
        .set(team.toJson());
  }

  setCaptain(String newCaptain, String teamId, String nameOfnewCap) async {
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(teamId)
        .update({'captain': newCaptain});
    CustomMessageServices().captainChangeMessage(teamId, nameOfnewCap);
  }

  addMeInTeam(String teamId) async {
    await FirebaseFirestore.instance.collection('teams').doc(teamId).update({
      'playerId': FieldValue.arrayUnion([me.friendId]),
      'players': FieldValue.arrayUnion([me.toJson()]),
    });
    CustomMessageServices().sendTeamNewMemberJoinMessage(
        teamId, Constants.prefs!.getString('name') as String);
  }

  removeMeFromTeam(String teamId) async {
    await FirebaseFirestore.instance.collection('teams').doc(teamId).update({
      'playerId': FieldValue.arrayRemove([me.friendId]),
      'players': FieldValue.arrayRemove([me.toJson()]),
    });
    CustomMessageServices().sendTeamLeaveMemberMessage(
        teamId, Constants.prefs!.getString('name') as String);
  }

  removePlayerFromTeam(
    String teamId,
    String userId,
    String userName,
    String profilePic,
  ) async {
    Friends player = Friends.newFriend(userId, userName, profilePic);
    await FirebaseFirestore.instance.collection('teams').doc(teamId).update({
      'playerId': FieldValue.arrayRemove([player.friendId]),
      'players': FieldValue.arrayRemove([player.toJson()]),
    });
    CustomMessageServices().sendTeamLeaveMemberMessage(teamId, userName);
  }

  deleteTeam(String manager, String teamId) async {
    if (manager == Constants.prefs!.getString('userId')) {
      await FirebaseFirestore.instance.collection('teams').doc(teamId).delete();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(manager)
          .collection('teams')
          .doc(teamId)
          .delete();
    }
  }

  makeTeamClosed(String teamId) async {
    await FirebaseFirestore.instance.collection('teams').doc(teamId).update({
      'status': 'closed',
    });
  }

  makeTeamPublic(String teamId) async {
    await FirebaseFirestore.instance.collection('teams').doc(teamId).update({
      'status': 'public',
    });
  }

  makeTeamPrivate(String teamId) async {
    await FirebaseFirestore.instance.collection('teams').doc(teamId).update({
      'status': 'private',
    });
  }

  sendVerificationApplication(
      String teamId, String sport, String teamName) async {
    var newDoc =
        FirebaseFirestore.instance.collection('verificationApplications').doc();
    String id = newDoc.id;
    final VerificationApplication newApp =
        VerificationApplication.newApplication(teamId, sport, teamName, id);
    newDoc.set(newApp.toJson());

    await FirebaseFirestore.instance
        .collection('teams')
        .doc(teamId)
        .update({'verified': 'P'});
  }
}
