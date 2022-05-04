import 'package:co_sport_map/models/teams.dart';
import 'package:co_sport_map/services/notification_service.dart';
import 'package:co_sport_map/services/team_services.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:co_sport_map/utils/theme_config.dart';
import 'package:co_sport_map/view/chats/team_conversation.dart';
import 'package:co_sport_map/view/teams/team_info.dart';
import 'package:co_sport_map/widget/small_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:provider/provider.dart';

import '../../widget/build_title.dart';

class TeamCategory extends StatefulWidget {
  final String? sportName;
  const TeamCategory({Key? key, this.sportName}) : super(key: key);
  @override
  _TeamCategoryState createState() => _TeamCategoryState();
}

class _TeamCategoryState extends State<TeamCategory> {
  Stream? teamFeed;
  @override
  void initState() {
    super.initState();
    getAllTeams();
  }

  getAllTeams() async {
    await TeamService()
        .getSpecificCategoryFeed(widget.sportName!)
        .then((snapshots) {
      setState(() {
        teamFeed = snapshots;
      });
    });
  }

  SimpleDialog successDialog(BuildContext context) {
    return SimpleDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      children: [
        Center(
            child: Text("You Have been added",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4)),
        Image.asset("assets/confirmation-illustration.png")
      ],
    );
  }

  getUserInfoEvents() async {
    TeamService().getAllTeamsFeed().then((snapshots) {
      setState(() {
        teamFeed = snapshots;
      });
    });
  }

  Widget feed({ThemeNotifier? theme}) {
    return StreamBuilder(
      stream: teamFeed,
      builder: (context, AsyncSnapshot asyncSnapshot) {
        return asyncSnapshot.hasData
            ? asyncSnapshot.data.docs.length > 0
                ? ListView.builder(
                    itemCount: asyncSnapshot.data.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Teams data =
                          Teams.fromJson(asyncSnapshot.data.documents[index]);

                      String sportIcon = '';
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
                      bool notifiedCondition = false;
                      bool joinCondition = data.playerId!
                          .contains(Constants.prefs.getString('userId'));
                      if (data.notification!.isNotEmpty) {
                        notifiedCondition = data.notification!
                            .contains(Constants.prefs.getString('userId'));
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    maintainState: true,
                                    onExpansionChanged: (expanded) {
                                      if (expanded) {
                                      } else {}
                                    },
                                    children: [
                                      SmallButton(
                                          myColor: !joinCondition
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                          myText: !joinCondition
                                              ? !notifiedCondition
                                                  ? "Join"
                                                  : "Request Sent"
                                              : "Chats",
                                          onPressed: () {
                                            if (!joinCondition &&
                                                notifiedCondition) {
                                              //Notification pending
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return notifcationPending(
                                                      context);
                                                },
                                              );
                                            } else if (!joinCondition &&
                                                !notifiedCondition) {
                                              if (data.status == 'private') {
                                                NotificationServices()
                                                    .createTeamNotification(
                                                        Constants.prefs
                                                                .getString(
                                                                    'userId')
                                                            as String,
                                                        data.manager!,
                                                        data);
                                              }
                                              if (data.status == 'closed') {}
                                              if (data.status == 'public') {
                                                TeamService()
                                                    .addMeInTeam(data.teamId!)
                                                    .then(() => {});
                                              }
                                            }
                                            if (joinCondition) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TeamConversation(
                                                      data: data,
                                                    ),
                                                  ));
                                            }
                                          })
                                    ],
                                    leading: Image.asset(sportIcon),
                                    title: Text(
                                      data.teamName!,
                                      style: TextStyle(
                                        color:
                                            theme!.currentTheme.backgroundColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.bio!,
                                          style: TextStyle(
                                            color: theme
                                                .currentTheme.backgroundColor,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              FeatherIcons.mapPin,
                                              size: 16.0,
                                            ),
                                            Text(
                                              data.status!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    trailing:
                                        Text(data.playerId!.length.toString()),
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
                    child: Image.asset("assets/notification.png"),
                  )
            : const Loader();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: buildTitle(context, widget.sportName!),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GestureDetector(
              onTap: () {
                showSearch(
                    context: context, delegate: TeamCategorySearchDirect());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      FeatherIcons.search,
                      color:
                          Theme.of(context).iconTheme.color!.withOpacity(0.5),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Search",
                      style: TextStyle(
                        color: Theme.of(context)
                            .inputDecorationTheme
                            .hintStyle!
                            .color,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Text(
              'Nearby you',
              style: TextStyle(
                color: theme.currentTheme.backgroundColor.withOpacity(0.35),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                feed(theme: theme),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TeamCategorySearchDirect extends SearchDelegate<ListView> {
  getTeams(String query) {
    return FirebaseDatabase.instance
        .ref("teams/teamname")
        .equalTo(query)
        .limitToFirst(1)
        .onValue;
  }

  getTeamFeed(String query) {
    return FirebaseDatabase.instance
        .ref("teams/teamSearchParam")
        .equalTo(query)
        .limitToFirst(5)
        .onValue;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    return ThemeData(
      primaryColor: theme.currentTheme.appBarTheme.backgroundColor,
      appBarTheme: theme.currentTheme.appBarTheme,
      inputDecorationTheme: theme.currentTheme.inputDecorationTheme,
      textTheme: theme.currentTheme.textTheme,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(FeatherIcons.x),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(context, ListView());
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    return StreamBuilder(
        stream: getTeams(query),
        builder: (context, AsyncSnapshot asyncSnapshot) {
          return asyncSnapshot.hasData
              ? ListView.builder(
                  itemCount: asyncSnapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Teams data =
                        Teams.fromJson(asyncSnapshot.data.documents[index]);

                    String sportIcon = '';
                    switch (data.sport) {
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
                    bool notifiedCondition = false;
                    bool joinCondition = data.playerId!
                        .contains(Constants.prefs.getString('userId'));
                    if (data.notification!.isNotEmpty) {
                      notifiedCondition = data.notification!
                          .contains(Constants.prefs.getString('userId'));
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  maintainState: true,
                                  onExpansionChanged: (expanded) {
                                    if (expanded) {
                                    } else {}
                                  },
                                  children: [
                                    SmallButton(
                                        myColor: !joinCondition
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                        myText: !joinCondition
                                            ? !notifiedCondition
                                                ? "Join"
                                                : "Request Sent"
                                            : "Chats",
                                        onPressed: () {
                                          if (!joinCondition &&
                                              notifiedCondition) {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return notifcationPending(
                                                    context);
                                              },
                                            );
                                          } else if (!joinCondition &&
                                              !notifiedCondition) {
                                            if (data.status == 'private') {
                                              NotificationServices()
                                                  .createTeamNotification(
                                                      Constants.prefs.getString(
                                                          'userId') as String,
                                                      data.manager!,
                                                      data);
                                            }
                                            if (data.status == 'closed') {}
                                            if (data.status == 'public') {
                                              TeamService()
                                                  .addMeInTeam(data.teamId!)
                                                  .then(() => {});
                                            }
                                          }
                                          if (joinCondition) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TeamConversation(
                                                    data: data,
                                                  ),
                                                ));
                                          }
                                        })
                                  ],
                                  leading: Image.asset(sportIcon),
                                  title: Text(
                                    data.teamName!,
                                    style: TextStyle(
                                      color: theme.currentTheme.backgroundColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.bio!,
                                        style: TextStyle(
                                          color: theme
                                              .currentTheme.backgroundColor,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            FeatherIcons.mapPin,
                                            size: 16.0,
                                          ),
                                          Text(
                                            data.status!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  trailing:
                                      Text(data.playerId!.length.toString()),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Image(
                    image: AssetImage("assets/search-illustration.png"),
                  ),
                );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    String sportIcon = '';
    return StreamBuilder(
        stream: getTeamFeed(query),
        builder: (context, AsyncSnapshot asyncSnapshot) {
          return asyncSnapshot.hasData
              ? ListView.builder(
                  itemCount: asyncSnapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    switch (asyncSnapshot.data.documents[index].get('sport')) {
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
                          vertical: 4.0, horizontal: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return TeamInfo(
                                  teamID: asyncSnapshot.data.documents[index]
                                      .get('teamId'),
                                );
                              },
                            ),
                          );
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.asset(sportIcon),
                              ),
                              title: Text(asyncSnapshot.data.documents[index]
                                  .get('teamname')),
                              subtitle: Text(
                                asyncSnapshot.data.documents[index]
                                    .get('status'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : const Center(
                  child: Image(
                    image: AssetImage("assets/search-illustration.png"),
                  ),
                );
        });
    // throw UnimplementedError();
  }
}
