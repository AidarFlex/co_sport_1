import 'package:co_sport_map/utils/contansts.dart';
import 'package:co_sport_map/utils/theme_config.dart';
import 'package:co_sport_map/view/auth/gauth_page.dart';
import 'package:co_sport_map/view/chats/message_page.dart';
import 'package:co_sport_map/view/explore_events/add_post.dart';
import 'package:co_sport_map/view/profile/drawer/edit_profile.dart';
import 'package:co_sport_map/view/profile/profile_page.dart';
import 'package:co_sport_map/view/splash/splash.dart';
import 'package:co_sport_map/view/teams/create_teams.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Constants.prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeNotifier(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // static const MethodChannel _channel =
  //     MethodChannel('testing.com/channel_test');

  // Map<String, String> channelMap = {
  //   "id": "Notifications",
  //   "name": "Show Notifications",
  //   "description": "All Notifications",
  // };
  // Map<String, String> chatchannelMap = {
  //   "id": "Chat",
  //   "name": "Chat Notifications",
  //   "description": "Chat Notifications"
  // };
  // void _createNewChannel() async {
  //   try {
  //     await _channel.invokeMethod('createNotificationChannel', channelMap);
  //     await _channel.invokeMethod('createNotificationChannel', chatchannelMap);
  //     setState(() {});
  //   } on PlatformException catch (e) {
  //     print(e.toString());
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _createNewChannel();
  // }

  @override
  Widget build(BuildContext context) {
    return ConnectivityAppWrapper(
      app: MaterialApp(
        title: 'Flutter Demo',
        routes: {
          '/network': (context) => const MessagePage(),
          '/secondpage': (context) => const GauthPage(),
          '/editprofile': (context) => const EditProfile(),
          '/addpost': (context) => const AddPost(),
          '/createteam': (context) => const CreateTeam(),
          '/profile': (context) => const Profile(),
        },
        theme: Provider.of<ThemeNotifier>(context).currentTheme,
        home: const Splash(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
