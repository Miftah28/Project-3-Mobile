import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project3mobile/view/journal/uploadjournal.dart';
import 'package:project3mobile/view/model/getJournal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as Http;
import 'package:project3mobile/view/navigator.dart';

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
        // Uri.parse('http://pkmsmkteladankertasemaya.com/api/journal'),
        Uri.parse('http://192.168.17.10:8080/api/journal'),
        headers: headres);

    journal = GetJournal.fromJson(json.decode(response.body));
    // journals.clear();
    journal!.data.forEach((element) {
      journals.add(element);
    });
  }

  Future<void> _deleteJournal(int journalId) async {
    final Map<String, String> headers = {
      'Authorization': 'Bearer ' + await _token
    };

    try {
      final response = await Http.delete(
        Uri.parse('http://192.168.17.10:8080/api/journal/$journalId'),
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
                          leading: Text(DateFormat('dd-MM-yyyy')
                              .format(DateTime.parse(journals[index].tanggal))),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Expanded(
                              //   child: Column(
                              //     children: [
                              //       Text(
                              //         journals[index].listJurnals,
                              //         style: TextStyle(fontSize: 18),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              Text(
                                journals[index].validationJurnal,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.greenAccent,
                                ),
                              ),
                              if (journals[index].validationJurnal ==
                                  'proses') // Tampilkan tombol Edit dan Hapus jika validationJurnal == 'prosess'
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        // Tambahkan logika edit di sini
                                        // Misalnya, buka halaman edit jurnal
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
                                                    _deleteJournal(
                                                        journals[index].id);
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
                                    IconButton(
                                      icon: Icon(Icons.info), // Tombol "Detail"
                                      onPressed: () {
                                        // Tampilkan modal dengan data detail
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              // Isi modal dengan data detail jurnal
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Detail Jurnal',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Tanggal: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(journals[index].tanggal))}',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    'Jurnal: ${journals[index].listJurnals}',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  // Tambahkan data detail lainnya di sini
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      color: Colors.lightBlue,
                                    ),
                                  ],
                                ),
                              if (journals[index].validationJurnal == 'tolak' ||
                                  journals[index].validationJurnal == 'terima')
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.info), // Tombol "Detail"
                                      onPressed: () {
                                        // Tampilkan modal dengan data detail
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              // Isi modal dengan data detail jurnal
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Detail Jurnal',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Tanggal: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(journals[index].tanggal))}',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(
                                                    'Jurnal: ${journals[index].listJurnals}',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  // Tambahkan data detail lainnya di sini
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      color: Colors.lightBlue,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    )),
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
