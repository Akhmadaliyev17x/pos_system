import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:milliyway_pos/feature/home/presnetation/home_page.dart';
import 'package:milliyway_pos/feature/otp/presentation/otp_page.dart';

final GoRouter router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(path: "/", builder: (context, state) => const OtpPage()),
    GoRoute(path: "/home" , pageBuilder: (context , state) => const CupertinoPage(child: HomePage())),
  ],
);
