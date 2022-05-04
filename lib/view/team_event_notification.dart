import 'package:co_sport_map/models/events.dart';
import 'package:co_sport_map/models/teams.dart';
import 'package:co_sport_map/services/event_service.dart';
import 'package:co_sport_map/services/notification_service.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:co_sport_map/view/teams/create_teams.dart';
import 'package:co_sport_map/widget/build_botton_navigation_bar.dart';
import 'package:co_sport_map/widget/build_title.dart';
import 'package:co_sport_map/widget/button.dart';
import 'package:co_sport_map/widget/loader.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class TeamEventNotification extends StatefulWidget {
  final Events data;
  const TeamEventNotification({
    Key? key,
    required this.data,
  }) : super(key: key);
  @override
  _TeamEventNotificationState createState() => _TeamEventNotificationState();
}

class _TeamEventNotificationState extends State<TeamEventNotification> {
  Stream? currentTeams;
  @override
  void initState() {
    super.initState();
    getUserManagingTeams(widget.data.sportName!);
  }

  getUserManagingTeams(String sport) async {
    setState(() {
      currentTeams = FirebaseDatabase.instance
          .ref("users/${Constants.prefs.getString('userId')}/teams")
          .orderByChild(sport)
          .onValue;
    });
  }

  Widget feed() {
    return StreamBuilder(
        stream: currentTeams,
        builder: (context, AsyncSnapshot event) {
          return event.hasData
              ? event.data.snapshot.value != null
                  ? ListView.builder(
                      itemCount: event.data.snapshot.value.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Map map = event.data.snapshot.value;
                        TeamView data =
                            TeamView.fromJson(map.values.elementAt(index));
                        late String sportIcon;
                        switch (widget.data.sportName) {
                          case "Volleyball":
                            sportIcon = "assets/icons8-volleyball-96.png";
                            break;
                          case "Basketball":
                            sportIcon = "assets/icons8-basketball-96.png";
                            break;
                          case "Cricket":
                            sportIcon = "assets/icons8-cricket-96.png";
                            break;
                          case "Football":
                            sportIcon = "assets/icons8-soccer-ball-96.png";
                            break;
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Card(
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              leading: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image(
                                  image: AssetImage(sportIcon),
                                  width: 70,
                                ),
                              ),
                              title: Text(
                                data.teamName!,
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.only(
                                    top: 4.0, bottom: 4, left: 4, right: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    if (widget.data.type == 2) {
                                      NotificationServices()
                                          .teamEventNotification(
                                              widget.data, data)
                                          .then(Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AnimatedBottomBar())));
                                    } else {
                                      addTeamToEvent(widget.data, data);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AnimatedBottomBar()));
                                    }
                                  },
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8.0)),
                                          color: Colors.green[100],
                                        ),
                                        width: 36,
                                        height: 36,
                                      ),
                                      const Icon(
                                        FeatherIcons.check,
                                        color: Colors.green,
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            "assets/notification.png",
                            scale: 1.5,
                          ),
                          const Text(
                            "Dont have a team 😓",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Button(
                            myText: 'Create one',
                            myColor: Theme.of(context).primaryColor,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const CreateTeam();
                                  },
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    )
              : const Loader();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildTitle(context, "Select a team"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
            child: Text(
              'Teams You Manage',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                feed(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
