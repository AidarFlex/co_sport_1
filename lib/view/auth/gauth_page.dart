import 'package:co_sport_map/widget/build_title.dart';
import 'package:co_sport_map/widget/google_o_auth.dart';
import 'package:flutter/material.dart';

class GauthPage extends StatefulWidget {
  const GauthPage({Key? key}) : super(key: key);

  @override
  State<GauthPage> createState() => _GauthPageState();
}

class _GauthPageState extends State<GauthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: buildTitle(context, "Co Sport"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              child: Image(
                image: AssetImage('assets/basketballGuy.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: GoogleOauth(),
            ),
          ],
        ),
      ),
    );
  }
}
