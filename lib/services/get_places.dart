import 'package:co_sport_map/models/places.dart';
import 'package:dio/dio.dart';

class GetPlaces {
  Response? placesData;
  final Dio _dio = Dio();

  final _baseUrl =
      'https://apidata.mos.ru/v1/datasets/893/features?api_key=60d67f9214124da1f20cd874ce535beb';

  Future<Places> getPlacesToMap() async {
    placesData = await _dio.get(_baseUrl);
    Places places = Places.fromJson(placesData!.data);
    print(places);
    return places;
  }

  Future<Features> getGeometryToMap() async {
    placesData = await _dio.get(_baseUrl);
    Features geometryPlace = Features.fromJson(placesData!.data);
    print(geometryPlace);
    return geometryPlace;
  }
}
