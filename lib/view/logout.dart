import 'package:flutter/material.dart';
import 'package:project3mobile/view/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Logout'),
      // ),
      body: Center(
        child: ElevatedButton(
          child: Text('Logout'),
          onPressed: () {
            _logout(context);
          },
        ),
      ),
    );
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _name, _token;
  @override
  void initState() {
    super.initState();
    _token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });
    _name = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("name") ?? "";
    });
  }

  void _logout(BuildContext context) async {
    try {
      // Menghapus token bearer dari penyimpanan lokal (misalnya, SharedPreferences)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Arahkan pengguna ke halaman login atau halaman awal aplikasi
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
      // Ganti '/login' dengan rute halaman login atau halaman awal Anda
    } catch (e) {
      // Tangani jika terjadi kesalahan saat logout
      print('Error during logout: $e');
      // Tampilkan pesan kesalahan atau lakukan tindakan yang sesuai
    }
  }
}
