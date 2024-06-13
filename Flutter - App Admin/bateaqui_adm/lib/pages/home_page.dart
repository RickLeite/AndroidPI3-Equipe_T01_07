import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Inicial'),
        centerTitle: true, // Centraliza o título
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.start, // Alinha os widgets no topo
          children: <Widget>[
            Spacer(flex: 2), // Espaço flexível para ajustar a posição vertical
            Image.asset(
              'assets/images/logoAdm.png', // Caminho para a logo
              height: 120.0, // Defina a altura desejada para a logo
            ),
            const SizedBox(height: 95), // Espaço entre a logo e os botões
            ElevatedButton(
              onPressed: () {
                context.go('/user-reports-admin');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightBlue[600], // Cor do texto branco
              ),
              child: const Text('Inserir Ponto'),
            ),
            const SizedBox(height: 20), // Espaço entre os botões
            ElevatedButton(
              onPressed: () {
                context.go('/user-reports');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightBlue[600], // Cor do texto branco
              ),
              child: const Text('Relátorio Gerencial Individual'),
            ),
            const SizedBox(height: 20), // Espaço entre os botões
            ElevatedButton(
              onPressed: () {
                context.go('/user-reports-collective');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightBlue[600], // Cor do texto branco
              ),
              child: const Text('Relátorio Gerencial Coletivo'),
            ),
            Spacer(flex: 5), // Espaço flexível para ajustar a posição vertical
          ],
        ),
      ),
    );
  }
}
