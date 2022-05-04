// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'places.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Places _$PlacesFromJson(Map<String, dynamic> json) => Places(
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => Features.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: json['type'] as String?,
    );

Map<String, dynamic> _$PlacesToJson(Places instance) => <String, dynamic>{
      'features': instance.features?.map((e) => e.toJson()).toList(),
      'type': instance.type,
    };

Features _$FeaturesFromJson(Map<String, dynamic> json) => Features(
      geometry: json['geometry'] == null
          ? null
          : GeometryPlaces.fromJson(json['geometry'] as Map<String, dynamic>),
      properties: json['properties'] == null
          ? null
          : Properties.fromJson(json['properties'] as Map<String, dynamic>),
      type: json['type'] as String?,
    );

Map<String, dynamic> _$FeaturesToJson(Features instance) => <String, dynamic>{
      'geometry': instance.geometry?.toJson(),
      'properties': instance.properties?.toJson(),
      'type': instance.type,
    };

GeometryPlaces _$GeometryPlacesFromJson(Map<String, dynamic> json) =>
    GeometryPlaces(
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      type: json['type'] as String?,
    );

Map<String, dynamic> _$GeometryPlacesToJson(GeometryPlaces instance) =>
    <String, dynamic>{
      'coordinates': instance.coordinates,
      'type': instance.type,
    };

Properties _$PropertiesFromJson(Map<String, dynamic> json) => Properties(
      datasetId: json['dataset_id'] as int?,
      versionNumber: json['version_number'] as int?,
      releaseNumber: json['release_number'] as int?,
      attributes: json['attributes'] == null
          ? null
          : Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PropertiesToJson(Properties instance) =>
    <String, dynamic>{
      'dataset_id': instance.datasetId,
      'version_number': instance.versionNumber,
      'release_number': instance.releaseNumber,
      'attributes': instance.attributes?.toJson(),
    };

Attributes _$AttributesFromJson(Map<String, dynamic> json) => Attributes(
      objectName: json['object_name'] as String?,
      nameWinter: json['name_winter'] as String?,
      photoWinter: (json['photo_winter'] as List<dynamic>?)
          ?.map((e) => PhotoWinter.fromJson(e as Map<String, dynamic>))
          .toList(),
      admArea: json['adm_area'] as String?,
      district: json['district'] as String?,
      address: json['address'] as String?,
      email: json['email'] as String?,
      webSite: json['web_site'] as String?,
      helpPhone: json['help_phone'] as String?,
      helpPhoneExtension: json['help_phone_extension'] as String?,
      workingHoursWinter: (json['working_hours_winter'] as List<dynamic>?)
          ?.map((e) => WorkingHoursWinter.fromJson(e as Map<String, dynamic>))
          .toList(),
      clarificationOfWorkingHoursWinter:
          json['clarification_of_working_hours_winter'] as String?,
      hasEquipmentRental: json['has_equipment_rental'] as String?,
      equipmentRentalComments: json['equipment_rental_comments'] as String?,
      hasTechService: json['has_tech_service'] as String?,
      techServiceComments: json['tech_service_comments'] as String?,
      hasDressingRoom: json['has_dressing_room'] as String?,
      hasEatery: json['has_eatery'] as String?,
      hasToilet: json['has_toilet'] as String?,
      hasWifi: json['has_wifi'] as String?,
      hasCashMachine: json['has_cash_machine'] as String?,
      hasFirstAidPost: json['has_first_aid_post'] as String?,
      hasMusic: json['has_music'] as String?,
      usagePeriodWinter: json['usage_period_winter'] as String?,
      dimensionsWinter: (json['dimensions_winter'] as List<dynamic>?)
          ?.map((e) => DimensionsWinter.fromJson(e as Map<String, dynamic>))
          .toList(),
      lighting: json['lighting'] as String?,
      surfaceTypeWinter: json['surface_type_winter'] as String?,
      seats: json['seats'] as int?,
      paid: json['paid'] as String?,
      paidComments: json['paid_comments'] as String?,
      disabilityFriendly: json['disability_friendly'] as String?,
      servicesWinter: json['services_winter'] as String?,
      globalId: json['global_id'] as int?,
    );

Map<String, dynamic> _$AttributesToJson(Attributes instance) =>
    <String, dynamic>{
      'object_name': instance.objectName,
      'name_winter': instance.nameWinter,
      'photo_winter': instance.photoWinter?.map((e) => e.toJson()).toList(),
      'adm_area': instance.admArea,
      'district': instance.district,
      'address': instance.address,
      'email': instance.email,
      'web_site': instance.webSite,
      'help_phone': instance.helpPhone,
      'help_phone_extension': instance.helpPhoneExtension,
      'working_hours_winter':
          instance.workingHoursWinter?.map((e) => e.toJson()).toList(),
      'clarification_of_working_hours_winter':
          instance.clarificationOfWorkingHoursWinter,
      'has_equipment_rental': instance.hasEquipmentRental,
      'equipment_rental_comments': instance.equipmentRentalComments,
      'has_tech_service': instance.hasTechService,
      'tech_service_comments': instance.techServiceComments,
      'has_dressing_room': instance.hasDressingRoom,
      'has_eatery': instance.hasEatery,
      'has_toilet': instance.hasToilet,
      'has_wifi': instance.hasWifi,
      'has_cash_machine': instance.hasCashMachine,
      'has_first_aid_post': instance.hasFirstAidPost,
      'has_music': instance.hasMusic,
      'usage_period_winter': instance.usagePeriodWinter,
      'dimensions_winter':
          instance.dimensionsWinter?.map((e) => e.toJson()).toList(),
      'lighting': instance.lighting,
      'surface_type_winter': instance.surfaceTypeWinter,
      'seats': instance.seats,
      'paid': instance.paid,
      'paid_comments': instance.paidComments,
      'disability_friendly': instance.disabilityFriendly,
      'services_winter': instance.servicesWinter,
      'global_id': instance.globalId,
    };

PhotoWinter _$PhotoWinterFromJson(Map<String, dynamic> json) => PhotoWinter(
      isDeleted: json['is_deleted'] as int?,
      globalId: json['global_id'] as int?,
      photo: json['photo'] as String?,
    );

Map<String, dynamic> _$PhotoWinterToJson(PhotoWinter instance) =>
    <String, dynamic>{
      'is_deleted': instance.isDeleted,
      'global_id': instance.globalId,
      'photo': instance.photo,
    };

WorkingHoursWinter _$WorkingHoursWinterFromJson(Map<String, dynamic> json) =>
    WorkingHoursWinter(
      isDeleted: json['is_deleted'] as int?,
      globalId: json['global_id'] as int?,
      dayOfWeek: json['day_of_week'] as String?,
      hours: json['hours'] as String?,
    );

Map<String, dynamic> _$WorkingHoursWinterToJson(WorkingHoursWinter instance) =>
    <String, dynamic>{
      'is_deleted': instance.isDeleted,
      'global_id': instance.globalId,
      'day_of_week': instance.dayOfWeek,
      'hours': instance.hours,
    };

DimensionsWinter _$DimensionsWinterFromJson(Map<String, dynamic> json) =>
    DimensionsWinter(
      isDeleted: json['is_deleted'] as int?,
      globalId: json['global_id'] as int?,
      square: (json['square'] as num?)?.toDouble(),
      length: (json['length'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DimensionsWinterToJson(DimensionsWinter instance) =>
    <String, dynamic>{
      'is_deleted': instance.isDeleted,
      'global_id': instance.globalId,
      'square': instance.square,
      'length': instance.length,
      'width': instance.width,
    };
