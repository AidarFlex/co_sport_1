import 'package:co_sport_map/services/auth.dart';
import 'package:co_sport_map/utils/theme_config.dart';
import 'package:co_sport_map/widget/animations/drower_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import '../../../utils/contansts.dart';

class DrawerBody extends StatefulWidget {
  const DrawerBody({
    Key? key,
  }) : super(key: key);

  @override
  _DrawerBodyState createState() => _DrawerBodyState();
}

class _DrawerBodyState extends State<DrawerBody> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),
              const Text(
                "Привет,",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                Constants.prefs.getString('name')!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        DrawerButton(
          onpressed: () {
            Navigator.pushNamed(context, "/editprofile");
          },
          label: "Редактировать профиль",
          icon: const Icon(
            FeatherIcons.edit,
            color: Colors.white,
          ),
        ),
        // DrawerButton(
        //   onpressed: () {
        //     theme.switchTheme();
        //   },
        //   beta: true,
        //   label:
        //       theme.myTheme == MyTheme.light ? 'Темная тема' : "Светлая тема",
        //   icon: theme.myTheme == MyTheme.light
        //       ? const Icon(
        //           FeatherIcons.sun,
        //           color: Colors.white,
        //         )
        //       : const Icon(FeatherIcons.moon),
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            color: Colors.white54,
            height: 2,
            width: 150,
          ),
        ),
        DrawerButton(
          onpressed: () {
            Constants.prefs.setBool("loggedin", false);
            signOutGoogle();
            Navigator.pushReplacementNamed(context, "/secondpage");
          },
          label: 'Выйти',
          icon: const Icon(
            FeatherIcons.logOut,
            color: Colors.white,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
