import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                context.go('/login');
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/register');
              },
              child: const Text('Registro'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/forgot-password');
              },
              child: const Text('Esqueci Senha'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/user-reports');
              },
              child: const Text('user-reports'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/user-reports-admin');
              },
              child: const Text('user-reports-admin'),
            ),
          ],
        ),
      ),
    );
  }
}
