import 'dart:async';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';

void main() {
  /*runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await windowManager.ensureInitialized();

      WindowOptions windowOptions = const WindowOptions(
        center: true,
        maximumSize: Size.infinite,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        title: "MilliyWay POS",
      );

      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.maximize();
        await windowManager.setResizable(false);
        await windowManager.focus();
      });

      runApp(const MyApp());
    },
    (error, stackTrace) {
      if (error.toString().contains('HardwareKeyboard')) {
        // Suppress known key event bug
      } else {
        debugPrint("Xatolik: $error");
        debugPrint("Stack: $stackTrace");
      }
    },
  );*/
  runApp(MyApp());
}
