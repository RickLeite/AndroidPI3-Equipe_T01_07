import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bateaqui_adm/pages/home_page.dart';
import 'package:bateaqui_adm/pages/auth/login_page.dart';
import 'package:bateaqui_adm/pages/auth/register_page.dart';
import 'package:bateaqui_adm/pages/auth/forgot_password_page.dart';
import 'package:bateaqui_adm/pages/reports/user_reports.dart';
import 'package:bateaqui_adm/pages/reports/user_reports_admin.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bateaqui Adm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/home',
  routes: <RouteBase>[
    GoRoute(
      name: "/home",
      path: "/home",
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      name: "/login",
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: "/register",
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      name: "/forgot-password",
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
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
    )
  ],
);
