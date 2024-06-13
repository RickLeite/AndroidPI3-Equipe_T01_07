import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:bateaqui_adm/pages/home_page.dart';
import 'package:bateaqui_adm/pages/auth/login_page.dart';
import 'package:bateaqui_adm/pages/reports/user_reports.dart';
import 'package:bateaqui_adm/pages/reports/user_reports_admin.dart';
import 'package:bateaqui_adm/pages/reports/user_report_details.dart';
import 'package:bateaqui_adm/pages/reports/user_reports_collective.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }

  bool isLoggedIn = false;

  try {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  } catch (e) {
    print('Failed to load shared preferences: $e');
  }

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bateaqui Adm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router(isLoggedIn),
      debugShowCheckedModeBanner: false,
    );
  }

  GoRouter _router(bool isLoggedIn) {
    return GoRouter(
      initialLocation: isLoggedIn ? '/home' : '/login',
      routes: <RouteBase>[
        GoRoute(
          name: "/login",
          path: "/login",
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          name: "/home",
          path: "/home",
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          name: "user-reports",
          path: '/user-reports',
          builder: (context, state) => UserReports(),
        ),
        GoRoute(
          name: "user-reports-admin",
          path: '/user-reports-admin',
          builder: (context, state) => UserReportsAdmin(),
        ),
        GoRoute(
          name: "user-reports-collective",
          path: '/user-reports-collective',
          builder: (context, state) => UserReportsCollective(),
        ),
        GoRoute(
          path: '/user-reports-details',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;

            final email = extra?['email'] as String? ?? 'não-encontrado';
            final date = extra?['date'] as DateTime? ?? DateTime.now();

            return UserReportsDetails(email: email, date: date);
          },
        ),
      ],
    );
  }
}
