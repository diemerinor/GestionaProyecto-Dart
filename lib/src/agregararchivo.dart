import 'package:flutter/gestures.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/importararchivos.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

import 'dart:io';
import 'package:dio/dio.dart';

import 'dart:async';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class AgregarArchivo extends StatefulWidget {
  final String idproyecto;
  const AgregarArchivo({Key key, this.idproyecto}) : super(key: key);

  @override
  _AgregarArchivoState createState() => _AgregarArchivoState();
}

class _AgregarArchivoState extends State<AgregarArchivo> {
  TextEditingController controllernombre = new TextEditingController();
  TextEditingController controllerdescripcion = new TextEditingController();
  File _file;
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  Future getFile() async {
    File file = await FilePicker.getFile();

    setState(() {
      _file = file;
    });
  }

  void _uploadFile(filePath) async {
    String fileName = basename(filePath.path);
    print("file base name:$fileName");

    try {
      FormData formData = new FormData.fromMap({
        "name": controllernombre.text,
        "idproyecto": widget.idproyecto,
        "file": await MultipartFile.fromFile(filePath.path, filename: fileName),
      });

      Response response = await Dio().post(
          "http://gestionaproyecto.com/phpproyectotitulo/uploads.php",
          data: formData);
      print("wenas");
      print("File upload response: $response");
      _showSnackBarMsg(response.data['message']);
    } catch (e) {
      print("expectation Caugch: $e");
    }
  }

  void _showSnackBarMsg(String msg) {
    _scaffoldstate.currentState.showSnackBar(new SnackBar(
      content: new Text(msg),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorappbar,
        title: Text("Importar archivo"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              children: [
                Text(
                  "Nombre archivo(*)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextFormField(
                  controller: controllernombre,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.file_copy,
                        color: Colors.black,
                      ),
                      hintText: 'Ingrese el nombre del archivo'),
                ),
                Padding(padding: EdgeInsets.only(top: 15)),
                Text(
                  "Seleccione archivo(*)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                RaisedButton(
                    child: Text("Seleccionar"),
                    onPressed: () {
                      getFile();
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: RaisedButton(
                      child: new Text(
                        "Subir archivo",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: colorappbar,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0)),
                      onPressed: () {
                        _uploadFile(_file);
                        Navigator.pop(context);
                        Navigator.pop(context);

                        //login();
                      },
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
