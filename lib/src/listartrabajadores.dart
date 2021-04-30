import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/detalle.dart';
import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

class ListarTrabajadores extends StatefulWidget {
  final String idproyecto;
  final String idusuario;

  ListarTrabajadores({Key key, this.idproyecto, this.idusuario})
      : super(key: key);
  @override
  _ListarTrabajadoresState createState() => _ListarTrabajadoresState();
}

class _ListarTrabajadoresState extends State<ListarTrabajadores> {
  String url2 =
      'http://gestionaproyecto.com/phpproyectotitulo/getParticipantes.php';

  Future<List> getTrabajadores() async {
    final response = await http
        .post(Uri.parse(url2), body: {"idproyecto": widget.idproyecto});
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text("Participantes"),
          backgroundColor: colorappbar,
        ),
        body: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     "Participantes del proyecto",
            //     textAlign: TextAlign.center,
            //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            //   ),
            // ),
            Divider(),
            Expanded(
              child: new FutureBuilder<List>(
                  future: getTrabajadores(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? new listatrabaj(
                            list: snapshot.data,
                            idusuario: widget.idusuario,
                          )
                        : new Center(
                            child: new CircularProgressIndicator(),
                          );
                  }),
            ),
          ],
        ));
  }
}

class listatrabaj extends StatefulWidget {
  final List list;
  final String idusuario;
  listatrabaj({this.list, this.idusuario});
  @override
  _listatrabajState createState() => _listatrabajState();
}

class _listatrabajState extends State<listatrabaj> {
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: widget.list == null ? 0 : widget.list.length,
      itemBuilder: (context, i) {
        return new Container(
          padding: const EdgeInsets.all(4.0),
          child: new GestureDetector(
              onTap: () => Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new Detalle(
                              list: widget.list,
                              index: i,
                            )),
                  ),
              child: Column(
                children: [
                  if (widget.list[i]['idusuario'] != widget.idusuario)
                    Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Row(children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: new Text(
                                  widget.list[i]['nombreusuario'] +
                                      " " +
                                      widget.list[i]['apellidos'],
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(
                                      Icons.edit,
                                      color: Colors.red,
                                    ),
                                    Icon(
                                      Icons.verified_user_outlined,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                            ])),
                        Divider(),
                      ],
                    )
                  else if (widget.list.length == 1)
                    Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "No hay más \nparticipantes en el proyecto",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            ),
                            RaisedButton(
                              child: Text("Invita a tus contactos"),
                              color: Colors.red,
                              textColor: Colors.white,
                              onPressed: () {},
                            )
                          ]),
                    ),
                ],
              )),
        );
      },
    );
  }
}
