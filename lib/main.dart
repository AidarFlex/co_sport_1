import 'package:co_sport_map/utils/contansts.dart';
import 'package:co_sport_map/utils/theme_config.dart';
import 'package:co_sport_map/view/auth/gauth_page.dart';
import 'package:co_sport_map/view/chats/message_page.dart';
import 'package:co_sport_map/view/explore_events/add_post.dart';
import 'package:co_sport_map/view/explore_events/yandex_map.dart';
import 'package:co_sport_map/view/profile/drawer/edit_profile.dart';
import 'package:co_sport_map/view/profile/profile_page.dart';
import 'package:co_sport_map/view/splash/splash.dart';
import 'package:co_sport_map/view/teams/create_teams.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
  String? sportName;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/network': (context) => const MessagePage(),
        '/secondpage': (context) => const GauthPage(),
        '/editprofile': (context) => const EditProfile(),
        '/addpost': (context) => const AddPost(),
        '/createteam': (context) => const CreateTeam(),
        '/profile': (context) => const Profile(),
        '/yandex_map': (context) => const YandexMapWidget(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', 'RU'),
        Locale('en', ''),
      ],
      theme: Provider.of<ThemeNotifier>(context).currentTheme,
      home: const Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}
