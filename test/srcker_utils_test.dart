import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:srcker_utils/srcker_flutter_utils.dart';

void main() {
    const MethodChannel channel = MethodChannel('srcker_flutter_utils');

    setUp(() {
        channel.setMockMethodCallHandler((MethodCall methodCall) async {
            return '42';
        });
    });

    tearDown(() {
        channel.setMockMethodCallHandler(null);
    });

    test('getPlatformVersion', () async {
        // 使用 meaningful 变量名来提高可读性
        final platformVersion = await SrckerFlutterUtils.platformVersion;
        // 使用 expect 来验证结果
        expect(platformVersion, '42');
    });
}
