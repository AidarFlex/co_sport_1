import 'package:co_sport_map/models/teams.dart';
import 'package:co_sport_map/services/notification_service.dart';
import 'package:co_sport_map/services/user_services.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:co_sport_map/view/teams/create_teams.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:getwidget/components/loader/gf_loader.dart';

import '../../widget/button.dart';

class ChallangeTeam extends StatefulWidget {
  final String sportName;
  final TeamChallengeNotification teamData;
  const ChallangeTeam(
      {Key? key, required this.sportName, required this.teamData})
      : super(key: key);
  @override
  _ChallangeTeamState createState() => _ChallangeTeamState();
}

class _ChallangeTeamState extends State<ChallangeTeam> {
  late Stream currentTeams;
  @override
  void initState() {
    super.initState();
    getUserManagingTeams(widget.sportName);
  }

  SimpleDialog successDialog(BuildContext context) {
    return SimpleDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      children: [
        Center(
            child: Text("Мероприятие созданно",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4)),
        Image.asset("assets/confirmation-illustration.png")
      ],
    );
  }

  getUserManagingTeams(String sport) async {
    await UserService().getTeams(sport).then((snapshots) {
      setState(() {
        currentTeams = snapshots;
      });
    });
  }

  Widget feed() {
    return StreamBuilder(
        stream: currentTeams,
        builder: (context, AsyncSnapshot asyncSnapshot) {
          return asyncSnapshot.hasData
              ? asyncSnapshot.data.documents.length > 0
                  ? ListView.builder(
                      itemCount: asyncSnapshot.data.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        TeamView data = TeamView.fromJson(
                            asyncSnapshot.data.documents[index]);
                        String sportIcon = 'Volleyball';
                        switch (widget.sportName) {
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
                                    TeamChallengeNotification myTeam =
                                        TeamChallengeNotification.newTeam(
                                            data.teamId,
                                            Constants.prefs.getString('userId'),
                                            data.teamName);

                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          NotificationServices()
                                              .challengeTeamNotification(
                                                  widget.sportName,
                                                  widget.teamData,
                                                  myTeam);
                                          Future.delayed(
                                              const Duration(seconds: 3), () {
                                            Navigator.pop(context);
                                          });
                                          return successDialog(context);
                                        });
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
                            "Нет команды",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Button(
                            myText: 'Создать',
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
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(FeatherIcons.x),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
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
              children: <Widget>[
                feed(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
