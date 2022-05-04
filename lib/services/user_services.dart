import 'package:co_sport_map/models/user.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:firebase_database/firebase_database.dart';

class UserService {
  final _db = FirebaseDatabase.instance;

  updateEventTokens(int n) {
    _db
        .ref('users/${Constants.prefs.get('userId')}')
        .set({'eventTokens': ServerValue.increment(n)});
  }

  updateTeamsCount(int n) {
    _db
        .ref('users/${Constants.prefs.get('userId')}')
        .update({'teamsCount': ServerValue.increment(n)});
  }

  updateEventCount(int n, String userId) {
    _db
        .ref('users/${Constants.prefs.get('userId')}')
        .update({'eventCount': ServerValue.increment(n)});
  }

  Future<UserProfile> getUserProfile(String id) async {
    var snap = await _db.ref('users/$id').get();
    return UserProfile.fromMap(snap as Map);
  }

  // getFriends() async {
  //   return _db

  // }

  Stream<UserProfile> streamUserProfile(String id) {
    return _db
        .ref('users/$id')
        .onValue
        .map((snap) => UserProfile.fromMap(snap as Map));
  }

  getTeams(String sport) async {
    return _db
        .ref("users/${Constants.prefs.getString('userId')}/teams/sport")
        .equalTo(sport)
        .onValue;
  }

  reportUser(String userId) async {
    _db.ref('report/$userId').set(
        {'reported_by': Constants.prefs.get('userId'), "status": "pending"});
  }
}
