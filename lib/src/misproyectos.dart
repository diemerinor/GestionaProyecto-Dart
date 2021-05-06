import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/crearproyecto.dart';
import 'package:gestionaproyecto/src/gestionarproyecto.dart';
import 'package:gestionaproyecto/src/listartrabajadores.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'detalleproyecto.dart';

int cantidadproyectoscreados;
int proyectosrestantes;
int cusuariofree = 5;
int cusuariomedium = 10;
int cusuariopro = 20;
int seleccionado;
Color todos;
Color misproy;
Color propar;
Color letrastodos;
Color letrasmisproy;
Color letraspropar;
bool visibletodos;
bool visiblemisproy;
bool visiblepropar;

class MisProyectos extends StatefulWidget {
  final String idusuario;
  MisProyectos({Key key, this.title, @required this.idusuario})
      : super(key: key);

  final String title;

  @override
  _MisProyectosState createState() => _MisProyectosState();
}

class _MisProyectosState extends State<MisProyectos> {
  @override
  void initState() {
    super.initState();
    todos = Colors.white;
    letrastodos = colorappbar;
    misproy = colorappbar;
    letrasmisproy = Colors.white;

    propar = colorappbar;
    letraspropar = Colors.white;

    visibletodos = true;
    visiblemisproy = false;
    visiblepropar = false;

    seleccionado = 1;
  }

  String url2 =
      'http://gestionaproyecto.com/phpproyectotitulo/getProyectousuario.php';
  String url3 =
      'http://gestionaproyecto.com/phpproyectotitulo/getProyectosCreados.php';

  Future<List> getTrabajadores() async {
    final response = await http.post(Uri.parse(url2), body: {
      "idusuario": widget.idusuario,
    });
    var respuesta1 = json.decode(response.body);

    final response2 = await http.post(Uri.parse(url3), body: {
      "idusuario": widget.idusuario,
    });

    var datauser = json.decode(response2.body);
    cantidadproyectoscreados = datauser.length;
    var auxi = respuesta1;
    auxi = auxi + datauser;
    //print("laa cosita essss $auxi[1]");

    //cantidadproyectoscreados = datauser.length;
    if (rolusuario == "1") {
      proyectosrestantes = 100;
    } else if (rolusuario == "2") {
      proyectosrestantes = cusuariofree - cantidadproyectoscreados;
    } else if (rolusuario == "3") {
      proyectosrestantes = cusuariomedium - cantidadproyectoscreados;
    } else if (rolusuario == "4") {
      proyectosrestantes = cusuariopro - cantidadproyectoscreados;
    }
    return json.decode(response.body);
  }

