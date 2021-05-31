import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/crearcargoproyecto.dart';
import 'package:gestionaproyecto/src/gestionarproyecto.dart';
import 'package:gestionaproyecto/src/listartrabajadores.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/listarusuariocargo.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:http/http.dart' as http;
import 'package:expansion_tile_card/expansion_tile_card.dart';

import 'dart:async';
import 'dart:convert';

import 'editarcargoproyecto.dart';

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
        backgroundColor: colorfondo,
        appBar: AppBar(
          title: Text("Gestión RRHH"),
          backgroundColor: colorappbar,
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.17,
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
            Divider(
              thickness: 1.0,
              height: 3.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Cargos del proyecto:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  Padding(padding: EdgeInsets.only(left: 30)),
                  RaisedButton(
                    child: new Text(
                      "Crear cargo",
                      style: (TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    color: colorappbar,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new CrearCargo(
                                  idproyecto: widget.idproyecto)));
                    },
                  ),
                ],
              ),
            ),
            Container(
              child: Expanded(
                child: new FutureBuilder<List>(
                    future: getCargos(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      if (snapshot.hasData) {
                        return new detallescargo(
                          listacargos: snapshot.data,
                          idproyecto: widget.idproyecto,
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                mensajerrhh ?? '',
                                style: TextStyle(fontSize: 18),
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
                              child: Column(children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Cantidad de\ntrabajadores:",
                                                    style:
                                                        TextStyle(fontSize: 22),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 15)),
                                                  Text(
                                                    "$cantidadtrabajadores",
                                                    style: TextStyle(
                                                        fontSize: 60,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 30.0),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RaisedButton(
                                                    child: Text("Listar"),
                                                    color: colorappbar,
                                                    textColor: Colors.white,
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  new ListarTrabajadores(
                                                                    idproyecto:
                                                                        widget
                                                                            .idproyecto,
                                                                    idusuario:
                                                                        widget
                                                                            .idusuario,
                                                                  )));
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RaisedButton(
                                                    child: Text("Agregar"),
                                                    color: colorappbar,
                                                    textColor: Colors.white,
                                                    onPressed: () {},
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
  final String idproyecto;

  const detallescargo({Key key, this.listacargos, this.idproyecto})
      : super(key: key);
  @override
  _detallescargoState createState() => _detallescargoState();
}

class _detallescargoState extends State<detallescargo> {
  String url = 'http://gestionaproyecto.com/phpproyectotitulo/DeleteCargo.php';
  String cargoaeliminar;
  Future<List> deletecargo() async {
    print(cargoaeliminar);
    final response =
        await http.post(Uri.parse(url), body: {"idcargo": cargoaeliminar});
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continuar"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        deletecargo();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GestionRRHH(
                      idproyecto: widget.idproyecto,
                    )));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("¿Está seguro de eliminar el cargo? "),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

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
                      baseColor: colorappbar2,
                      expandedColor: colorappbar,
                      title: Row(
                        children: [
                          Text(
                            widget.listacargos[i]['nombrecargo'],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      children: <Widget>[
                        Divider(
                          thickness: 1.0,
                          height: 1.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.listacargos[i]['descripcioncargo'] !=
                                null)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 20.0),
                                child: Text(
                                  widget.listacargos[i]['descripcioncargo'],
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                new ListarUsCargo(
                                                  idproyecto: widget.idproyecto,
                                                  idcargo: widget.listacargos[i]
                                                      ['idcargo'],
                                                )),
                                      ),
                                      child: Card(
                                        color: Colors.amber,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.people,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                new EditarCargo(
                                                  idproyecto: widget.idproyecto,
                                                  idcargo: widget.listacargos[i]
                                                      ['idcargo'],
                                                )),
                                      ),
                                      child: Card(
                                        color: Colors.teal,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => {
                                        setState(() {
                                          cargoaeliminar =
                                              widget.listacargos[i]['idcargo'];
                                        }),
                                        showAlertDialog(context),
                                      },
                                      child: Card(
                                        color: colorappbar2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
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
