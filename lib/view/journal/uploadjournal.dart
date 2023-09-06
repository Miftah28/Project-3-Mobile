import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:project3mobile/view/journal/journal_screen.dart';
import 'package:project3mobile/view/navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadJournal extends StatefulWidget {
  @override
  _UploadJournalState createState() => _UploadJournalState();
}

class _UploadJournalState extends State<UploadJournal> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _token;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String txtlistjournals = "";

  var txtlistjournal = TextEditingController();

//fungsi untuk validasi dan simpan
  void _validateInputs() {
    if (_formKey.currentState!.validate()) {
      //If all data are correct then save data to out variables
      _formKey.currentState!.save();
      simpan();
    }
  }

  void initState() {
    super.initState();
    _token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });
  }

  simpan() async {
    final String listjournal = txtlistjournal.text;

    try {
      //post date
      final Map<String, String> headres = {
        'Authorization': 'Bearer ' + await _token
      };
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://192.168.17.10:8080/api/journal'));
      // 'POST', Uri.parse('http://pkmsmkteladankertasemaya.com/api/journal'));

      request.headers.addAll(headres);
      request.fields['list_jurnals'] = listjournal;

      var res = await request.send();
      var responseBytes = await res.stream.toBytes();
      var responseString = utf8.decode(responseBytes);

      //debug
      debugPrint("response code: " + res.statusCode.toString());
      debugPrint("response: " + responseString.toString());

      final dataDecode = jsonDecode(responseString);
      debugPrint(dataDecode.toString());

      if (res.statusCode == 200) {
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Informasi'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text("Berhasil diupload"),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    //
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => Navigation()))
                        .then((value) {
                      setState(() {});
                    });
                  },
                ),
              ],
            );
          },
        );
      } else {}
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Upload List Kerjaan harian"),
          backgroundColor: Colors.orange,
        ),
        body: Form(
            key: _formKey,
            child: ListView(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    maxLines: 10,
                    key: Key(txtlistjournals),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Harus diisi';
                      } else {
                        return null;
                      }
                    },
                    controller: txtlistjournal,
                    onSaved: (String? val) {
                      txtlistjournal.text = val!;
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2)),
                      hintText: 'List Kerjaan Hari ini',
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                    style: const TextStyle(fontSize: 16.0)),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 32.0,
                  ),
                  label: const Text('SIMPAN', style: TextStyle(fontSize: 18.0)),
                  onPressed: () {
                    _validateInputs();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent,
                    minimumSize: const Size(115, 55),
                    maximumSize: const Size(115, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              )
            ])));
  }
}
