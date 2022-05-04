import 'package:co_sport_map/services/auth.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:co_sport_map/widget/build_botton_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class GoogleOauth extends StatefulWidget {
  const GoogleOauth({
    Key? key,
  }) : super(key: key);

  @override
  _GoogleOauthState createState() => _GoogleOauthState();
}

class _GoogleOauthState extends State<GoogleOauth> {
  bool state = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlineButton(
          color: Colors.white,
          onPressed: () async {
            setState(() => state = true);
            await signInWithGoogle().catchError((err) {
              setState(() => state = false);
              print('there is an error while authenticationg: ');
              print(err);
              showDialog(
                context: context,
                builder: (context) {
                  return authError(context);
                },
              );
            }).then((_) {
              if (Constants.prefs!.getString('userId') != null) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AnimatedBottomBar()));
              }
            });
          },
          borderSide: BorderSide(
              color: Theme.of(context).backgroundColor.withOpacity(0.7),
              width: 2.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (state == false)
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
                    child: Image(
                        image: AssetImage('assets/googleicon.png'), width: 24),
                  ),
                if (state == false)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Войти при помощи Google",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                if (state)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Loader(),
                  )
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ],
    );
  }
}

SimpleDialog authError(BuildContext context) {
  return SimpleDialog(
    title: Column(
      children: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
              child: Icon(
            FeatherIcons.info,
            size: 64,
          )),
        ),
        Center(child: Text("Error during authentication")),
      ],
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Text(
                "There was an error which occured during authentication. Please try again",
                style: Theme.of(context).textTheme.subtitle1)),
      ),
    ],
  );
}
