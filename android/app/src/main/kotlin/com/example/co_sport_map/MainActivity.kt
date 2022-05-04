package com.cosport.co_sport_map

import com.yandex.mapkit.MapKitFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        MapKitFactory.setApiKey("7a1adb02-50f1-423b-af80-cfb79a94345a")
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
}