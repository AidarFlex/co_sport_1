import 'dart:async';
import 'package:co_sport_map/models/teams.dart';
import 'package:co_sport_map/services/notification_service.dart';
import 'package:co_sport_map/services/team_services.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:co_sport_map/view/profile/other_user_profile.dart';
import 'package:co_sport_map/view/teams/challenge_screen.dart';
import 'package:co_sport_map/widget/build_botton_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../widget/build_title.dart';

class TeamInfo extends StatefulWidget {
  final String teamID;

  const TeamInfo({required this.teamID, Key? key}) : super(key: key);
  @override
  _TeamInfoState createState() => _TeamInfoState();
}

class _TeamInfoState extends State<TeamInfo> {
  StreamSubscription? sub;
  Map data = <String, dynamic>{};
  bool _loading = false;
  String? sportIcon;

  @override
  void initState() {
    super.initState();
    sub = FirebaseDatabase.instance
        .ref('teams/${widget.teamID}')
        .onValue
        .listen((snap) {
      setState(() {
        data = snap.snapshot.value as Map<dynamic, dynamic>;
        _loading = true;
      });
    });
  }

  @override
  void dispose() {
    sub!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      switch (data['sport']) {
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
    }
    void handleClick(String value) {
      switch (value) {
        case 'Покинуть команду':
          TeamService().removeMeFromTeam(widget.teamID);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AnimatedBottomBar()));
          break;
        case 'Send Verification Application':
          confirmationPopup(
              context, data['teamId'], data['sport'], data['teamname']);
          break;
        case 'Удалить команду':
          confirmationPopup2(context, data['teamId'], data['manager']);
          break;
        case 'Присоединиться к команде':
          if (data['notificationPlayers']
              .contains(Constants.prefs.getString('userId'))) {
            showDialog(
              context: context,
              builder: (context) {
                return notifcationPending(context);
              },
            );
          } else {
            if (data['status'] == 'private') {
              Teams teamView = Teams.newTeam(data['teamId'], data['sport'],
                  data['teamName'], data['bio'], data['status']);
              NotificationServices().createTeamNotification(
                  Constants.prefs.getString('userId') as String,
                  data['manager'],
                  teamView);
            }
            if (data['status'] == 'closed' || data['playerId'].length >= 20) {
              showDialog(
                context: context,
                builder: (context) {
                  return closedTeam(context);
                },
              );
            }
            if (data['status'] == 'public') {
              TeamService().addMeInTeam(data['teamId']);
              showDialog(
                context: context,
                builder: (context) {
                  return teamJoinSuccessDialog(context, data['teamname']);
                },
              );
            }
          }
          break;
        case 'Вызов':
          final TeamChallengeNotification teamData =
              TeamChallengeNotification.newTeam(
                  data['teamId'], data['manager'], data['teamName']);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChallangeTeam(
                    sportName: data['sport'], teamData: teamData)),
          );
          break;
        case 'Make team closed':
          closingATeam(context, data['teamId']);
          break;
        case 'Make team public':
          publicisingATeam(context, data['teamId']);
          break;
        case 'Make team private':
          privatizingATeam(context, data['teamId']);
          break;
      }
    }

    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: buildTitle(
            context,
            data['teamName'],
          ),
          leading: const BackButton(),
          actions: [
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                if (!data['playerId']
                    .contains(Constants.prefs.getString('userId'))) {
                  return {'Присоединиться к команде', 'Вызов'}
                      .map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                } else {
                  if (data['status'] == 'closed') {
                    return Constants.prefs.getString('userId') ==
                            data['manager']
                        ? data["verified"] == 'N'
                            ? {
                                'Удалить команду',
                                'Сделать команду общедоступной',
                                'Сделайте команду приватной'
                              }.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList()
                            : {
                                'Удалить команду',
                              }.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList()
                        : {'Покинуть команду'}.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                  } else {
                    return Constants.prefs.getString('userId') ==
                            data['manager']
                        ? data["verified"] == 'N'
                            ? {
                                'Удалить команду',
                                'Сделать команду закрытой',
                                data['status'] == 'public'
                                    ? 'Открыть комадну'
                                    : 'Закрыть команду'
                              }.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList()
                            : {'Удалить команду', 'Сделать команду закрытой'}
                                .map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList()
                        : {'Покинуть команду'}.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                  }
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 115,
                  height: 115,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                    image: DecorationImage(
                      image: AssetImage(sportIcon!),
                      fit: BoxFit.fitWidth,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0800d2ff),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            data['bio'],
                            style: const TextStyle(fontSize: 20),
                            overflow: TextOverflow.fade,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                data["status"] == "public"
                                    ? FeatherIcons.globe
                                    : FeatherIcons.lock,
                                size: 20,
                                color: data["status"] == "public"
                                    ? Colors.green[400]
                                    : Colors.red[400],
                              ),
                            ),
                            Text(
                              data["status"] == "public"
                                  ? "Открытая"
                                  : "Закрытая",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: data["status"] == "public"
                                    ? Colors.green[400]
                                    : Colors.red[400],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (data["verified"] == 'Y')
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Image(
                                  image: AssetImage("assets/verified.png"),
                                ),
                              ),
                              Text(
                                "Проверенный",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: Stack(
                      children: [
                        ListView.builder(
                          itemCount: data["playerId"].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: Card(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OtherUserProfile(
                                          userID: data["player"][index]
                                              ["friendId"],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          leading: SizedBox(
                                            height: 48,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              child: FadeInImage(
                                                placeholder: const AssetImage(
                                                    "assets/ProfilePlaceholder.png"),
                                                image: NetworkImage(
                                                  data["player"][index]
                                                      ["profileImage"],
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            data["player"][index]["name"],
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          subtitle: Row(
                                            children: [
                                              if (data["player"][index]["id"] ==
                                                  data["manager"])
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  8)),
                                                    ),
                                                    child: const Text(
                                                      "Админ",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                              if (data["player"][index]["id"] ==
                                                  data["captain"])
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  8)),
                                                    ),
                                                    child: const Text(
                                                      "Капитан",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          trailing: Constants.prefs
                                                      .getString('userId') ==
                                                  data['manager']
                                              ? (data["player"][index]["id"] !=
                                                      data["manager"])
                                                  ? PopupMenuButton(
                                                      icon: const Icon(
                                                          Icons.more_vert),
                                                      itemBuilder: (_) =>
                                                          data["player"][
                                                                          index]
                                                                      ["id"] !=
                                                                  data[
                                                                      "captain"]
                                                              ? <
                                                                  PopupMenuItem<
                                                                      String>>[
                                                                  const PopupMenuItem<
                                                                          String>(
                                                                      child: Text(
                                                                          'Сделать капитаном'),
                                                                      value:
                                                                          'Transfer captainship'),
                                                                  const PopupMenuItem<
                                                                          String>(
                                                                      child: Text(
                                                                          'Удалить участника'),
                                                                      value:
                                                                          'Remove member'),
                                                                ]
                                                              : <
                                                                  PopupMenuItem<
                                                                      String>>[
                                                                  const PopupMenuItem<
                                                                          String>(
                                                                      child: Text(
                                                                          'Удалить участника'),
                                                                      value:
                                                                          'Remove member'),
                                                                ],
                                                      onSelected:
                                                          (theChosenOne) {
                                                        switch (theChosenOne) {
                                                          case 'Transfer captainship':
                                                            TeamService().setCaptain(
                                                                data["player"]
                                                                        [index]
                                                                    ["id"],
                                                                data['teamId'],
                                                                data["player"]
                                                                        [index]
                                                                    ["name"]);
                                                            break;
                                                          case 'Remove member':
                                                            TeamService().removePlayerFromTeam(
                                                                data['teamId'],
                                                                data["player"]
                                                                        [index]
                                                                    ['id'],
                                                                data["player"]
                                                                        [index]
                                                                    ['name'],
                                                                data["player"]
                                                                        [index][
                                                                    'profileImage']);
                                                            break;
                                                        }
                                                      },
                                                    )
                                                  : null
                                              : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return const Loader();
    }
  }
}

confirmationPopup2(BuildContext context, String teamId, String manager) {
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
      title: "Ударить команду",
      desc: "Вы уверены, что хотите удалить эту команду",
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AnimatedBottomBar()));
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
            TeamService().deleteTeam(manager, teamId);
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const AnimatedBottomBar()));
          },
          color: const Color.fromRGBO(128, 128, 128, 0),
        )
      ]).show();
}

