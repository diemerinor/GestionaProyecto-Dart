//import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/detalle.dart';
import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'detallecontacto.dart';

class ListarUsCargo extends StatefulWidget {
  final String idproyecto;
  final String idcargo;

  ListarUsCargo({Key key, this.idproyecto, this.idcargo}) : super(key: key);
  @override
  _ListarUsCargoState createState() => _ListarUsCargoState();
}

class _ListarUsCargoState extends State<ListarUsCargo> {
  String url2 =
      'http://gestionaproyecto.com/phpproyectotitulo/getUsuarioCargo.php';
  List info = [];
  List nombresfiltrados = [];
  List info2 = [];

  Future<List> getTrabajadores() async {
    print(widget.idcargo);
    final response =
        await http.post(Uri.parse(url2), body: {"idcargo": widget.idcargo});
    var datauser = json.decode(response.body);
    int cantidad = datauser.length;

    return datauser;
  }

  @override
  void initState() {
    super.initState();
    getTrabajadores();
  }

  void _nombrefiltrados(value) {
    print(value);

    print(info2[0]['nombreusuario']);

    print("aki hay $nombresfiltrados");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text("Participantes"),
          backgroundColor: colorappbar,
        ),
        backgroundColor: colorfondo,
        body: Column(
          children: [
            Expanded(
              child: new FutureBuilder<List>(
                  future: getTrabajadores(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? new listatrabaj(
                            list: snapshot.data,
                            idcargo: widget.idcargo,
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
  final String idcargo;
  listatrabaj({this.list, this.idcargo});
  @override
  _listatrabajState createState() => _listatrabajState();
}

class _listatrabajState extends State<listatrabaj> {
  final Controller2 = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return widget.list == null
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Usuarios con el\ncargo de " + widget.list[0]['nombrecargo'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: new ListView.builder(
                  itemCount: widget.list == null ? 0 : widget.list.length,
                  itemBuilder: (context, i) {
                    return new Container(
                      padding: const EdgeInsets.all(4.0),
                      child: new GestureDetector(
                          onTap: () => Navigator.of(context).push(
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new DetallesContacto(
                                          list: widget.list,
                                          index: i,
                                        )),
                              ),
                          child: Column(
                            children: [
                              if (widget.list[i]['idusuario'] != widget.idcargo)
                                Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: new Row(children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            child: new Text(
                                              widget.list[i]['nombreusuario'] +
                                                  " " +
                                                  widget.list[i]['apellidos'],
                                              style: TextStyle(fontSize: 18.0),
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
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
                            ],
                          )),
                    );
                  },
                ),
              ),
            ],
          );
  }
}
