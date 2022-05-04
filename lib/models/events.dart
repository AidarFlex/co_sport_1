import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:json_annotation/json_annotation.dart';

part 'events.g.dart';

@JsonSerializable()
class Events {
  String? eventName;
  String? eventId;
  String? creatorId;
  String? creatorName;
  String? location;
  String? sportName;
  String? description;
  List<dynamic>? playersId;
  List<dynamic>? participants;
  List? playerInfo;
  String? teamId;
  List? teamInfo;
  List? notification;
  DateTime? dateTime;
  int? maxMembers;
  String? status;
  int? type;
  String? teamName;

  Events({
    this.eventId,
    this.eventName,
    this.creatorId,
    this.creatorName,
    this.location,
    this.sportName,
    this.description,
    this.playersId,
    this.participants,
    this.playerInfo,
    this.teamInfo,
    this.dateTime,
    this.maxMembers,
    this.status,
    this.notification,
    this.type,
    this.teamId,
    this.teamName,
  });

  Events.newEvent(
    this.eventId,
    this.eventName,
    this.location,
    this.sportName,
    this.description,
    this.dateTime,
    this.maxMembers,
    this.status,
    this.type,
  ) {
    creatorId = Constants.prefs!.getString('userId');
    creatorName = Constants.prefs!.getString('name');
    playersId = [];
    participants = [Constants.prefs!.getString('userId')];
    notification = [];
  }
  Events.miniEvent({
    this.eventId,
    this.eventName,
    this.location,
    this.dateTime,
    this.sportName,
    this.creatorId,
    this.creatorName,
    this.type,
    this.status,
    this.playersId,
  });

  Events.miniView(
    this.eventId,
    this.eventName,
    this.sportName,
    this.location,
    this.dateTime,
    this.status,
    this.creatorId,
    this.creatorName,
    this.type,
    this.playersId,
  );

  Events.miniTeamView(
    this.eventId,
    this.eventName,
    this.sportName,
    this.location,
    this.dateTime,
    this.status,
    this.creatorId,
    this.creatorName,
    this.type,
    this.playersId,
    this.teamName,
    this.teamId,
  );

  Map<String, dynamic> miniTeamtoJson() => {
        'eventId': eventId,
        'eventName': eventName,
        'location': location,
        'sportName': sportName,
        'dateTime': dateTime,
        'creatorId': creatorId,
        'creatorName': creatorName,
        'type': type,
        'playersId': playersId,
        'status': status,
        'teamName': teamName,
        'teamId': teamId,
      };

  Map<String, dynamic> minitoJson() => {
        'eventId': eventId,
        'eventName': eventName,
        'location': location,
        'sportName': sportName,
        'dateTime': dateTime,
        'creatorId': creatorId,
        'creatorName': creatorName,
        'type': type,
        'playersId': playersId,
        'status': status,
      };

  factory Events.fromMiniJson(QueryDocumentSnapshot json) {
    var data = json.data() as Map<String, dynamic>;
    return Events(
      eventId: data['eventId'],
      eventName: data['eventName'],
      creatorId: data['creatorId'],
      location: data['location'],
      sportName: data['sportName'],
      dateTime: data['dateTime'].toDate(),
      creatorName: data['creatorName'],
      type: data['type'],
      playersId: data['playersId'],
      status: data['status'],
      teamName: data['teamName'] ?? "",
      teamId: data['teamId'] ?? "",
    );
  }

  factory Events.fromMap(Map<String, dynamic> data) {
    return Events(
      eventId: data['eventId'],
      eventName: data['eventName'],
      creatorId: data['creatorId'],
      creatorName: data['creatorName'],
      location: data['location'],
      sportName: data['sportName'],
      description: data['description'],
      playersId: data['playersId'],
      dateTime: data['dateTime'],
      maxMembers: data['maxMembers'],
      type: data['type'],
      status: data['status'],
      notification: data['notificationPlayers'],
      participants: data['participants'],
    );
  }

  factory Events.fromJson(QueryDocumentSnapshot data) =>
      _$EventsFromJson(data.data() as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$EventsToJson(this);

  Future<bool> checkingAvailability(String id) async {
    var snap =
        await FirebaseFirestore.instance.collection('events').doc(id).get();
    Map<String, dynamic>? data = snap.data();
    return data!['playersId'].length < data['maxMembers'] ? true : false;
  }

  Future<List<dynamic>> players(String id) async {
    var snap =
        await FirebaseFirestore.instance.collection('events').doc(id).get();
    Map<String, dynamic>? data = snap.data();
    return data!['playersId'];
  }
}
