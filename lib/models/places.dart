import 'package:json_annotation/json_annotation.dart';

part 'places.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Places {
  List<Features>? features;
  String? type;

  Places({this.features, this.type});

  factory Places.fromJson(Map<String, dynamic> json) => _$PlacesFromJson(json);

  Map<String, dynamic> toJson() => _$PlacesToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Features {
  GeometryPlaces? geometry;
  Properties? properties;
  String? type;

  Features({this.geometry, this.properties, this.type});

  factory Features.fromJson(Map<String, dynamic> json) =>
      _$FeaturesFromJson(json);

  Map<String, dynamic> toJson() => _$FeaturesToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class GeometryPlaces {
  List<double>? coordinates;
  String? type;

  GeometryPlaces({this.coordinates, this.type});

  factory GeometryPlaces.fromJson(Map<String, dynamic> json) =>
      _$GeometryPlacesFromJson(json);

  Map<String, dynamic> toJson() => _$GeometryPlacesToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Properties {
  int? datasetId;
  int? versionNumber;
  int? releaseNumber;
  Attributes? attributes;

  Properties(
      {this.datasetId,
      this.versionNumber,
      this.releaseNumber,
      this.attributes});

  factory Properties.fromJson(Map<String, dynamic> json) =>
      _$PropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$PropertiesToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Attributes {
  String? objectName;
  String? nameWinter;
  List<PhotoWinter>? photoWinter;
  String? admArea;
  String? district;
  String? address;
  String? email;
  String? webSite;
  String? helpPhone;
  String? helpPhoneExtension;
  List<WorkingHoursWinter>? workingHoursWinter;
  String? clarificationOfWorkingHoursWinter;
  String? hasEquipmentRental;
  String? equipmentRentalComments;
  String? hasTechService;
  String? techServiceComments;
  String? hasDressingRoom;
  String? hasEatery;
  String? hasToilet;
  String? hasWifi;
  String? hasCashMachine;
  String? hasFirstAidPost;
  String? hasMusic;
  String? usagePeriodWinter;
  List<DimensionsWinter>? dimensionsWinter;
  String? lighting;
  String? surfaceTypeWinter;
  int? seats;
  String? paid;
  String? paidComments;
  String? disabilityFriendly;
  String? servicesWinter;
  int? globalId;

  Attributes(
      {this.objectName,
      this.nameWinter,
      this.photoWinter,
      this.admArea,
      this.district,
      this.address,
      this.email,
      this.webSite,
      this.helpPhone,
      this.helpPhoneExtension,
      this.workingHoursWinter,
      this.clarificationOfWorkingHoursWinter,
      this.hasEquipmentRental,
      this.equipmentRentalComments,
      this.hasTechService,
      this.techServiceComments,
      this.hasDressingRoom,
      this.hasEatery,
      this.hasToilet,
      this.hasWifi,
      this.hasCashMachine,
      this.hasFirstAidPost,
      this.hasMusic,
      this.usagePeriodWinter,
      this.dimensionsWinter,
      this.lighting,
      this.surfaceTypeWinter,
      this.seats,
      this.paid,
      this.paidComments,
      this.disabilityFriendly,
      this.servicesWinter,
      this.globalId});

  factory Attributes.fromJson(Map<String, dynamic> json) =>
      _$AttributesFromJson(json);

  Map<String, dynamic> toJson() => _$AttributesToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PhotoWinter {
  int? isDeleted;
  int? globalId;
  String? photo;

  PhotoWinter({this.isDeleted, this.globalId, this.photo});

  factory PhotoWinter.fromJson(Map<String, dynamic> json) =>
      _$PhotoWinterFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoWinterToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class WorkingHoursWinter {
  int? isDeleted;
  int? globalId;
  String? dayOfWeek;
  String? hours;

  WorkingHoursWinter(
      {this.isDeleted, this.globalId, this.dayOfWeek, this.hours});

  factory WorkingHoursWinter.fromJson(Map<String, dynamic> json) =>
      _$WorkingHoursWinterFromJson(json);

  Map<String, dynamic> toJson() => _$WorkingHoursWinterToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class DimensionsWinter {
  int? isDeleted;
  int? globalId;
  double? square;
  double? length;
  double? width;

  DimensionsWinter(
      {this.isDeleted, this.globalId, this.square, this.length, this.width});

  factory DimensionsWinter.fromJson(Map<String, dynamic> json) =>
      _$DimensionsWinterFromJson(json);

  Map<String, dynamic> toJson() => _$DimensionsWinterToJson(this);
}
