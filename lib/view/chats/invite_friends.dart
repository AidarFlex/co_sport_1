import 'package:co_sport_map/models/friends.dart';
import 'package:co_sport_map/models/teams.dart';
import 'package:co_sport_map/services/user_services.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:co_sport_map/widget/build_botton_navigation_bar.dart';
import 'package:co_sport_map/widget/build_title.dart';
import 'package:co_sport_map/widget/button.dart';
import 'package:co_sport_map/widget/loader.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../services/notification_service.dart';

class InviteFriends extends StatefulWidget {
  final Teams team;
  const InviteFriends({required this.team, Key? key}) : super(key: key);
  @override
  _InviteFriendsState createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  // Stream? userFriends;

  // @override
  // void initState() {
  //   super.initState();
  //   getUserFriends();
  // }

  // getUserFriends() async {
  //   UserService().getFriends().then((snapshots) {
  //     setState(() {
  //       userFriends = snapshots;
  //     });
  //   });
  // }

  Widget friends() {
    return StreamBuilder(
      stream: FirebaseDatabase.instance
          .ref('users/${Constants.prefs.getString('userId')}/friends')
          .onValue,
      builder: (context, AsyncSnapshot event) {
        return event.hasData
            ? event.data.snapshot.value != null
                ? ListView.builder(
                    itemCount: event.data.snapshot.value.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Map map = event.data.snapshot.value;
                      Friends data =
                          Friends.fromJson(map.values.elementAt(index));

                      if (widget.team.playerId!.contains(data.friendId)) {
                        return ListTile(
                          leading:
                              Image(image: NetworkImage(data.profileImage!)),
                          title: Text(data.name!),
                          trailing: Button(
                            myText: "Уже в команде",
                            myColor: Theme.of(context).primaryColor,
                            onPressed: () {},
                          ),
                        );
                      } else if (widget.team.notification!.length > 20) {
                        return ListTile(
                          leading:
                              Image(image: NetworkImage(data.profileImage!)),
                          title: Text(data.name!),
                          trailing: Button(
                            myText: "Приглашение отправлено",
                            myColor: Theme.of(context).primaryColor,
                            onPressed: () {},
                          ),
                        );
                      } else if (widget.team.notification!.isNotEmpty &&
                          widget.team.notification!.contains(data.friendId)) {
                        return buttonInviteFriends(
                            data, context, "Приглашение отправлено");
                      } else {
                        return ListTile(
                          leading:
                              Image(image: NetworkImage(data.profileImage!)),
                          title: Text(data.name!),
                          trailing: Button(
                            myText: "Пригласить",
                            myColor: Theme.of(context).primaryColor,
                            onPressed: () {
                              NotificationServices().createTeamNotification(
                                  data.friendId!, data.friendId!, widget.team);
                            },
                          ),
                        );
                      }
                    })
                : Center(
                    child: Image.asset("assets/add-friends.png"),
                  )
            : const Loader();
      },
    );
  }

  ListTile buttonInviteFriends(
      Friends data, BuildContext context, String text) {
    return ListTile(
      leading: Image(image: NetworkImage(data.profileImage!)),
      title: Text(data.name!),
      trailing: Button(
        myText: text,
        myColor: Theme.of(context).primaryColor,
        onPressed: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildTitle(context, "Пригласить друзей"),
        automaticallyImplyLeading: false,
      ),
      body: Column(children: [
        friends(),
        Button(
          myText: 'Выйти',
          myColor: Colors.blue,
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const AnimatedBottomBar()));
          },
        ),
      ]),
    );
  }
}
