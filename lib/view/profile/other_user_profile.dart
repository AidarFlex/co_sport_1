import 'dart:async';

import 'package:co_sport_map/services/frinds_services.dart';
import 'package:co_sport_map/services/notification_service.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:co_sport_map/widget/build_title.dart';
import 'package:co_sport_map/widget/button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OtherUserProfile extends StatefulWidget {
  final String userID;
  const OtherUserProfile({
    required this.userID,
    Key? key,
  }) : super(key: key);

  @override
  _OtherUserProfileState createState() => _OtherUserProfileState();
  static _OtherUserProfileState? of(BuildContext context) =>
      context.findAncestorStateOfType<_OtherUserProfileState>();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  final db = FirebaseDatabase.instance;
  late StreamSubscription sub;
  Map data = <dynamic, dynamic>{};
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    sub = db.ref('users/${widget.userID}').onValue.listen((snap) {
      setState(() {
        data = snap as Map;
        _loading = true;
      });
    });
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _loading ? buildTitle(context, data["username"]) : null,
        leading: const BackButton(),
      ),
      body: OtherProfileBody(userID: widget.userID),
    );
  }
}

class OtherProfileBody extends StatefulWidget {
  final String userID;
  const OtherProfileBody({
    required this.userID,
    Key? key,
  }) : super(key: key);

  @override
  _OtherProfileBodyState createState() => _OtherProfileBodyState();
}

class _OtherProfileBodyState extends State<OtherProfileBody> {
  @override
  Widget build(BuildContext context) {
    if (OtherUserProfile?.of(context)!._loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: UserProfile(data: OtherUserProfile.of(context)!.data),
            ),
          ],
        ),
      );
    } else {
      return const Loader();
    }
  }
}

class UserProfile extends StatelessWidget {
  final Map data;
  const UserProfile({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? _id = Constants.prefs.getString('userId') as String;
    return Column(
      children: [
        if (data['profileImage'] != null)
          Container(
            width: 115,
            height: 115,
            clipBehavior: Clip.antiAlias,
            child: Hero(
              tag: "image",
              child: Image(
                image: NetworkImage(data['profileImage']),
                fit: BoxFit.fitWidth,
              ),
            ),
            margin: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x0800d2ff),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
          ),
        //Name
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Hero(
            tag: "name",
            child: Text(
              data['name'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        //Bio
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8.0,
            left: 32.0,
            right: 32.0,
          ),
          child: Center(
            child: Text(
              data['bio'],
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        // button
        if (data['friends'].contains(_id) && data['userId'] != _id)
          // remove friend btn
          Button(
            myColor: Colors.redAccent[400]!,
            myText: "Remove Friend",
            onPressed: () {
              confirmationPopup(context, data['name'], data['userId'], _id);
            },
          ),
        Button(
          myColor: Theme.of(context).primaryColor,
          myText: "Добавить в друзья",
          onPressed: () {
            NotificationServices().createRequest(data['userId']);
          },
        ),
        Card(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      data['eventCount'].toString(),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    const Text(
                      "Эвенты",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      data['friendCount'].toString(),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    const Text(
                      "Друзья",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (data["age"] != "")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.cake_outlined,
                            size: 24.0,
                          ),
                        ),
                      ),
                      Text(
                        data["age"],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(
                          FeatherIcons.mail,
                          size: 24.0,
                        ),
                      ),
                    ),
                    Text(
                      data["emailId"],
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                if (data['phoneNumber']['show'])
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(
                            FeatherIcons.phone,
                            size: 24.0,
                          ),
                        ),
                      ),
                      Text(
                        data['phoneNumber']['ph'],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                if (data["location"] != "")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(
                            FeatherIcons.mapPin,
                            size: 24.0,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          data["location"],
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

confirmationPopup(BuildContext context, String name, String id1, String id2) {
  var alertStyle = AlertStyle(
    animationType: AnimationType.fromBottom,
    isCloseButton: false,
    isOverlayTapDismiss: true,
    titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    descStyle: TextStyle(
        fontWeight: FontWeight.w500, fontSize: 18, color: Colors.grey[600]),
    alertAlignment: Alignment.center,
    animationDuration: const Duration(milliseconds: 400),
  );

  Alert(
      context: context,
      style: alertStyle,
      title: "Удалить из друзей",
      desc: "Вы уверены, что хотите удалить " + name + " из друзей",
      buttons: [
        DialogButton(
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Назад",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          color: const Color.fromRGBO(128, 128, 128, 0),
        ),
        DialogButton(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Удалить",
              style: TextStyle(
                color: Colors.redAccent[400],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            FriendServices().removeFriend(id1, id2);
            Navigator.pop(context);
          },
          color: const Color.fromRGBO(128, 128, 128, 0),
        )
      ]).show();
}
