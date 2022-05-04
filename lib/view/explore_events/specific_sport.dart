// import 'package:co_sport_map/models/events.dart';
// import 'package:co_sport_map/utils/contansts.dart';
// import 'package:co_sport_map/utils/theme_config.dart';
// import 'package:co_sport_map/widget/build_title.dart';
// import 'package:co_sport_map/widget/small_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// import '../../services/event_service.dart';
// import '../../widget/loader.dart';

// class SpecificSport extends StatefulWidget {
//   final String sportName;
//   const SpecificSport({Key? key, required this.sportName}) : super(key: key);
//   @override
//   _SpecificSportState createState() => _SpecificSportState();
// }

// class _SpecificSportState extends State<SpecificSport> {
//   Stream? currentFeed;
//   @override
//   void initState() {
//     super.initState();
//     getUserInfoEvents();
//   }

//   SimpleDialog successDialog(BuildContext context) {
//     return SimpleDialog(
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(20)),
//       ),
//       children: [
//         Center(
//             child: Text("You Have been added",
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.headline4)),
//         Image.asset("assets/confirmation-illustration.png")
//       ],
//     );
//   }

//   getUserInfoEvents() async {
//     EventService().getSpecificFeed(widget.sportName).then((snapshots) {
//       setState(() {
//         currentFeed = snapshots;
//       });
//     });
//   }

//   Widget feed({ThemeNotifier? theme}) {
//     return StreamBuilder(
//       stream: currentFeed,
//       builder: (context, AsyncSnapshot asyncSnapshot) {
//         return asyncSnapshot.hasData
//             ? asyncSnapshot.data.docs.length > 0
//                 ? ListView.builder(
//                     itemCount: asyncSnapshot.data.documents.length,
//                     shrinkWrap: true,
//                     itemBuilder: (context, index) {
//                       Events data =
//                           Events.fromJson(asyncSnapshot.data.documents[index]);
//                       String? sportIcon;
//                       switch (widget.sportName) {
//                         case "Volleyball":
//                           sportIcon = "assets/icons8-volleyball-96.png";
//                           break;
//                         case "Basketball":
//                           sportIcon = "assets/icons8-basketball-96.png";
//                           break;
//                         case "Cricket":
//                           sportIcon = "assets/icons8-cricket-96.png";
//                           break;
//                         case "Football":
//                           sportIcon = "assets/icons8-soccer-ball-96.png";
//                           break;
//                       }
//                       bool registrationCondition = data.playersId!
//                           .contains(Constants.prefs.getString('userId'));
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 8.0, horizontal: 16.0),
//                         child: Card(
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 8.0),
//                                 child: Theme(
//                                   data: Theme.of(context).copyWith(
//                                       dividerColor: Colors.transparent),
//                                   child: ExpansionTile(
//                                     tilePadding: const EdgeInsets.all(0),
//                                     maintainState: true,
//                                     onExpansionChanged: (expanded) {
//                                       if (expanded) {
//                                       } else {}
//                                     },
//                                     children: [
//                                       SmallButton(
//                                           myColor: !registrationCondition
//                                               ? Theme.of(context).primaryColor
//                                               : Theme.of(context)
//                                                   .colorScheme
//                                                   .secondary,
//                                           myText: !registrationCondition
//                                               ? "Join"
//                                               : "Already Registered",
//                                           onPressed: () {
//                                             if (!registrationCondition) {
//                                               registerUserToEvent(
//                                                 data.eventId!,
//                                                 data.eventName!,
//                                                 data.sportName!,
//                                                 data.location!,
//                                                 data.dateTime!,
//                                                 data.creatorId!,
//                                                 data.creatorName!,
//                                                 data.status!,
//                                                 data.type!,
//                                                 data.playersId!,
//                                               );
//                                               showDialog(
//                                                   context: context,
//                                                   builder: (context) {
//                                                     return successDialog(
//                                                         context);
//                                                   });
//                                             } else {
//                                               print("Already Registered");
//                                             }
//                                           })
//                                     ],
//                                     leading: Image.asset(sportIcon!),
//                                     title: Text(
//                                       data.eventName!,
//                                       style: TextStyle(
//                                         color:
//                                             theme!.currentTheme.backgroundColor,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     subtitle: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           data.description!,
//                                           style: TextStyle(
//                                             color: theme
//                                                 .currentTheme.backgroundColor,
//                                           ),
//                                         ),
//                                         Text(
//                                           DateFormat('E-dd/MM-')
//                                               .add_jm()
//                                               .format(data.dateTime!)
//                                               .toString(),
//                                           style: const TextStyle(
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                         Row(
//                                           children: [
//                                             const Icon(
//                                               FeatherIcons.mapPin,
//                                               size: 16.0,
//                                             ),
//                                             Text(
//                                               data.location!,
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .subtitle1,
//                                             ),
//                                           ],
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   )
//                 : Center(
//                     child: Image.asset("assets/notification.png"),
//                   )
//             : const Loader();
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
//     return Scaffold(
//       appBar: AppBar(
//         leading: const BackButton(),
//         title: buildTitle(context, widget.sportName),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
//             child: Text(
//               'Nearby you',
//               style: TextStyle(
//                 color: theme.currentTheme.backgroundColor.withOpacity(0.35),
//                 fontSize: 17,
//                 fontWeight: FontWeight.w700,
//               ),
//               textAlign: TextAlign.start,
//             ),
//           ),
//           Expanded(
//             child: Stack(
//               children: <Widget>[
//                 feed(theme: theme),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
