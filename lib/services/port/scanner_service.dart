import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class ScannerService {
  SerialPort? _port;
  SerialPortReader? _reader;
  StreamSubscription<Uint8List>? _subscription;

  final StreamController<String> _onDataController = StreamController.broadcast();
  final StreamController<bool> _onConnectionController = StreamController.broadcast();

  /// Scannerdan kelgan ma'lumotlar streami
  Stream<String> get onData => _onDataController.stream;

  /// Port holati streami (true => ochilgan, false => yopilgan)
  Stream<bool> get onConnectionChanged => _onConnectionController.stream;

  /// Mavjud portlar ro'yxatini qaytaradi
  List<String> getAvailablePorts() {
    return SerialPort.availablePorts;
  }

  /// Port ochish va Scanner ma'lumotlarini o'qishni boshlash
  bool connect(String portName, {int baudRate = 9600}) {
    disconnect(); // Avval ochilgan port bo‘lsa yopib yuboradi

    try {
      _port = SerialPort(portName);
      if (!_port!.openReadWrite()) {
        throw Exception('Port ochilmadi: ${SerialPort.lastError}');
      }

      _port!.config.baudRate = baudRate;
      _port!.config.bits = 8;
      _port!.config.parity = SerialPortParity.none;
      _port!.config.stopBits = 1;
      _port!.config = SerialPortConfig()
        ..baudRate = baudRate
        ..bits = 8
        ..parity = SerialPortParity.none
        ..stopBits = 1;

      _reader = SerialPortReader(_port!);
      _subscription = _reader!.stream.listen((data) {
        final decodedData = utf8.decode(data, allowMalformed: true);
        _onDataController.add(decodedData);
      });

      _onConnectionController.add(true);
      return true;
    } catch (e) {
      print('Port ochishda xatolik: $e');
      disconnect();
      return false;
    }
  }

  /// Portni yopish
  void disconnect() {
    _subscription?.cancel();
    _subscription = null;

    _reader?.close();
    _reader = null;

    if (_port != null && _port!.isOpen) {
      _port!.close();
    }

    _port = null;
    _onConnectionController.add(false);
  }

  /// ScannerService ni to‘liq tozalash
  void dispose() {
    disconnect();
    _onDataController.close();
    _onConnectionController.close();
  }
}
