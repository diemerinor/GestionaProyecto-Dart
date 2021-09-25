import 'package:flutter/gestures.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/agregararchivo.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

import 'dart:io';
import 'package:dio/dio.dart';

import 'dart:async';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

String nombreproyecto;

class ImportarArchivo extends StatefulWidget {
  final String idproyecto;
  final String nombreproyecto;

  const ImportarArchivo({Key key, this.idproyecto, this.nombreproyecto})
      : super(key: key);
  @override
  _ImportarArchivoState createState() => _ImportarArchivoState();
}

class _ImportarArchivoState extends State<ImportarArchivo> {
  String url2 = 'http://gestionaproyecto.com/phpproyectotitulo/getArchivos.php';
  String mensaje = "Cargando archivos...";
  Future<List> getEventos() async {
    final response = await http
        .post(Uri.parse(url2), body: {"idproyecto": widget.idproyecto});
    var datauser = json.decode(response.body);
    if (datauser == null) {
      mensaje = "No existen archivos";
    }
    return datauser;
  }

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
        "name": "rajika",
        "age": 22,
        "file": await MultipartFile.fromFile(filePath.path, filename: fileName),
      });

      Response response = await Dio().post(
          "http://gestionaproyecto.com/phpproyectotitulo/uploads.php",
          data: formData);
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
          title: new Text("Archivos"),
          backgroundColor: colorappbar,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: Icon(
                  Icons.file_upload,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AgregarArchivo(
                                idproyecto: widget.idproyecto,
                              )));
                  // do something
                },
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: new FutureBuilder<List>(
                  future: getEventos(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Text(
                                    "Archivos del proyecto:\n" +
                                        widget.nombreproyecto,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              // Container(
                              //     width:
                              //         MediaQuery.of(context).size.width * 0.15,
                              //     height:
                              //         MediaQuery.of(context).size.width * 0.15,
                              //     child: GestureDetector(
                              //       onTap: () {
                              //         Navigator.push(
                              //             context,
                              //             MaterialPageRoute(
                              //                 builder: (context) =>
                              //                     ));

                              //         //getFile();
                              //       },
                              //       child: Card(
                              //         color: colorappbar,
                              //         child: Icon(
                              //           Icons.add,
                              //           color: Colors.white,
                              //         ),
                              //       ),
                              //     )),
                            ],
                          ),
                          Expanded(
                            child: new listararchivos(
                              list: snapshot.data,
                              idproyecto: widget.idproyecto,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return new Center(
                          child: Text(
                        mensaje,
                        style: TextStyle(fontSize: 25),
                      ));
                    }
                  }),
            ),
          ],
        ));
  }
}

class listararchivos extends StatefulWidget {
  final List list;
  final String idproyecto;

  const listararchivos({Key key, this.list, this.idproyecto}) : super(key: key);
  @override
  _listararchivosState createState() => _listararchivosState();
}

class _listararchivosState extends State<listararchivos> {
  @override
  Widget build(BuildContext context) {
    return widget.list == null
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: widget.list == null ? 0 : widget.list.length,
            itemBuilder: (context, i) {
              return Column(
                children: [
                  GestureDetector(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: colorappbar,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new RichText(
                                text: new LinkTextSpan(
                                  url: '${widget.list[i]['rutaarchivo']}',
                                  text: '${widget.list[i]['nombrearchivo']}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            });
  }
}

class LinkTextSpan extends TextSpan {
  LinkTextSpan({TextStyle style, String url, String text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                launch(url);
              });
}
