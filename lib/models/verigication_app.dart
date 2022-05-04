import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verigication_app.g.dart';

@JsonSerializable()
class VerificationApplication {
  String? teamId;
  String? sport;
  String? teamName;
  String? applicationId;

  VerificationApplication(
      {this.teamId, this.sport, this.teamName, this.applicationId});

  VerificationApplication.newApplication(
      this.teamId, this.sport, this.teamName, this.applicationId);

  factory VerificationApplication.fromJson(QueryDocumentSnapshot json) =>
      _$VerificationApplicationFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$VerificationApplicationToJson(this);
}
