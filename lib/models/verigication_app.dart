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

  // factory VerificationApplication.fromJson(Map<String, dynamic> json) =>
  //     _$VerificationApplicationFromJson(json);

  factory VerificationApplication.fromJson(Map data) {
    var parsedJson = data;
    return VerificationApplication(
        teamId: parsedJson['teamId'],
        sport: parsedJson['sport'],
        teamName: parsedJson['teamName'],
        applicationId: parsedJson['applicationId']);
  }

  Map<String, dynamic> toJson() => _$VerificationApplicationToJson(this);
}
