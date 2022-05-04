import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co_sport_map/models/user.dart';
import 'package:co_sport_map/utils/contansts.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  updateEventTokens(int n) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(Constants.prefs!.get('userId') as String)
        .set({'eventTokens': FieldValue.increment(n)}, SetOptions(merge: true));
  }

  updateTeamsCount(int n) {
    _db
        .collection('users')
        .doc(Constants.prefs!.get('userId') as String)
        .set({'teamsCount': FieldValue.increment(n)}, SetOptions(merge: true));
  }

  updateEventCount(int n, String userId) {
    _db
        .collection('users')
        .doc(userId)
        .set({'eventCount': FieldValue.increment(n)}, SetOptions(merge: true));
  }

  Future<UserProfile> getUserProfile(String id) async {
    var snap = await _db.collection('users').doc(id).get();
    return UserProfile.fromMap(snap.data as Map);
  }

  getFriends() async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Constants.prefs!.getString('userId'))
        .collection("friends")
        .snapshots();
  }

  Stream<UserProfile> streamUserProfile(String id) {
    return _db
        .collection('users')
        .doc(id)
        .snapshots()
        .map((snap) => UserProfile.fromMap(snap.data as Map));
  }

  getTeams(String sport) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Constants.prefs!.getString('userId'))
        .collection("teams")
        .where('sport', isEqualTo: sport)
        .snapshots();
  }

  reportUser(String userId) async {
    _db.collection('report').doc(userId).set(
        {'reported_by': Constants.prefs?.get('userId'), "status": "pending"});
  }
}
