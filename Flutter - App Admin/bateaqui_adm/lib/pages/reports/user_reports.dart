import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:bateaqui_adm/services/UserPontosService.dart';
import 'package:go_router/go_router.dart';

class UserReports extends StatefulWidget {
  @override
  _UserReportsState createState() => _UserReportsState();
}

class _UserReportsState extends State<UserReports> {
  UserPontosService _userPontosService = UserPontosService();
  final _emailController = TextEditingController();
  List<Map<String, dynamic>> userPontoData = [];
  List<Map<String, dynamic>> userPontoDataFiltered = [];
  DateTime selectedDate = DateTime.now();

  void _fetchData() async {
    String email = _emailController.text;
    userPontoData = await _userPontosService.fetchUserPontoByEmailMonth(
        selectedDate.year, selectedDate.month);

    userPontoDataFiltered =
        userPontoData.where((item) => item['email'] == email).toList();
    setState(() {});
  }

  void _showUserReports(String email, DateTime selectedDate) {
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
          Padding(
            padding: const EdgeInsets.all(8.0),
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
