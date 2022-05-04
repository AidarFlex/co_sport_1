import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingServices {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  getTokens() async {
    String? token = await _firebaseMessaging.getToken();
    print(token);
    return token;
  }
}