  String nombreusuario = "Diego Merino Rubilar";
  int _selectedIndex = 1;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    Homescreen(
      idusuario: identificadorusuario,
    ),
    Notificaciones(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorfondo,
      appBar: AppBar(
        title: Text("Mis proyectos"),
        backgroundColor: colorappbar,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(
                Icons.create_new_folder_rounded,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CrearProyecto(
                              idusuario: identificadorusuario,
                            )));
                // do something
              },
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            child: Expanded(
              child: new FutureBuilder<List>(
                  future: getTrabajadores(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? new listaproyectos(
                            list: snapshot.data,
                            codigousuario: widget.idusuario,
                            seleccionado: seleccionado,
                          )
                        : new Center(
                            child: new CircularProgressIndicator(),
                          );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class listaproyectos extends StatefulWidget {
  final List list;
  final String codigousuario;
  final int seleccionado;

  const listaproyectos(
      {Key key, this.list, this.codigousuario, this.seleccionado})
      : super(key: key);
  @override
  _listaproyectosState createState() => _listaproyectosState();
}

class _listaproyectosState extends State<listaproyectos> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          if (proyectosrestantes != 0)
            Container(
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      colorappbar,
                      Colors.lightGreen,
                    ],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter),
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  // Align(
                  //   alignment: Alignment.topLeft,
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(left: 20.0, top: 10),
                  //     child: Text(
                  //       "Filtra tus proyectos",
                  //       style: TextStyle(color: Colors.white, fontSize: 25),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (seleccionado != 1) {
                                    visibletodos = true;
                                    visiblemisproy = false;
                                    visiblepropar = false;
                                    print("actualmente es $visibletodos");
                                    todos = Colors.white;
                                    letrastodos = Colors.green;
                                    propar = colorappbar;
                                    letraspropar = Colors.white;
                                    misproy = colorappbar;
                                    letrasmisproy = Colors.white;

                                    seleccionado = 1;
                                  }
                                });
                              },
                              child: Card(
                                color: todos,
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      "Todos",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: letrastodos,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (seleccionado != 2) {
                                    visibletodos = false;
                                    visiblemisproy = true;
                                    visiblepropar = false;
                                    print("actualmente es $visiblemisproy");

                                    todos = colorappbar;
                                    letrastodos = Colors.white;
                                    propar = colorappbar;
                                    letraspropar = Colors.white;
                                    misproy = Colors.white;
                                    letrasmisproy = colorappbar;

                                    seleccionado = 2;
                                  }
                                });
                              },
                              child: Card(
                                color: misproy,
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      "Mis\nproyectos",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: letrasmisproy,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (seleccionado != 3) {
                                    visibletodos = false;
                                    visiblemisproy = false;
                                    visiblepropar = true;
                                    print("actualmente es $visiblepropar");
                                    todos = colorappbar;
                                    letrastodos = Colors.white;
                                    propar = Colors.white;
                                    letraspropar = colorappbar;
                                    misproy = colorappbar;
                                    letrasmisproy = Colors.white;
                                    seleccionado = 3;
                                  }
                                });
                              },
                              child: Card(
                                color: propar,
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      "Proyectos\nque participo",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: letraspropar,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
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
              padding: EdgeInsets.only(bottom: 15),
            ),
        ]),
        Container(
          child: Expanded(
            child: new ListView.builder(
              itemCount: widget.list == null ? 0 : widget.list.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: <Widget>[
                    if (seleccionado == 1)
                      Visibility(
                        visible: visibletodos,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.14,
                          child: GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new DetalleProyecto(
                                              list: widget.list,
                                              index: i,
                                              idusuario: widget.list[i]
                                                  ['idusuario'],
                                              idproyecto: widget.list[i]
                                                  ['idproyecto'],
                                            )),
                                  ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: new Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 4,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: ListView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.14,
                                            decoration: new BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Colors.white,
                                                    Colors.white10,
                                                  ],
                                                  begin: FractionalOffset
                                                      .topCenter,
                                                  end: FractionalOffset
                                                      .bottomCenter),
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Column(children: <Widget>[
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.09,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5)),
                                                        Text(
                                                          widget.list[i][
                                                              'nombreproyecto'],
                                                          style: TextStyle(
                                                              fontSize: 17.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5)),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                          child: Text(
                                                            widget.list[i][
                                                                'descripcionproyecto'],
                                                            style: TextStyle(
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                                Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.05,
                                                  color: Colors.green,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.location_city,
                                                          color: Colors.white,
                                                        ),
                                                        Text(
                                                          "Comuna: " +
                                                              widget.list[i][
                                                                  'nombrecomuna'],
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.white,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5)),
                                                        Icon(
                                                          Icons
                                                              .admin_panel_settings_rounded,
                                                          color: Colors.white,
                                                        ),
                                                        Text(
                                                          "Rol: " +
                                                              widget.list[i]
                                                                  ['NombreRol'],
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.white),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              )),
                        ),
                      )
                    else if (seleccionado == 2 &&
                        widget.list[i]['idusuariocreador'] ==
                            identificadorusuario)
                      Visibility(
                        visible: visiblemisproy,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.14,
                          child: GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new DetalleProyecto(
                                              list: widget.list,
                                              index: i,
                                              idusuario: widget.list[i]
                                                  ['idusuario'],
                                              idproyecto: widget.list[i]
                                                  ['idproyecto'],
                                            )),
                                  ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: new Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 4,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: ListView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.14,
                                            decoration: new BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Colors.white,
                                                    Colors.white10,
                                                  ],
                                                  begin: FractionalOffset
                                                      .topCenter,
                                                  end: FractionalOffset
                                                      .bottomCenter),
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Column(children: <Widget>[
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.09,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5)),
                                                        Text(
                                                          widget.list[i][
                                                              'nombreproyecto'],
                                                          style: TextStyle(
                                                              fontSize: 17.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5)),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                          child: Text(
                                                            widget.list[i][
                                                                'descripcionproyecto'],
                                                            style: TextStyle(
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                                Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.05,
                                                  color: Colors.green,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.location_city,
                                                          color: Colors.white,
                                                        ),
                                                        Text(
                                                          "Comuna: " +
                                                              widget.list[i][
                                                                  'nombrecomuna'],
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.white,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5)),
                                                        Icon(
                                                          Icons
                                                              .admin_panel_settings_rounded,
                                                          color: Colors.white,
                                                        ),
                                                        Text(
                                                          "Rol: " +
                                                              widget.list[i]
                                                                  ['NombreRol'],
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.white),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              )),
                        ),
                      )
                    else if (seleccionado == 3 &&
                        widget.list[i]['idusuariocreador'] !=
                            identificadorusuario)
                      Visibility(
                        visible: visiblepropar,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.14,
                          child: GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new DetalleProyecto(
                                              list: widget.list,
                                              index: i,
                                              idusuario: widget.list[i]
                                                  ['idusuario'],
                                              idproyecto: widget.list[i]
                                                  ['idproyecto'],
                                            )),
                                  ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: new Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 4,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: ListView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.14,
                                            decoration: new BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Colors.white,
                                                    Colors.white10,
                                                  ],
                                                  begin: FractionalOffset
                                                      .topCenter,
                                                  end: FractionalOffset
                                                      .bottomCenter),
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Column(children: <Widget>[
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.09,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5)),
                                                        Text(
                                                          widget.list[i][
                                                              'nombreproyecto'],
                                                          style: TextStyle(
                                                              fontSize: 17.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5)),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                          child: Text(
                                                            widget.list[i][
                                                                'descripcionproyecto'],
                                                            style: TextStyle(
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                                Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.05,
                                                  color: Colors.green,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.location_city,
                                                          color: Colors.white,
                                                        ),
                                                        Text(
                                                          "Comuna: " +
                                                              widget.list[i][
                                                                  'nombrecomuna'],
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.white,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5)),
                                                        Icon(
                                                          Icons
                                                              .admin_panel_settings_rounded,
                                                          color: Colors.white,
                                                        ),
                                                        Text(
                                                          "Rol: " +
                                                              widget.list[i]
                                                                  ['NombreRol'],
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.white),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              )),
                        ),
                      )
                  ]),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
