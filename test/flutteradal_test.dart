import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutteradal/flutteradal.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutteradal');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Flutteradal.platformVersion, '42');
  });
}
