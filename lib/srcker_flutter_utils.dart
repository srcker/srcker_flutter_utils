import 'dart:async';
import 'package:flutter/services.dart';

class SrckerFlutterUtils {
    static const MethodChannel _channel = MethodChannel('srcker_flutter_utils');

    static Future<String> get platformVersion async {
        final String version = await _channel.invokeMethod('getPlatformVersion');
        return version;
    }
}