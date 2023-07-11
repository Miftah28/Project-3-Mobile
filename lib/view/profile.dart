import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project3mobile/view/login_screen.dart';
import 'package:project3mobile/view/model/getProfile.dart';
import 'package:http/http.dart' as Http;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _token;
  GetProfile? profile;
  List<Datum> profiles = [];

  @override
  void initState() {
    super.initState();
    _token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });
  }

  Future<void> getData() async {
    final Map<String, String> headers = {
      'Authorization': 'Bearer ' + (await _token)
    };
    final response = await Http.get(
      Uri.parse('http://pkmsmkteladankertasemaya.com/api/profile'),
      // Uri.parse('http://192.168.191.249:8080/api/profile'),
      headers: headers,
    );
    profile = GetProfile.fromJson(json.decode(response.body));
    profile!.data.forEach((element) {
      profiles.add(element);
    });
  }

  void _logout(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: profiles.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(
                            // "http://192.168.191.249:8080/storage/${profiles[index].photo}",
                            "http://pkmsmkteladankertasemaya.com/storage/${profiles[index].photo}",
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(8, 5),
                                color: Colors.deepOrange.withOpacity(.2),
                                spreadRadius: 2,
                                blurRadius: 18,
                              )
                            ],
                          ),
                          child: ListTile(
                            title: const Text("Name"),
                            subtitle: Text(profiles[index].name),
                            leading: const Icon(CupertinoIcons.person),
                            tileColor: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(8, 5),
                                color: Colors.deepOrange.withOpacity(.2),
                                spreadRadius: 2,
                                blurRadius: 18,
                              )
                            ],
                          ),
                          child: ListTile(
                            title: const Text("Whatsapp"),
                            subtitle: Text(profiles[index].phone),
                            leading: const Icon(CupertinoIcons.phone_circle),
                            tileColor: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(8, 5),
                                color: Colors.deepOrange.withOpacity(.2),
                                spreadRadius: 2,
                                blurRadius: 18,
                              )
                            ],
                          ),
                          child: ListTile(
                            title: const Text("Alamat"),
                            subtitle: Text(profiles[index].address),
                            leading: const Icon(CupertinoIcons.location_circle),
                            tileColor: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(8, 5),
                                color: Colors.deepOrange.withOpacity(.2),
                                spreadRadius: 2,
                                blurRadius: 18,
                              )
                            ],
                          ),
                          child: ListTile(
                            title: const Text("Email"),
                            subtitle: Text(profiles[index].email),
                            leading: const Icon(CupertinoIcons.mail),
                            tileColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          child: const Text('Logout'),
                          onPressed: () {
                            _logout(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
