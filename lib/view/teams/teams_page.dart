import 'package:co_sport_map/models/teams.dart';
import 'package:co_sport_map/services/notification_service.dart';
import 'package:co_sport_map/services/team_services.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:co_sport_map/utils/theme_config.dart';
import 'package:co_sport_map/view/chats/team_conversation.dart';
import 'package:co_sport_map/view/teams/challenge_screen.dart';
import 'package:co_sport_map/view/teams/team_info.dart';
import 'package:co_sport_map/view/teams/tram_category.dart';
import 'package:co_sport_map/widget/build_title.dart';
import 'package:co_sport_map/widget/button.dart';
import 'package:co_sport_map/widget/small_button.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:provider/provider.dart';

class TeamsList extends StatefulWidget {
  const TeamsList({Key? key}) : super(key: key);

  @override
  _TeamsListState createState() => _TeamsListState();
}

class _TeamsListState extends State<TeamsList>
    with SingleTickerProviderStateMixin {
  int loadMoreTeams = 20;
  late ScrollController _teamsScrollController;
  @override
  void initState() {
    super.initState();
    _teamsScrollController = ScrollController()
      ..addListener(() {
        if (_teamsScrollController.position.pixels ==
            _teamsScrollController.position.maxScrollExtent) {
          setState(() {
            loadMoreTeams += loadMoreTeams;
          });
        }
      });
  }

  Widget feed({ThemeNotifier? theme}) {
    return StreamBuilder(
      stream: FirebaseDatabase.instance
          .ref("teams")
          .limitToFirst(loadMoreTeams)
          .onValue,
      builder: (context, AsyncSnapshot event) {
        if (event.hasData) {
          if (event.data.snapshot.value != null) {
            return ListView.builder(
              controller: _teamsScrollController,
              itemCount: event.data.snapshot.value.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Map map = event.data.snapshot.value;
                Teams data = Teams.fromJson(map.values.elementAt(index));

                late String sportIcon;
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
                // if (data.notification!.isNotEmpty) {
                //   notifiedCondition = data.notification!
                //       .contains(Constants.prefs.getString('userId'));
                // }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: GestureDetector(
                    onLongPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return TeamInfo(
                              teamID: data.teamId!,
                            );
                          },
                        ),
                      );
                    },
                    child: Card(
                      child: ExpansionTileCard(
                        initiallyExpanded: false,
                        children: [
                          !joinCondition
                              ? SmallButton(
                                  myColor: !joinCondition
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).colorScheme.secondary,
                                  myText: !joinCondition
                                      ? !notifiedCondition
                                          ? "Присоединяйтесь"
                                          : "Запрос отправлен"
                                      : "Уже в этой команде",
                                  onPressed: () {
                                    if (!joinCondition && notifiedCondition) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return notifcationPending(context);
                                        },
                                      );
                                    } else if (!joinCondition &&
                                        !notifiedCondition) {
                                      if (data.status == 'private') {
                                        NotificationServices()
                                            .createTeamNotification(
                                                Constants.prefs
                                                        .getString('userId')
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
                                  })
                              : Container(),
                          SmallButton(
                            myColor: !joinCondition
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).colorScheme.secondary,
                            myText:
                                !joinCondition ? 'Мероприятие' : 'Сообщения',
                            onPressed: () {
                              if (!joinCondition) {
                                final TeamChallengeNotification teamData =
                                    TeamChallengeNotification.newTeam(
                                        data.teamId,
                                        data.manager,
                                        data.teamName);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChallangeTeam(
                                          sportName: data.sport!,
                                          teamData: teamData)),
                                );
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TeamConversation(
                                        data: data,
                                      ),
                                    ));
                              }
                            },
                          )
                        ],
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    TeamSportLeading(sportIcon: sportIcon),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: SizedBox(
                                        width: 120,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TeamName(data: data),
                                            TypeofTeam(data: data),
                                            TeamDescription(data: data),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      CircularProgressIndicator(
                                        value: data.playerId!.length / 20,
                                        backgroundColor: theme!
                                            .currentTheme.backgroundColor
                                            .withOpacity(0.15),
                                        strokeWidth: 7,
                                      ),
                                      Text(
                                        data.playerId!.length.toString() +
                                            "/20",
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        title: const Text(''),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Image.asset("assets/teams_illustration.png",
                        width: 300),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Не нашли никакой команды, создайте ее",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  Button(
                    myColor: Theme.of(context).primaryColor,
                    myText: "Создать команду",
                    onPressed: () {
                      Navigator.pushNamed(context, "/createteam");
                    },
                  )
                ],
              ),
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
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: buildTitle(context, "Команды"),
      ),
      body: NestedScrollView(
        headerSliverBuilder: _teamsPageSliverAppBar,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Stack(
                children: [feed(theme: theme)],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/createteam");
        },
        child: const Icon(
          FeatherIcons.userPlus,
          size: 32,
        ),
      ),
    );
  }

  List<Widget> _teamsPageSliverAppBar(
      BuildContext context, bool innerBoxIsScrolled) {
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    return [
      SliverList(
        delegate: SliverChildListDelegate(
          [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Text(
                'Категории',
                style: TextStyle(
                  color: theme.currentTheme.backgroundColor.withOpacity(0.35),
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SportsCategory(
                      theme: theme,
                      sport: "Баскетбол",
                      icon: "assets/icons8-basketball-96.png",
                    ),
                    SportsCategory(
                      theme: theme,
                      sport: "Футбол",
                      icon: "assets/icons8-soccer-ball-96.png",
                    ),
                    SportsCategory(
                      theme: theme,
                      sport: "Волейбол",
                      icon: "assets/icons8-volleyball-96.png",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    ];
  }
}

class PlayerPreview3 extends StatelessWidget {
  const PlayerPreview3({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0),
      child: Container(
        padding: const EdgeInsets.all(2),
        child: CircleAvatar(
          radius: 13,
          backgroundColor: Theme.of(context).cardColor,
          child: const Padding(
              padding: EdgeInsets.all(3),
              child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://pbs.twimg.com/profile_images/1286371379768516608/KKBFYV_t.jpg"))),
        ),
      ),
    );
  }
}

class PlayerPreview1 extends StatelessWidget {
  const PlayerPreview1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: CircleAvatar(
        radius: 13,
        backgroundColor: Theme.of(context).cardColor,
        child: const Padding(
            padding: EdgeInsets.all(3),
            child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://pbs.twimg.com/profile_images/1286371379768516608/KKBFYV_t.jpg"))),
      ),
    );
  }
}

class TeamSportLeading extends StatelessWidget {
  const TeamSportLeading({
    Key? key,
    required this.sportIcon,
  }) : super(key: key);

  final String sportIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Image.asset(
        sportIcon,
        width: 70,
      ),
    );
  }
}

class TeamName extends StatelessWidget {
  const TeamName({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Teams data;

  @override
  Widget build(BuildContext context) {
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            data.teamName!,
            style: TextStyle(
              color: theme.currentTheme.backgroundColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.clip,
          ),
        ),
        data.verified == 'Y'
            ? const Icon(
                Icons.verified,
                size: 16.0,
              )
            : Container(),
      ],
    );
  }
}

class TeamDescription extends StatelessWidget {
  const TeamDescription({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Teams data;

  @override
  Widget build(BuildContext context) {
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    return Text(
      data.bio!,
      style: TextStyle(
        color: theme.currentTheme.backgroundColor,
      ),
      maxLines: 2,
      overflow: TextOverflow.visible,
    );
  }
}

class TypeofTeam extends StatelessWidget {
  const TypeofTeam({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Teams data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Icon(
            data.status == "public" ? FeatherIcons.globe : FeatherIcons.lock,
            size: 16,
            color:
                data.status == "public" ? Colors.green[400] : Colors.red[400],
          ),
        ),
        Text(
          data.status == "public" ? "Открытая" : "Закрытая",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color:
                data.status == "public" ? Colors.green[400] : Colors.red[400],
          ),
        ),
      ],
    );
  }
}

class PlayerPreview2 extends StatelessWidget {
  const PlayerPreview2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Container(
        padding: const EdgeInsets.all(2),
        child: CircleAvatar(
          radius: 13,
          backgroundColor: Theme.of(context).cardColor,
          child: const Padding(
              padding: EdgeInsets.all(3),
              child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://pbs.twimg.com/profile_images/1286371379768516608/KKBFYV_t.jpg"))),
        ),
      ),
    );
  }
}

class SportsCategory extends StatelessWidget {
  const SportsCategory({
    Key? key,
    required this.theme,
    required this.sport,
    required this.icon,
  }) : super(key: key);

  final ThemeNotifier theme;
  final String sport;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TeamCategory(sportName: sport))),
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(200)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(icon, scale: 1.8),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              sport,
              style: TextStyle(
                color: theme.currentTheme.backgroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
