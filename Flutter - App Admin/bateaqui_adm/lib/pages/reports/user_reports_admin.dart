// UserReportsAdmin.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:bateaqui_adm/services/UserPontosService.dart';
import 'package:go_router/go_router.dart';
import 'package:bateaqui_adm/models/user.dart';

class UserReportsAdmin extends StatefulWidget {
  @override
  _UserReportsAdminState createState() => _UserReportsAdminState();
}

class _UserReportsAdminState extends State<UserReportsAdmin> {
  UserPontosService _userPontosService = UserPontosService();
  final _emailController = TextEditingController();
  Map<String, dynamic> userInfoData = {};
  DateTime selectedDate = DateTime.now();

  Future<void> _fetchInfoUser() async {
    String email = _emailController.text;
    userInfoData = await _userPontosService.fetchUserInfoByEmail(email);
    print(userInfoData);
    setState(() {});
  }

  Future<void> _insertData() async {
    await _fetchInfoUser();
    Timestamp dateHourT = Timestamp.fromDate(selectedDate);

    UserPonto userPontoDataMapp = UserPonto(
      dateHour: dateHourT,
      email: userInfoData['email'] ?? '',
      identifier: userInfoData['identifier'] ?? '',
      name: userInfoData['name'] ?? '',
    );

    await _userPontosService.inserUserPonto(userPontoDataMapp);
    print("Inserido");
    setState(() {});
  }

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDateTimePicker(
      context: context,
      initialDate: selectedDate,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      print('Selected date: $selectedDate');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ponto'),
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
              'Relátorio Gerencial',
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Data:'),
                Text(
                  DateFormat('dd/MM/yyyy : HH:mm  ').format(selectedDate),
                ),
              ],
            ),
            trailing: Icon(Icons.calendar_today),
            onTap: () => _selectDate(context),
          ),
          ElevatedButton(
            onPressed: _insertData,
            child: Text(
              'Inserir',
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
