import 'package:co_sport_map/models/events.dart';
import 'package:co_sport_map/services/event_service.dart';
import 'package:co_sport_map/services/notification_service.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:co_sport_map/utils/theme_config.dart';
import 'package:co_sport_map/view/explore_events/event_info.dart';
import 'package:co_sport_map/view/team_event_notification.dart';
import 'package:co_sport_map/view/teams/team_info.dart';
import 'package:co_sport_map/widget/build_title.dart';
import 'package:co_sport_map/widget/small_button.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExploreEvents extends StatefulWidget {
  const ExploreEvents({Key? key}) : super(key: key);

  @override
  _ExploreEventsState createState() => _ExploreEventsState();
}

class _ExploreEventsState extends State<ExploreEvents> {
  Stream? currentFeed;
  @override
  void initState() {
    super.initState();
    getUserInfoEvents();
  }

  SimpleDialog successDialog(BuildContext context) {
    return SimpleDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      children: [
        Center(
            child: Text("Вы были добавлены",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4)),
        Image.asset("assets/confirmation-illustration.png")
      ],
    );
  }

  SimpleDialog infoDialog2(BuildContext context) {
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
          Center(child: Text("Этот мероприятие заполнено!")),
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
                  "В настоящее время мероприятие заполнено, пожалуйста, повторите попытку позже.",
                  style: Theme.of(context).textTheme.subtitle1)),
        ),
      ],
    );
  }

  getUserInfoEvents() async {
    EventService().getCurrentFeed().then((snapshots) {
      setState(() {
        currentFeed = snapshots;
      });
    });
  }

  Widget feed({ThemeNotifier? theme}) {
    return StreamBuilder(
      stream: currentFeed,
      builder: (context, AsyncSnapshot asyncSnapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          child: asyncSnapshot.hasData
              ? asyncSnapshot.data.docs.length > 0
                  ? ListView.builder(
                      itemCount: asyncSnapshot.data.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Events data =
                            Events.fromJson(asyncSnapshot.data.docs[index]);
                        String sportIcon = 'Volleyball';
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
                        bool registrationCondition = data.playersId!
                            .contains(Constants.prefs!.getString('userId'));
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 4.0),
                          child: Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: GestureDetector(
                                onLongPress: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return EventInfo(
                                          eventId: data.eventId!,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: ExpansionTileCard(
                                  initiallyExpanded: false,
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Image(
                                              image: AssetImage(sportIcon),
                                              width: 70,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data.eventName!,
                                                  style: TextStyle(
                                                    color: theme!.currentTheme
                                                        .backgroundColor,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      FeatherIcons.clock,
                                                      size: 14.0,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      DateFormat('MMM dd -')
                                                          .add_jm()
                                                          .format(
                                                              data.dateTime!)
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      FeatherIcons.mapPin,
                                                      size: 14.0,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    SizedBox(
                                                      width: 100,
                                                      child: Text(
                                                        data.location!,
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .visible,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            Stack(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              children: [
                                                Text(
                                                  (data.playersId!.length
                                                          .toString() +
                                                      "/" +
                                                      data.maxMembers
                                                          .toString()),
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                CircularProgressIndicator(
                                                  value:
                                                      data.playersId!.length /
                                                          data.maxMembers!,
                                                  backgroundColor: theme
                                                      .currentTheme
                                                      .backgroundColor
                                                      .withOpacity(0.15),
                                                  strokeWidth: 7,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              data.type == 1
                                                  ? FeatherIcons.globe
                                                  : FeatherIcons.lock,
                                              size: 18,
                                              color: data.type == 1
                                                  ? Colors.green[400]
                                                  : Colors.red[400],
                                            ),
                                            Text(
                                              data.type == 1
                                                  ? "Открытая"
                                                  : "Закрытая",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: data.type == 1
                                                    ? Colors.green[400]
                                                    : Colors.red[400],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "Описание",
                                        style: TextStyle(
                                          color: theme
                                              .currentTheme.backgroundColor
                                              .withOpacity(0.45),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      Text(data.description!.trim()),
                                      const SizedBox(height: 4),
                                    ],
                                  ),
                                  title: const Text(''),
                                  children: [
                                    data.notification!.contains(Constants.prefs!
                                            .getString('userId'))
                                        ? SmallButton(
                                            myColor:
                                                Theme.of(context).primaryColor,
                                            myText: "Отправленное уведомление")
                                        : SmallButton(
                                            myColor: !registrationCondition
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context)
                                                    .primaryColorDark,
                                            myText: !registrationCondition
                                                ? data.type == 1
                                                    ? "Присоединиться"
                                                    : "Отправить запрос"
                                                : "Уже зарегистрирован",
                                            onPressed: () async {
                                              if (!registrationCondition) {
                                                if (data.type == 2) {
                                                  if (data.status == 'team') {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              TeamEventNotification(
                                                                  data: data)),
                                                    );
                                                  } else {
                                                    if (!data.notification!
                                                        .contains(Constants
                                                            .prefs!
                                                            .getString(
                                                                'userId'))) {
                                                      NotificationServices()
                                                          .createIndividualNotification(
                                                              data);
                                                    }
                                                    if (data.notification!
                                                        .contains(Constants
                                                            .prefs!
                                                            .getString(
                                                                'userId'))) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return notifcationPending(
                                                              context);
                                                        },
                                                      );
                                                    }
                                                  }
                                                } else {
                                                  if (data.status == 'team') {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              TeamEventNotification(
                                                                  data: data)),
                                                    );
                                                  } else {
                                                    if (await Events()
                                                        .checkingAvailability(
                                                            data.eventId!)) {
                                                      registerUserToEvent(
                                                        data.eventId!,
                                                        data.eventName!,
                                                        data.sportName!,
                                                        data.location!,
                                                        data.dateTime!,
                                                        data.creatorId!,
                                                        data.creatorName!,
                                                        data.status!,
                                                        data.type!,
                                                        data.playersId!,
                                                      );
                                                      EventService()
                                                          .addUserToEvent(
                                                              data.eventId!);
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return successDialog(
                                                                context);
                                                          });
                                                    } else {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return infoDialog2(
                                                                context);
                                                          });
                                                    }
                                                  }
                                                }
                                              } else {}
                                            },
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const ExploreEventEmptyState()
              : const Loader(),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: buildTitle(context, "Эвенты"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          BodyHeader(
            theme: theme,
            text: '',
          ),
          Expanded(
            child: Stack(
              children: [
                feed(theme: theme),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/addpost");
        },
        child: const Icon(
          FeatherIcons.plus,
          size: 32,
        ),
      ),
    );
  }
}

class ExploreEventEmptyState extends StatelessWidget {
  const ExploreEventEmptyState({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Center(
          child: SizedBox(
              width: 200,
              child: Image.asset("assets/post_online.png", width: 300)),
        ),
        Text(
          "Нет ни отдного эвента, создайте их",
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }
}

class BodyHeader extends StatelessWidget {
  final ThemeNotifier theme;
  final String text;

  const BodyHeader({
    Key? key,
    required this.theme,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
      child: Text(
        text,
        style: TextStyle(
          color: theme.currentTheme.backgroundColor.withOpacity(0.35),
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