SimpleDialog notifcationPending(BuildContext context) {
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
        Center(child: Text("Уведомление находится на рассмотрении")),
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
                "Ваше уведомление все еще находится на рассмотрении. Поэтому вы не можете отправить другой запрос на присоединение",
                style: Theme.of(context).textTheme.subtitle1)),
      ),
    ],
  );
}

SimpleDialog closedTeam(BuildContext context) {
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
        Center(child: Text("Закрытая команда")),
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
                "Эта команда не открыта для игроков, чтобы присоединиться к ней",
                style: Theme.of(context).textTheme.subtitle1)),
      ),
    ],
  );
}

SimpleDialog teamJoinSuccessDialog(BuildContext context, String teamName) {
  return SimpleDialog(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    children: [
      Center(
          child: Text("Вы были добавлены в команду " + teamName,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4)),
      Image.asset("assets/confirmation-illustration.png")
    ],
  );
}

closingATeam(BuildContext context, String teamId) {
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
      title: "Закрытая команда",
      desc:
          "Вы уверены, что хотите закрыть эту команду, после этого другие не смогут подать заявку на вступление в вашу команду",
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
              "Закрыть",
              style: TextStyle(
                color: Colors.redAccent[400],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            TeamService().makeTeamClosed(teamId);
            Navigator.pop(context);
          },
          color: const Color.fromRGBO(128, 128, 128, 0),
        )
      ]).show();
}

publicisingATeam(BuildContext context, String teamId) {
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
      title: "Закрытая команда",
      desc: "Вы уверены, что хотите сделать эту команду открытой?",
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
              "Да",
              style: TextStyle(
                color: Colors.redAccent[400],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            TeamService().makeTeamPublic(teamId);
            Navigator.pop(context);
          },
          color: const Color.fromRGBO(128, 128, 128, 0),
        )
      ]).show();
}

privatizingATeam(BuildContext context, String teamId) {
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
      title: "Сделайте команду приватной",
      desc: "Вы уверены, что хотите сделать эту команду приватной?",
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
              "Да",
              style: TextStyle(
                color: Colors.redAccent[400],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            TeamService().makeTeamPrivate(teamId);
            Navigator.pop(context);
          },
          color: const Color.fromRGBO(128, 128, 128, 0),
        )
      ]).show();
}
