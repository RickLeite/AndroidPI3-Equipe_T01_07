import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:go_router/go_router.dart';

class UserReports extends StatefulWidget {
  @override
  _UserReportsState createState() => _UserReportsState();
}

class _UserReportsState extends State<UserReports> {
  final _emailController = TextEditingController();
  List<Map<String, dynamic>> userPontoData = [];
  List<Map<String, dynamic>> userPontoDataFiltered = [];
  DateTime selectedDate = DateTime.now();

  void _showUserReports(String email, DateTime selectedDate) {
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(email.isEmpty ? 'Informe o email!' : 'Email inválido!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    GoRouter.of(context).go('/user-reports-details',
        extra: {'email': email, 'date': selectedDate});
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5, 1),
      lastDate: DateTime(DateTime.now().year + 5, 12),
      initialDate: selectedDate,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relátorio Gerencial - Individual'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).go('/home'),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Consultar Ponto',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
          ),
          ListTile(
            title: Text('Mês/Ano:'),
            subtitle: Text(
              "${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}",
            ),
            trailing: Icon(Icons.calendar_today),
            onTap: () => _selectDate(context),
          ),
          ElevatedButton(
            onPressed: () =>
                _showUserReports(_emailController.text, selectedDate),
            child: Text(
              'Relatório',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all<Color>(Colors.blue[700]!),
            ),
          ),
        ],
      ),
    );
  }
}
