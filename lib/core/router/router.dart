import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:milliyway_pos/feature/home/presnetation/home_page.dart';
import 'package:milliyway_pos/feature/otp/presentation/otp_page.dart';
import 'package:milliyway_pos/feature/settings/presentation/settings_page.dart';

import '../../feature/main/presentation/main_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: "/",
  routes: [
    GoRoute(path: "/", builder: (context, state) => const OtpPage()),
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state, child) {
        return CupertinoPage(child: MainPage(
          key: state.pageKey,
          currentIndex: switch (state.uri.path) {
            final p when p.startsWith("/home") => 0,
            final p when p.startsWith("/settings") => 1,
            _ => 0,
          },
          child: child,
        ));
      },
      routes: [
        GoRoute(
          path: "/home",
          pageBuilder: (context, state) =>
              const CupertinoPage(child: HomePage()),
        ),
        GoRoute(
          path: "/settings",
          pageBuilder: (context, state) =>
              const CupertinoPage(child: SettingsPage()),
        ),
      ],
    ),
  ],
);
