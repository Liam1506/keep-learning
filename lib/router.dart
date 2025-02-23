import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keep_learning/Data/Paywall/paywallManager.dart';
import 'package:keep_learning/Views/addSession.dart';
import 'package:keep_learning/Views/dateInfo.dart';
import 'package:keep_learning/Views/home.dart';
import 'package:keep_learning/Views/settings.dart';
import 'package:keep_learning/Views/timer.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => PaywallManager()),
    GoRoute(path: '/settings', builder: (context, state) => Settngs()),

    GoRoute(path: '/addSession', builder: (context, state) => AddSession()),
    GoRoute(
      path: '/timer',
      builder: (context, state) {
        final sessionKey = state.uri.queryParameters['sessionKey']!;
        return Timer(sessionKey: sessionKey);
      },
    ),
    GoRoute(
      path: '/dateInfo',
      builder: (context, state) {
        final dateInt = state.uri.queryParameters['dateInt']!;
        return Dateinfo(dateInt: int.parse(dateInt));
      },
    ),
  ],
);
