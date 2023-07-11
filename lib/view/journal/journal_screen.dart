import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project3mobile/view/journal/uploadjournal.dart';
import 'package:project3mobile/view/model/getJournal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as Http;

class Jurnal extends StatefulWidget {
  const Jurnal({Key? key}) : super(key: key);

  @override
  State<Jurnal> createState() => _JurnalState();
}

class _JurnalState extends State<Jurnal> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _name, _token;
  GetJournal? journal;
  List<Datum> journals = [];

  @override
  void initState() {
    super.initState();
    _token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });
    super.initState();
    _name = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("name") ?? "";
    });
  }

  Future getData() async {
    final Map<String, String> headres = {
      'Authorization': 'Bearer ' + await _token
    };

    var response = await Http.get(
        Uri.parse('http://pkmsmkteladankertasemaya.com/api/journal'),
        // Uri.parse('http://192.168.191.249:8080/api/journal'),
        headers: headres);

    journal = GetJournal.fromJson(json.decode(response.body));
    // journals.clear();
    journal!.data.forEach((element) {
      journals.add(element);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('List Kerjaan Harian')),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return SafeArea(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                        future: _name,
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else {
                            if (snapshot.hasData) {
                              print(snapshot.data);
                              return Text(snapshot.data!,
                                  style: const TextStyle(fontSize: 18));
                            } else {
                              return const Text("-",
                                  style: TextStyle(fontSize: 18));
                            }
                          }
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: journals.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            leading: Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(journals[index].tanggal))),
                            title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          journals[index].listJurnals,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(journals[index].validationJurnal,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.greenAccent)),
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => UploadJournal()))
              .then((value) {
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
