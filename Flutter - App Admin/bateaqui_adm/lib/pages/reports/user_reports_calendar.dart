// UserReportsCalendar.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/UserCalendarioService.dart';

class UserReportsCalendar extends StatefulWidget {
  @override
  _UserReportsCalendarState createState() => _UserReportsCalendarState();
}

class _UserReportsCalendarState extends State<UserReportsCalendar> {
  UserCalendarioService _userCalendarioService = UserCalendarioService();
  final _emailController = TextEditingController();
  List<Map<String, dynamic>> userCalendarData = [];

  void _fetchData() async {
    String email = _emailController.text;
    userCalendarData =
        await _userCalendarioService.fetchUserPontoByEmail(email);
    setState(() {});
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
          ElevatedButton(
            onPressed: _fetchData,
            child: Text('Fetch Data'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userCalendarData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Entrada " +
                          userCalendarData[index]['horario_Entrada']),
                      Text("Saida " + userCalendarData[index]['horario_Saida']),
                      Text("Field3 "),
                      Text("Field4 "),
                      Text("Field5 "),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
