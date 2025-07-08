import 'package:flutter/material.dart';
import 'package:milliyway_pos/core/router/router.dart';
import 'package:milliyway_pos/feature/home/providers/home_provider.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: ThemeData(
          colorSchemeSeed: Colors.indigoAccent
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.dark(surface: Colors.indigo.withAlpha(100)),
        ),
        themeMode: ThemeMode.light,
      ),
    );
  }
}
