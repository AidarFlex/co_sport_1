import 'package:co_sport_map/models/notification.dart';
import 'package:co_sport_map/services/notification_service.dart';
import 'package:co_sport_map/view/profile/other_user_profile.dart';
import 'package:co_sport_map/widget/build_title.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:getwidget/components/loader/gf_loader.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Stream? notification;

  @override
  void initState() {
    super.initState();
    getUserNotifications();
  }

  getUserNotifications() async {
    NotificationServices().getNotification().then(
      (snapshots) {
        setState(
          () {
            notification = snapshots;
          },
        );
      },
    );
  }

  Widget notificationList() {
    return StreamBuilder(
      stream: notification,
      builder: (context, AsyncSnapshot event) {
        if (event.hasData) {
          if (event.data.snapshot.value != null) {
            return ListView.builder(
              itemCount: event.data.snapshot.value.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Map map = event.data.snapshot.value;
                NotificationClass notificationData =
                    NotificationClass.fromJson(map.values.elementAt(index));
                if (notificationData.type == 'challenge') {
                  ChallengeNotification notificationData =
                      ChallengeNotification.fromJson(
                          map.values.elementAt(index));
                  return ChallengeNotificationCard(
                      notificationData: notificationData);
                } else if (notificationData.type == 'inviteTeams') {
                  TeamNotification notificationData =
                      TeamNotification.fromJson(map.values.elementAt(index));
                  return TeamJoinRequestNotificationCard(
                      notificationData: notificationData);
                } else if (notificationData.type == 'event') {
                  EventNotification notificationData =
                      EventNotification.fromJson(map.values.elementAt(index));
                  if (notificationData.subtype == 'individual') {
                    return IndividualEventNotificationCard(
                        notificationData: notificationData);
                  } else {
                    return TeamEventNotificationCard(
                        notificationData: notificationData);
                  }
                }
                return FriendRequestNotificationCard(
                    notificationData: notificationData);
              },
            );
          } else {
            return Center(
              child: Image.asset("assets/notification.png"),
            );
          }
        } else {
          return const Loader();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildTitle(context, "Уведомления"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: <Widget>[
                notificationList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FriendRequestNotificationCard extends StatelessWidget {
  const FriendRequestNotificationCard({
    Key? key,
    required this.notificationData,
  }) : super(key: key);

  final NotificationClass notificationData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtherUserProfile(
                userID: notificationData.senderId!,
              ),
            ),
          );
        },
        child: Card(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: Image(
                              height: 48,
                              width: 48,
                              fit: BoxFit.fitWidth,
                              image: NetworkImage(
                                notificationData.senderProfieImage!,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            notificationData.senderName!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: GestureDetector(
                          onTap: () {
                            NotificationServices().declineRequest(
                                notificationData.notificationId!,
                                notificationData.senderId!);
                          },
                          child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0)),
                                    color: Colors.red[100],
                                  ),
                                  width: 36,
                                  height: 36,
                                ),
                                const Icon(
                                  FeatherIcons.x,
                                  color: Colors.red,
                                  size: 24,
                                ),
                              ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 4.0, bottom: 4, left: 4, right: 8),
                        child: GestureDetector(
                          onTap: () {
                            NotificationServices()
                                .acceptFriendRequest(notificationData);
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
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                child: Row(
                  children: const [
                    Icon(
                      FeatherIcons.info,
                      size: 13.0,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "запрос в друзья",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeamEventNotificationCard extends StatelessWidget {
  const TeamEventNotificationCard({
    Key? key,
    required this.notificationData,
  }) : super(key: key);

  final EventNotification notificationData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notificationData.teamName!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "хочет присоединиться",
                        style: TextStyle(
                          color: Theme.of(context)
                              .backgroundColor
                              .withOpacity(0.45),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        notificationData.eventName!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () async {
                          NotificationServices().declineTeamRequest(
                              notificationData.eventId!,
                              notificationData.notificationId!,
                              notificationData.senderId!);
                        },
                        child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0)),
                                  color: Colors.red[100],
                                ),
                                width: 36,
                                height: 36,
                              ),
                              const Icon(
                                FeatherIcons.x,
                                color: Colors.red,
                                size: 24,
                              ),
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 4.0, bottom: 4, left: 4, right: 8),
                      child: GestureDetector(
                        onTap: () {
                          NotificationServices()
                              .acceptTeamEventNotification(notificationData);
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
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Row(
                children: const [
                  Icon(
                    FeatherIcons.info,
                    size: 13.0,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "запрос на участие в командном мероприятии",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IndividualEventNotificationCard extends StatelessWidget {
  const IndividualEventNotificationCard({
    Key? key,
    required this.notificationData,
  }) : super(key: key);

  final EventNotification notificationData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          child: Image(
                            height: 48,
                            width: 48,
                            fit: BoxFit.fitWidth,
                            image: NetworkImage(
                              notificationData.senderPic!,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notificationData.senderName!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "хочет присоединиться",
                          style: TextStyle(
                            color: Theme.of(context)
                                .backgroundColor
                                .withOpacity(0.45),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          notificationData.eventName!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          NotificationServices()
                              .declineEventNotification(notificationData);
                        },
                        child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0)),
                                  color: Colors.red[100],
                                ),
                                width: 36,
                                height: 36,
                              ),
                              const Icon(
                                FeatherIcons.x,
                                color: Colors.red,
                                size: 24,
                              ),
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 4.0, bottom: 4, left: 4, right: 8),
                      child: GestureDetector(
                        onTap: () {
                          NotificationServices()
                              .acceptIndividualNotification(notificationData);
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
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Row(
                children: const [
                  Icon(
                    FeatherIcons.info,
                    size: 13.0,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "Запрос на участие в индивидуальном мероприятии",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamJoinRequestNotificationCard extends StatelessWidget {
  const TeamJoinRequestNotificationCard({
    Key? key,
    required this.notificationData,
  }) : super(key: key);

  final TeamNotification notificationData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtherUserProfile(
                          userID: notificationData.senderId!,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: Image(
                              height: 48,
                              width: 48,
                              fit: BoxFit.fitWidth,
                              image: NetworkImage(
                                notificationData.senderPic!,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notificationData.senderName!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "присоедениться",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .backgroundColor
                                  .withOpacity(0.45),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            notificationData.teamName!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          NotificationServices()
                              .declineTeamInviteNotification(notificationData);
                        },
                        child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0)),
                                  color: Colors.red[100],
                                ),
                                width: 36,
                                height: 36,
                              ),
                              const Icon(
                                FeatherIcons.x,
                                color: Colors.red,
                                size: 24,
                              ),
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 4.0, bottom: 4, left: 4, right: 8),
                      child: GestureDetector(
                        onTap: () {
                          NotificationServices()
                              .acceptTeamInviteNotification(notificationData);
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
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Row(
                children: const [
                  Icon(
                    FeatherIcons.info,
                    size: 13.0,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "Запрос на присоединение к команде",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChallengeNotificationCard extends StatelessWidget {
  const ChallengeNotificationCard({
    Key? key,
    required this.notificationData,
  }) : super(key: key);

  final ChallengeNotification notificationData;

  @override
  Widget build(BuildContext context) {
    String? sportIcon;
    switch (notificationData.sport) {
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.6,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: Image(
                              height: 48,
                              width: 48,
                              fit: BoxFit.fitWidth,
                              image: AssetImage(sportIcon!),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: Center(
                              child: Text(
                                notificationData.opponentTeamName!,
                                overflow: TextOverflow.fade,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "VS",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .backgroundColor
                                  .withOpacity(0.45),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: Center(
                              child: Text(
                                notificationData.myTeamName!,
                                overflow: TextOverflow.fade,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          NotificationServices().declineNotification(
                              notificationData.notificationId!);
                        },
                        child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0)),
                                  color: Colors.red[100],
                                ),
                                width: 36,
                                height: 36,
                              ),
                              const Icon(
                                FeatherIcons.x,
                                color: Colors.red,
                                size: 24,
                              ),
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 4.0, bottom: 4, left: 4, right: 8),
                      child: GestureDetector(
                        onTap: () {
                          NotificationServices()
                              .acceptChallengeTeamNotification(
                                  notificationData);
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
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Row(
                children: [
                  const Icon(
                    FeatherIcons.info,
                    size: 13.0,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    notificationData.type!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
