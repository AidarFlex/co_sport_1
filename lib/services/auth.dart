import 'package:co_sport_map/models/user.dart';
import 'package:co_sport_map/services/firebase_messaging.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final _realtimeDatabase = FirebaseDatabase.instance;
final YandexGeocoder geo =
    YandexGeocoder(apiKey: 'eb567e1a-9ffd-4118-9401-d7e955c93d38');

Future<void> signInWithGoogle() async {
  await Firebase.initializeApp();
  await Geolocator.requestPermission();
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
    var result = await _realtimeDatabase.ref('users/${user.uid}').get();
    if (!result.exists) {
      Constants.prefs.setString("userId", user.uid);
      Constants.prefs.setString("profileImage", user.photoURL!);
      Constants.prefs.setString("name", user.displayName!);
      Constants.prefs.setString("token", token);
      String _username = generateusername(user.email!);
      final Position _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          forceAndroidLocationManager: false);
      final GeocodeResponse _location = await geo.getGeocode(
        GeocodeRequest(
          geocode: PointGeocode(
              latitude: _currentPosition.latitude,
              longitude: _currentPosition.longitude),
          lang: Lang.ru,
        ),
      );
      String lat = _currentPosition.latitude.toString();
      String long = _currentPosition.longitude.toString();
      String? location = _location.firstAddress!.formatted;
      _realtimeDatabase.ref('users/${user.uid}').set(UserProfile.newuser(
              user.uid,
              _username,
              user.displayName,
              user.photoURL,
              user.email,
              token,
              lat,
              long,
              location)
          .toJson());
    } else {
      if (Constants.prefs.get('userId') != user.uid) {
        await FirebaseDatabase.instance.ref('users/${user.uid}').update({
          'userDeviceToken': [token],
        });
        Constants.prefs.setString("userId", user.uid);
        Constants.prefs.setString("profileImage", user.photoURL!);
        Constants.prefs.setString("name", user.displayName!);
        Constants.prefs.setString("token", token);
        Constants.prefs.setString('phoneNumber', user.phoneNumber!);
      }
    }
  }
}

Future<void> signOutGoogle() async {
  FirebaseDatabase.instance
      .ref('users/${Constants.prefs.getString("userId").toString()}')
      .update({
    'userDeviceToken': null,
  }).then((_) async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
  });
  Constants.prefs.setString('token', null.toString());
  Constants.prefs.setString('userId', null.toString());
}
