import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:bateaqui_adm/services/UserPontosService.dart';
import 'package:go_router/go_router.dart';

class UserReportsCollective extends StatefulWidget {
  @override
  _UserReportsCollectiveState createState() => _UserReportsCollectiveState();
}

class _UserReportsCollectiveState extends State<UserReportsCollective> {
  UserPontosService _userPontosService = UserPontosService();
  List<Map<String, dynamic>> userPontoData = [];
  List<String> userEmails = [];

  void _fetchData() async {
    userPontoData = await _userPontosService.fetchUserPontoByEmailMonth(
        selectedDate.year, selectedDate.month);

    userEmails = List<String>.from(
        userPontoData.map((item) => item['email']).toSet().toList());

    setState(() {});
  }

  DateTime selectedDate = DateTime.now();

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

  void _showUserReports(String email, DateTime selectedDate) {
    GoRouter.of(context).go('/user-reports-details',
        extra: {'email': email, 'date': selectedDate});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relátorio Gerencial - Coletivo'),
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
          ListTile(
            title: Text('Mês/Ano:'),
            subtitle: Text(
              "${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}",
            ),
            trailing: Icon(Icons.calendar_today),
            onTap: () => _selectDate(context),
          ),
          ElevatedButton(
            onPressed: _fetchData,
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
          Expanded(
            child: ListView.builder(
              itemCount: userEmails.length,
              itemBuilder: (context, index) {
                String email = userEmails[index];
                return ListTile(
                  title: Text(email),
                  onTap: () => _showUserReports(email, selectedDate),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
