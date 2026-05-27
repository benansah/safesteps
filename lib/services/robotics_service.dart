import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class RoboticsService {
  RoboticsService._();

  static final RoboticsService instance = RoboticsService._();

  BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;
  bool _connecting = false;

  static const String _targetDeviceName = 'SafeSteps Bot';
  static final Guid _serviceUuid = Guid('0000ffe0-0000-1000-8000-00805f9b34fb');
  static final Guid _characteristicUuid =
      Guid('0000ffe1-0000-1000-8000-00805f9b34fb');

  Future<void> _ensureConnected() async {
    if (kIsWeb) return;
    if (_characteristic != null) return;
    if (_connecting) return;

    _connecting = true;
    try {
      if (_device == null) {
        await FlutterBluePlus.startScan(
          timeout: const Duration(seconds: 5),
          continuousUpdates: false,
          oneByOne: true,
        );

        final scanSubscription = FlutterBluePlus.scanResults.listen((results) {
          for (final scanResult in results) {
            final name = scanResult.device.platformName.toLowerCase();
            if (name.contains(_targetDeviceName.toLowerCase()) ||
                name.contains('esp32')) {
              _device = scanResult.device;
              break;
            }
          }
        });

        await Future.delayed(const Duration(seconds: 5));
        await scanSubscription.cancel();
        await FlutterBluePlus.stopScan();
      }
      if (_device == null) return;

      await _device!.connect(
        license: License.free,
        timeout: const Duration(seconds: 8),
        autoConnect: false,
      );

      final services = await _device!.discoverServices();
      for (final service in services) {
        if (service.uuid == _serviceUuid) {
          final char = service.characteristics.firstWhere(
            (c) => c.uuid == _characteristicUuid,
            orElse: () => service.characteristics.first,
          );
          _characteristic = char;
          break;
        }
      }
    } catch (_) {
      _device = null;
      _characteristic = null;
    } finally {
      _connecting = false;
    }
  }

  Future<void> sendSafetyCommand(int riskValue) async {
    if (kIsWeb) return;
    await _ensureConnected();
    if (_characteristic == null) return;

    final code = riskValue <= 1 ? 0x01 : 0x02;
    final bytes = Uint8List.fromList([code]);
    try {
      await _characteristic!.write(bytes, withoutResponse: true);
    } catch (_) {
      // Ignore failures, this is a supplemental robotics bridge.
    }
  }
}
