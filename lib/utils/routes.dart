import 'package:co_sport_map/widget/animations/fade_page_route.dart';
import 'package:flutter/material.dart';

class CRouter {
  static Future<Widget> pushPage(BuildContext context, Widget page) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );
  }

  static pushPageDialog(BuildContext context, Widget page) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
        fullscreenDialog: true,
      ),
    );
  }

  static pushPageReplacement(BuildContext context, Widget page) async {
    return await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );
  }

  static pushPageWithFadeAnimation(BuildContext context, Widget page) async {
    return await Navigator.pushReplacement(
      context,
      FadePageRoute(
        page,
      ),
    );
  }
}
