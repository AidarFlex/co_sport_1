import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  DateTime? dateTime;
  String? sentby;
  String? message;
  String? sentByName;
  String? type;

  Message(
      {this.dateTime, this.sentby, this.message, this.sentByName, this.type});

  Message.newMessage(
    this.dateTime,
    this.sentby,
    this.message,
    this.sentByName,
  );

  factory Message.fromJson(QueryDocumentSnapshot<Map<String, dynamic>> data) {
    return _$MessageFromJson(data.data());
  }
  // factory Message.fromJson(QueryDocumentSnapshot<dynamic> data) {
  //   var parsedJson = data.data() as Map<String, dynamic>;
  //   return Message(
  //       dateTime: parsedJson['dateTime'].toDate(),
  //       sentby: parsedJson['sentby'],
  //       message: parsedJson['message'],
  //       sentByName: parsedJson['sentByName'],
  //       type: parsedJson['type'] ?? "");
  // }

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
