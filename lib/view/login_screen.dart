import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project3mobile/view/attendance/dashboard_screen.dart';
import 'package:project3mobile/view/model/User.dart';
import 'package:http/http.dart' as myHttp;
import 'package:project3mobile/view/navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late Future<String> _name, _role, _token;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });
    _name = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("name") ?? "";
    });
    _role = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("role") ?? "";
    });
    checkToken(_token, _role);
  }

  void checkToken(Future<String> token, Future<String> role) async {
    String tokenStr = await token;
    String roleStr = await role;
    if (tokenStr != "" &&
        (roleStr != "teacher" && roleStr != "instance" && roleStr != "super")) {
      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Navigation()),
        );
      });
    }
  }

  Future<void> login(String username, String password) async {
    User? user;
    Map<String, String> body = {
      "username": username,
      "password": password,
    };
    final headers = {'Content-Type': 'application/json'};

    try {
      var response = await myHttp.post(
        // Uri.parse('http://192.168.191.249:8080/api/login'),
        Uri.parse('http://pkmsmkteladankertasemaya.com/api/login'),
        body: json.encode(body),
        headers: headers,
      );

      if (response.statusCode == 200) {
        user = User.fromJson(json.decode(response.body));
        saveUser(user.data.token, user.data.role, user.data.student.name);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Username atau Password salah")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan. Silakan coba lagi.")),
      );
    }
  }

  Future<void> saveUser(String token, String role, String name) async {
    try {
      final SharedPreferences pref = await _prefs;
      pref.setString("name", name);
      pref.setString("token", token);
      pref.setString("role", role);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Navigation()),
      );
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage("lib/assets/images/logo.png"),
                  height: size.height * 0.4,
                ),
                Form(
                  child: Container(
                    padding: const EdgeInsetsDirectional.symmetric(
                      vertical: BorderSide.strokeAlignCenter,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_outline_outlined),
                            labelText: "Username",
                            hintText: "Username",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            labelText: "Password",
                            hintText: "Password",
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              icon: Icon(_showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                login(
                                  usernameController.text,
                                  passwordController.text,
                                );
                              },
                              child: Text("Login"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
