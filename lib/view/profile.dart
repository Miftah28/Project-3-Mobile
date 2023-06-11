import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project3mobile/view/login_screen.dart';
import 'package:project3mobile/view/model/getProfile.dart';
import 'package:http/http.dart' as Http;

class Profile extends StatefulWidget {
  const Profile({super.key});

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

  Future getData() async {
    final Map<String, String> headres = {
      'Authorization': 'Bearer ' + await _token
    };
    var response = await Http.get(
        Uri.parse('http://192.168.1.5:8080/api/profile'),
        headers: headres);
    profile = GetProfile.fromJson(json.decode(response.body));
    profile!.data.forEach((element) {
      profiles.add(element);
    });
  }

  void _logout(BuildContext context) async {
    try {
      // Menghapus token bearer dari penyimpanan lokal (misalnya, SharedPreferences)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Arahkan pengguna ke halaman login atau halaman awal aplikasi
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginScreen()));
      // Ganti '/login' dengan rute halaman login atau halaman awal Anda
    } catch (e) {
      // Tangani jika terjadi kesalahan saat logout
      print('Error during logout: $e');
      // Tampilkan pesan kesalahan atau lakukan tindakan yang sesuai
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
                child: Expanded(
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
                                backgroundImage:
                                    // AssetImage(profiles[index].photo),
                                    NetworkImage(profiles[index].photo)),
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
                                  ]),
                              child: ListTile(
                                title: const Text("Name"),
                                subtitle: Text(profiles[index].name),
                                leading: Icon(CupertinoIcons.person),
                                trailing: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.grey,
                                ),
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
                                  ]),
                              child: ListTile(
                                title: const Text("Whatssapp"),
                                subtitle: Text(profiles[index].phone),
                                leading: Icon(CupertinoIcons.phone_circle),
                                trailing: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.grey,
                                ),
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
                                  ]),
                              child: ListTile(
                                title: const Text("Alamat"),
                                subtitle: Text(profiles[index].address),
                                leading: Icon(CupertinoIcons.location_circle),
                                trailing: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.grey,
                                ),
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
                                  ]),
                              child: ListTile(
                                title: const Text("Email"),
                                subtitle: Text(profiles[index].email),
                                leading: Icon(CupertinoIcons.mail),
                                trailing: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.grey,
                                ),
                                tileColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              child: Text('Logout'),
                              onPressed: () {
                                _logout(context);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
