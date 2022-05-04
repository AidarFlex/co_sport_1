import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co_sport_map/models/user.dart';
import 'package:co_sport_map/services/firebase_messaging.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future signInWithGoogle() async {
  await Firebase.initializeApp();
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
  final String token = await FirebaseMessagingServices().getTokens();
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User? user = authResult.user;

  if (user != null) {
    print('User is not null');
    //The user has authenticated already
    var result = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!result.exists) {
      //Creating a documnet
      Constants.prefs!.setString("userId", user.uid);
      Constants.prefs!.setString("profileImage", user.photoURL!);
      Constants.prefs!.setString("name", user.displayName!);
      Constants.prefs!.setString("token", token);
      print('User Signed Up');
      String _username = generateusername(user.email!);
      //Writing to the backend and making a document for the user
      FirebaseFirestore.instance.collection('users').doc(user.uid).set(
          UserProfile.newuser(user.uid, _username, user.displayName,
                  user.photoURL, user.email, token)
              .toJson());
    } else {
      //Document already exists
      print('I am Here');
      if (Constants.prefs!.get('userId') != user.uid) {
        print('Reached');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'userDeviceToken': FieldValue.arrayUnion([token]),
        });
        Constants.prefs!.setString('userId', user.uid);
        Constants.prefs!.setString("name", user.displayName!);
        Constants.prefs!.setString("profileImage", user.photoURL!);
        Constants.prefs!.setString("token", token);
      }
    }
  }
}

Future<void> signOutGoogle() async {
  //Removing the device token, since the user is logging out
  print(Constants.prefs!.getString("token"));
  FirebaseFirestore.instance
      .collection('users')
      .doc(Constants.prefs!.getString("userId"))
      .update({
    'userDeviceToken':
        FieldValue.arrayRemove([Constants.prefs!.getString("token")]),
  }).then((_) async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
  });
  print(Constants.prefs!.getString("token"));
  print(Constants.prefs!.getString("userId"));
  Constants.prefs!.setString('token', '');
  Constants.prefs!.setString('userId', '');
  print("User Signed Out");
}
