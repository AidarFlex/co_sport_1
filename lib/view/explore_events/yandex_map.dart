import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:co_sport_map/models/places.dart';
import 'package:co_sport_map/services/get_places.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class YandexMapWidget extends StatelessWidget {
  const YandexMapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const YandexMapState();
  }
}

class YandexMapState extends StatefulWidget {
  const YandexMapState({Key? key}) : super(key: key);

  @override
  State<YandexMapState> createState() => _YandexMapStateState();
}

class _YandexMapStateState extends State<YandexMapState> {
  final getPlaces = GetPlaces();
  late YandexMapController controller;
  final List<MapObject> mapObjects = [];
  final Random seed = Random();
  final MapObjectId largeClusterizedPlacemarkCollectionId =
      const MapObjectId('large_clusterized_placemark_collection');

  Future<Uint8List> _buildClusterAppearance(Cluster cluster) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(200, 200);
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    const radius = 60.0;

    final textPainter = TextPainter(
        text: TextSpan(
            text: cluster.size.toString(),
            style: const TextStyle(color: Colors.black, fontSize: 50)),
        textDirection: TextDirection.ltr);

    textPainter.layout(minWidth: 0, maxWidth: size.width);

    final textOffset = Offset((size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2);
    final circleOffset = Offset(size.height / 2, size.width / 2);

    canvas.drawCircle(circleOffset, radius, fillPaint);
    canvas.drawCircle(circleOffset, radius, strokePaint);
    textPainter.paint(canvas, textOffset);

    final image = await recorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await image.toByteData(format: ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getPlaces.getPlacesToMap(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Places placemarks = snapshot.data;
            final placeGeometry = placemarks.features;
            return YandexMap(
                onMapCreated: (YandexMapController yandexMapController) async {
                  yandexMapController.moveCamera(
                    CameraUpdate.newCameraPosition(
                      const CameraPosition(
                        target:
                            Point(latitude: 55.751244, longitude: 37.618423),
                      ),
                    ),
                    animation: const MapAnimation(),
                  );
                },
                mapObjects: [
                  ClusterizedPlacemarkCollection(
                    mapId: largeClusterizedPlacemarkCollectionId,
                    radius: 30,
                    minZoom: 15,
                    onClusterAdded: (ClusterizedPlacemarkCollection self,
                        Cluster cluster) async {
                      return cluster.copyWith(
                          appearance: cluster.appearance.copyWith(
                              opacity: 0.75,
                              icon: PlacemarkIcon.single(PlacemarkIconStyle(
                                  image: BitmapDescriptor.fromBytes(
                                      await _buildClusterAppearance(cluster)),
                                  scale: 1))));
                    },
                    placemarks: List<Placemark>.generate(
                        placemarks.features!.length, (i) {
                      return Placemark(
                          mapId: MapObjectId('placemark_$i'),
                          point: Point(
                              latitude:
                                  placeGeometry![i].geometry!.coordinates![1],
                              longitude:
                                  placeGeometry[i].geometry!.coordinates![0]),
                          icon: PlacemarkIcon.single(PlacemarkIconStyle(
                              image: BitmapDescriptor.fromAssetImage(
                                  'assets/place.png'),
                              scale: 1)));
                    }),
                    // onTap: (ClusterizedPlacemarkCollection self, Point point) =>
                    //     print('Tapped me at $point'),
                  ),
                ]);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
