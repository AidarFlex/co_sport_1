import 'package:co_sport_map/models/events.dart';
import 'package:co_sport_map/services/event_service.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:co_sport_map/utils/theme_config.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../widget/loader.dart';
import '../../widget/small_button.dart';

class Schedule extends StatefulWidget {
  const Schedule({
    Key? key,
  }) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  Stream? currentFeed;
  @override
  void initState() {
    getUserInfoEvents();
    super.initState();
  }

  getUserInfoEvents() async {
    setState(() {
      currentFeed = FirebaseDatabase.instance
          .ref("users/${Constants.prefs.get('userId')}/userEvent")
          .orderByChild('dateTime')
          .onValue;
    });
  }

  Widget feed() {
    return StreamBuilder(
      stream: currentFeed,
      builder: (context, AsyncSnapshot event) {
        final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
        return event.hasData
            ? event.data.snapshot.value != null
                ? ListView.builder(
                    itemCount: event.data.snapshot.value.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Map map = event.data.snapshot.value;
                      Events data =
                          Events.fromMiniJson(map.values.elementAt(index));
                      late String sportIcon;
                      switch (data.sportName) {
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
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    tilePadding: const EdgeInsets.all(0),
                                    maintainState: true,
                                    onExpansionChanged: (expanded) {
                                      if (expanded) {
                                      } else {}
                                    },
                                    children: [
                                      SmallButton(
                                        myColor: const Color(0xffEB4758),
                                        myText: Constants.prefs.get('userId') !=
                                                data.creatorId
                                            ? "Leave"
                                            : "Delete",
                                        onPressed: () {
                                          if (Constants.prefs.get('userId') ==
                                              data.creatorId) {
                                            confirmationPopupForDeleting(
                                                context, data);
                                          } else {
                                            confirmationPopupForLeaving(
                                                context, data);
                                          }
                                        },
                                      ),
                                    ],
                                    title: Text(
                                      data.eventName!,
                                      style: TextStyle(
                                        color:
                                            theme.currentTheme.backgroundColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat('MMM dd -')
                                              .add_jm()
                                              .format(data.dateTime!)
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              FeatherIcons.mapPin,
                                              size: 16.0,
                                            ),
                                            Text(
                                              data.location!,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: theme.currentTheme
                                                    .backgroundColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    leading: Image.asset(sportIcon),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Image.asset("assets/events.png", height: 200),
                  )
            : const Loader();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 5,
      child: Stack(
        children: [feed()],
      ),
    );
  }
}

confirmationPopupForDeleting(BuildContext context, Events data) {
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
      title: "Удалить эвент",
      desc: "Вы хотите удалить этот эвент" + data.eventName!,
      buttons: [
        DialogButton(
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Cancel",
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
            if (data.type! < 4) {
              deleteEvent(data.eventId);
            } else {
              List<dynamic> playerId = data.playersId!;
              for (int i = 0; i < playerId.length; i++) {
                deleteIndividualUserMini(data.eventId!, playerId[i]);
              }
            }
            Navigator.pop(context);
          },
          color: const Color.fromRGBO(128, 128, 128, 0),
        )
      ]).show();
}

confirmationPopupForLeaving(BuildContext context, Events data) {
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
      title: "Выйти из эвента",
      desc: "Вы хоите покинуть этот эвент " + data.eventName!,
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
              "Выйти",
              style: TextStyle(
                color: Colors.redAccent[400],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            if (data.type! < 4) {
              leaveEvent(data);
            } else {
              deleteIndividualUserMini(
                  data.eventId!, Constants.prefs.getString('userId') as String);
            }
            Navigator.pop(context);
          },
          color: const Color.fromRGBO(128, 128, 128, 0),
        )
      ]).show();
}
