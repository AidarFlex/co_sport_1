import 'package:co_sport_map/utils/contansts.dart';
import 'package:firebase_database/firebase_database.dart';

class FriendServices {
  final _db = FirebaseDatabase.instance;
  updateMyFriendCount(int n) {
    _db
        .ref('users?${Constants.prefs.get('userId')}')
        .update({'friendCount': ServerValue.increment(n)});
  }

  addUpdateMyFriendCount(int n, String id, String currUser) {
    _db.ref('users/$currUser').update({
      'friendCount': ServerValue.increment(n),
      'friends': [id]
    });
  }

  removeFriend(String id, String currUser) {
    _db.ref('users/$id/friends/$currUser').remove();
    _db.ref('users/$currUser/friends/$id').remove();

    _db.ref('users/$currUser').update({
      'friendCount': ServerValue.increment(-1),
      'friends': [id]
    });

    _db.ref('users/$id').update({
      'friendCount': ServerValue.increment(-1),
      'friends': [currUser]
    });
  }

  updateFriendCount(String uid, int n) {
    _db.ref('users/$uid').update({'friendCount': ServerValue.increment(n)});
  }
}
