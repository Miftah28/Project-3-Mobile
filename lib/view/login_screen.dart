import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project3mobile/view/dashboard_screen.dart';
import 'package:project3mobile/view/model/User.dart';
import 'package:http/http.dart' as myHttp;
import 'package:project3mobile/view/navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late Future<String> _name, _role, _token;

  @override
  void initState() {
    // TODO: implement initState
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

  checkToken(token, role) async {
    String tokenStr = await token;
    String roleStr = await role;
    if (tokenStr != "" &&
        (roleStr != "teacher" && roleStr != "instance" && roleStr != "super")) {
      Future.delayed(Duration(seconds: 1), () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Navigation()))
            .then((value) {
          setState(() {});
        });
      });
    }
  }

  Future login(username, password) async {
    User? user;
    Map<String, String> body = {"username": username, "password": password};
    final headers = {'Content-Type': 'application/json'};
    var response = await myHttp.post(
      // Uri.parse('http://10.0.141.1:8080/api/login'),
      Uri.parse('http://192.168.1.5:8080/api/login'),
      body: body,
    );
    if (response.statusCode == 500) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Username Atau Password salah")));
    } else {
      user = User.fromJson(json.decode(response.body));
      // print("presensi : " + response.body);
      saveUser(user.data.token, user.data.role, user.data.student.name);
    }
  }

  Future saveUser(token, role, name) async {
    try {
      final SharedPreferences pref = await _prefs;
      pref.setString("name", name);
      pref.setString("token", token);
      pref.setString("role", role);
      print("lewat sini");

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Navigation()))
          .then((value) {
        setState(() {});
      });
    } catch (err) {
      print("Error : " + err.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
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
              height: size.height * 0.4, //letak gambar ke atas atau bawah
            ),
            // Text("data"),
            // Text("data"),
            Form(
                child: Container(
              padding: const EdgeInsetsDirectional.symmetric(
                  vertical: BorderSide.strokeAlignCenter),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_outline_outlined),
                        labelText: "Username",
                        hintText: "Username",
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Password",
                        hintText: "Password",
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                            onPressed: null,
                            icon: Icon(Icons.remove_red_eye_sharp))),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: ElevatedButton(
                          onPressed: () {
                            login(
                                usernameController.text, passwordController.text);
                          },
                          child: Text("Login")),
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    )));
  }
}
