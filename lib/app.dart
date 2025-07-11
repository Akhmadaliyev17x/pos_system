import 'package:flutter/material.dart';
import 'package:milliyway_pos/core/constants/app_theme.dart';
import 'package:milliyway_pos/core/router/router.dart';
import 'package:milliyway_pos/feature/home/providers/home_provider.dart';
import 'package:milliyway_pos/feature/home/providers/scanner_provider.dart';
import 'package:milliyway_pos/feature/settings/providers/settings_theme_provider.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ScannerProvider()),
      ],
      child: const _Material(),
    );
  }
}

class _Material extends StatelessWidget {
  const _Material();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, controller, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: !controller.value ? ThemeMode.dark : ThemeMode.light,
        );
      },
    );
  }
}
