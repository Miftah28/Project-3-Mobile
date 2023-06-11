import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PDFUploadScreen extends StatefulWidget {
  @override
  _PDFUploadScreenState createState() => _PDFUploadScreenState();
}

class _PDFUploadScreenState extends State<PDFUploadScreen> {
   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _name, _token;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String txtNama = "";

  var txtdescription = TextEditingController();
  var txtFilePicker = TextEditingController();

  File? filePickerVal;
  File? _selectedFile;

  void _selectPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

//fungsi untuk select file
  selectFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        txtFilePicker.text = result.files.single.name;
        filePickerVal = File(result.files.single.path.toString());
      });
    } else {
      // User canceled the picker
    }
  }

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
    final String description = txtdescription.text;

    try {
      //post date
      final Map<String, String> headres = {
        'Authorization': 'Bearer ' + await _token
      };
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://192.168.1.5:8080/api/report'));

      request.headers.addAll(headres);
      request.fields['description'] = description;

      request.files.add(http.MultipartFile('file',
          filePickerVal!.readAsBytes().asStream(), filePickerVal!.lengthSync(),
          filename: filePickerVal!.path.split("/").last));

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
                    Text("File berhasil diupload"),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    //
                    Navigator.of(context, rootNavigator: false).pop();
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
          title: const Text("Test Upload File"),
          backgroundColor: Colors.orange,
        ),
        body: Form(
            key: _formKey,
            child: ListView(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    key: Key(txtNama),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama file harus diisi';
                      } else {
                        return null;
                      }
                    },
                    controller: txtdescription,
                    onSaved: (String? val) {
                      txtdescription.text = val!;
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
                      hintText: 'Description',
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                    style: const TextStyle(fontSize: 16.0)),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Browse File", style: TextStyle(fontSize: 16.0)),
              ),
              buildFilePicker(),
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

//membuat input browse file
  Widget buildFilePicker() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
                readOnly: true,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'File harus diupload';
                  } else {
                    return null;
                  }
                },
                controller: txtFilePicker,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      borderSide: BorderSide(color: Colors.white, width: 2)),
                  hintText: 'Upload File',
                  contentPadding: EdgeInsets.all(10.0),
                ),
                style: const TextStyle(fontSize: 16.0)),
          ),
          const SizedBox(width: 5),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.upload_file,
              color: Colors.white,
              size: 24.0,
            ),
            label: const Text('Pilih File', style: TextStyle(fontSize: 16.0)),
            onPressed: () {
              selectFile();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue,
              minimumSize: const Size(122, 48),
              maximumSize: const Size(122, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
