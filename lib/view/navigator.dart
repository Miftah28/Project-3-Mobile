import 'package:flutter/material.dart';
import 'package:project3mobile/view/attendance/dashboard_screen.dart';
import 'package:project3mobile/view/journal/journal_screen.dart';
import 'package:project3mobile/view/login_screen.dart';
import 'package:project3mobile/view/report/report_screen.dart';
import 'package:project3mobile/view/profile.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    AttendanceScreen(),
    Jurnal(),
    ReportScreen(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_alarm),
            label: 'Presensi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Jurnal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'profie',
          ),
        ],
        backgroundColor: Colors.orange,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        onTap: _onItemTapped,
        useLegacyColorScheme: false,
      ),
    );
  }
}
