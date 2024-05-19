import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:bateaqui_adm/pages/home_page.dart';
import 'package:bateaqui_adm/pages/auth/login_page.dart';
import 'package:bateaqui_adm/pages/auth/register_page.dart';
import 'package:bateaqui_adm/pages/auth/forgot_password_page.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:bateaqui_adm/pages/home_page.dart';

void main() {
  runApp(const MyApp());
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
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/home',
  routes: <RouteBase>[
    GoRoute(
      name: "/home",
      path: "/home",
      builder: (context, state) {
        return const HomePage();
      },
    ),
    GoRoute(
      name: "/login",
      path: '/login',
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      name: "/register",
      path: '/register',
      builder: (context, state) {
        return const RegisterPage();
      },
    ),
    GoRoute(
      name: "/forgot-password",
      path: '/forgot-password',
      builder: (context, state) {
        return const ForgotPasswordPage();
      },
    )
  ],
);
