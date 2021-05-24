import 'package:flutter/gestures.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/detalle.dart';
import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:http/http.dart' as http;

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

  Future<List> getEventos() async {
    final response = await http
        .post(Uri.parse(url2), body: {"idproyecto": widget.idproyecto});
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text("Importar archivos"),
          backgroundColor: colorappbar,
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
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  height:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: Card(
                                    color: colorappbar,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ))
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
                        child: new CircularProgressIndicator(),
                      );
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
                            height: MediaQuery.of(context).size.height * 0.05,
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
