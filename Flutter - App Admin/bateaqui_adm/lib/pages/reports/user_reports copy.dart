// UserReports.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../../services/UserPontosService.dart';

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
        title: Text('Ponto'),
      ),
      body: Column(
        children: [
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
            title: Text('Month'),
            subtitle: Text(
              "${selectedDate.month}/${selectedDate.year}",
            ),
            trailing: Icon(Icons.calendar_today),
            onTap: () => _selectDate(context),
          ),
          ElevatedButton(
            onPressed: _fetchData,
            child: Text('Fetch Data'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userPontoDataFiltered.length,
              itemBuilder: (context, index) {
                Timestamp timestamp = userPontoDataFiltered[index]['dateHour'];
                DateTime dateTime = timestamp.toDate();
                String formattedDate =
                    DateFormat('dd-MM-yyyy HH:mm').format(dateTime);

                return ListTile(
                  title: Text("Registro " + formattedDate),
                  subtitle:
                      Text("Email: ${userPontoDataFiltered[index]['email']}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
