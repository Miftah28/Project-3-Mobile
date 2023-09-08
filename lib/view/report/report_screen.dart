import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:project3mobile/view/report/uploadreport.dart';
import 'package:project3mobile/view/model/getReport.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as Http;
import 'package:project3mobile/view/navigator.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _name, _token;
  GetReport? reports;
  List<Datum> report = [];

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

    var response =
        // await Http.get(Uri.parse('http://pkmsmkteladankertasemaya.com/api/report'),
        await Http.get(Uri.parse('http://192.168.17.10:8080/api/report'),
            headers: headres);

    reports = GetReport.fromJson(json.decode(response.body));
    reports!.data.forEach((element) {
      report.add(element);
    });
  }

  Future<void> _deleteReport(int reportId) async {
    final Map<String, String> headers = {
      'Authorization': 'Bearer ' + await _token
    };

    try {
      final response = await Http.delete(
        Uri.parse('http://192.168.17.10:8080/api/report/$reportId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Jurnal berhasil dihapus dari server
        // Anda dapat memperbarui daftar jurnal atau memberikan umpan balik kepada pengguna di sini.
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Data Berhasil dihapus')));
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Navigation()))
            .then((value) {
          setState(() {});
        });
      } else {
        // Gagal menghapus jurnal
        // Tindakan yang sesuai seperti menampilkan pesan kesalahan.
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Data Gagal dihapus')));
      }
    } catch (e) {
      // Tangani kesalahan yang mungkin terjadi selama permintaan HTTP.
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Laporan Magang')),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
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
                                  style: TextStyle(fontSize: 18));
                            } else {
                              return Text("-", style: TextStyle(fontSize: 18));
                            }
                          }
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: report.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            leading: Text(DateFormat('dd-MM-yyyy')
                                .format(DateTime.parse(report[index].tanggal))),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(report[index].description,
                                          style: TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit), // Icon untuk edit
                                  onPressed: () {
                                    // Tambahkan logika untuk mengedit item di sini
                                    // Anda dapat menampilkan dialog atau halaman edit.
                                  },
                                  color: Colors.yellow,
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Konfirmasi Hapus"),
                                          content: Text(
                                              "Apakah Anda yakin ingin menghapus jurnal ini?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Batal"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Panggil fungsi _deleteJournal dengan ID jurnal yang akan dihapus
                                                _deleteReport(report[index].id);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Hapus"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  color: Colors.red,
                                ),
                              ],
                            ),
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
              .push(MaterialPageRoute(builder: (context) => PDFUploadScreen()))
              .then((value) {
            setState(() {});
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
