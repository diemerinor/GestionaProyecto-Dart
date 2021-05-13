import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/gestionarproyecto.dart';
import 'package:gestionaproyecto/src/listartrabajadores.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:http/http.dart' as http;
import 'package:expansion_tile_card/expansion_tile_card.dart';

import 'dart:async';
import 'dart:convert';

int cantidadtrabajadores;
String mensajerrhh;

class GestionRRHH extends StatefulWidget {
  final String idproyecto;
  final String idusuario;
  GestionRRHH({this.idproyecto, this.idusuario});
  @override
  _GestionRRHHState createState() => _GestionRRHHState();
}

class _GestionRRHHState extends State<GestionRRHH> {
  @override
  void initState() {
    super.initState();
    mensajerrhh = "Cargando cargos";
  }

  String url2 =
      'http://gestionaproyecto.com/phpproyectotitulo/getParticipantes.php';
  String url3 = 'http://gestionaproyecto.com/phpproyectotitulo/getCargos.php';

  int indiceproyecto;
  Future<List> getTrabajadores() async {
    final response = await http
        .post(Uri.parse(url2), body: {"idproyecto": widget.idproyecto});
    var datauser = json.decode(response.body);

    int auxseccion = 0;
    int largodatauser = datauser.length;

    cantidadtrabajadores = largodatauser;
    //cantidadtrabajadores--;
    return datauser;
  }

  Future<List> getCargos() async {
    final response = await http
        .post(Uri.parse(url3), body: {"idproyecto": widget.idproyecto});
    var datauser = json.decode(response.body);
    if (datauser == null) {
      mensajerrhh = "No existen cargos en el proyecto";
    } else {
      mensajerrhh = '';
    }
    print(datauser);
    return datauser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Gestión RRHH"),
          backgroundColor: colorappbar,
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                children: [
                  Expanded(
                    child: new FutureBuilder<List>(
                        future: getTrabajadores(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          return snapshot.hasData
                              ? new detallesrrhh(
                                  list: snapshot.data,
                                  idusuario: widget.idusuario,
                                  idproyecto: widget.idproyecto,
                                )
                              : new Center(
                                  child: new CircularProgressIndicator(),
                                );
                        }),
                  ),
                ],
              ),
            ),
            Text(
              "Cargos del proyecto:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            Container(
              child: Expanded(
                child: new FutureBuilder<List>(
                    future: getCargos(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      if (snapshot.hasData) {
                        return new detallescargo(listacargos: snapshot.data);
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(mensajerrhh ?? ''),
                              RaisedButton(
                                child: new Text(
                                  "Crear cargo",
                                  style: (TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                                ),
                                color: colorappbar,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        );
                      }
                    }),
              ),
            ),
          ],
        ));
  }
}

class detallesrrhh extends StatefulWidget {
  final List list;
  final String idusuario;
  final String idproyecto;
  final List listacargos;

  const detallesrrhh(
      {Key key, this.list, this.idusuario, this.idproyecto, this.listacargos})
      : super(key: key);
  @override
  _detallesrrhhState createState() => _detallesrrhhState();
}

class _detallesrrhhState extends State<detallesrrhh> {
  @override
  Widget build(BuildContext context) {
    return widget.list == null
        ? Center(child: CircularProgressIndicator())
        : Container(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.list == null ? 0 : 1,
                      itemBuilder: (context, i) {
                        return Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: Column(children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      margin: EdgeInsets.all(15),
                                      elevation: 10,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                "Trabajadores: $cantidadtrabajadores",
                                                style: TextStyle(fontSize: 25),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          child: Text("Listar trabajadores"),
                                          color: colorappbar,
                                          textColor: Colors.white,
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        new ListarTrabajadores(
                                                          idproyecto:
                                                              widget.idproyecto,
                                                          idusuario:
                                                              widget.idusuario,
                                                        )));
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          child: Text("Agregar trabajador"),
                                          color: colorappbar,
                                          textColor: Colors.white,
                                          onPressed: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        );
                      }),
                ),
              ],
            ),
          );
  }
}

class detallescargo extends StatefulWidget {
  final List listacargos;

  const detallescargo({Key key, this.listacargos}) : super(key: key);
  @override
  _detallescargoState createState() => _detallescargoState();
}

class _detallescargoState extends State<detallescargo> {
  bool _showData = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: widget.listacargos == null ? 0 : widget.listacargos.length,
          itemBuilder: (context, i) {
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpansionTileCard(
                      baseColor: Colors.black54,
                      expandedColor: colorappbar,
                      title: Row(
                        children: [
                          Text(
                            widget.listacargos[i]['nombrecargo'],
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      children: <Widget>[
                        Divider(
                          thickness: 1.0,
                          height: 1.0,
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Editar usuarios"),
                                    ),
                                  ),
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Editar cargo"),
                                    ),
                                  ),
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Eliminar cargo"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
