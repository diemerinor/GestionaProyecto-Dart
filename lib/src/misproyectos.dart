import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
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

class MisProyectos extends StatefulWidget {
  final String idusuario;
  MisProyectos({Key key, this.title, @required this.idusuario})
      : super(key: key);

  final String title;

  @override
  _MisProyectosState createState() => _MisProyectosState();
}

class _MisProyectosState extends State<MisProyectos> {
  String url2 =
      'http://gestionaproyecto.com/phpproyectotitulo/getProyectousuario.php';
  String url3 =
      'http://gestionaproyecto.com/phpproyectotitulo/getProyectosCreados.php';

  Future<List> getTrabajadores() async {
    final response = await http.post(Uri.parse(url2), body: {
      "idusuario": widget.idusuario,
    });

    final response2 = await http.post(Uri.parse(url3), body: {
      "idusuario": widget.idusuario,
    });
    var datauser = json.decode(response2.body);
    cantidadproyectoscreados = datauser.length;
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

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Mis proyectos"),
        backgroundColor: Color.fromRGBO(46, 12, 21, 20),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (proyectosrestantes != 0)
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(
                color: Colors.amberAccent,
                elevation: 8,
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Actualmente has creado $cantidadproyectoscreados proyectos, te quedan $proyectosrestantes por crear",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      RaisedButton(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: new Text(
                            "Crear proyecto",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        color: Colors.red,
                        textColor: Colors.white,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Notificaciones(
                                      idusuario: identificadorusuario)));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
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

  const listaproyectos({Key key, this.list, this.codigousuario})
      : super(key: key);
  @override
  _listaproyectosState createState() => _listaproyectosState();
}

class _listaproyectosState extends State<listaproyectos> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Expanded(
            child: new ListView.builder(
              itemCount: widget.list == null ? 0 : widget.list.length,
              itemBuilder: (context, i) {
                return Column(children: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.2,
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
                              child: new Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 10,
                                  child: ListView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        decoration: new BoxDecoration(
                                            borderRadius:
                                                new BorderRadius.circular(5),
                                            color: Colors.black87),
                                        child: FittedBox(
                                          child: Column(
                                            children: <Widget>[
                                              Center(
                                                  child:
                                                      Column(children: <Widget>[
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5)),
                                                Text(
                                                  widget.list[i]
                                                      ['nombreproyecto'],
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5)),
                                                Text(
                                                  widget.list[i]
                                                      ['descripcionproyecto'],
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ])),
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.location_city,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      "Comuna: " +
                                                          widget.list[i]
                                                              ['nombrecomuna'],
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.all(5)),
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
                                                          fontSize: 15,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))),
                        ),
                      ])),
                ]);
              },
            ),
          ),
        ),
      ],
    );
  }
}

// class listaproyectos extends StatefulWidget {
//   final List list;
//   final String codigousuario;
//   listaproyectos({this.list, @required this.codigousuario});
//   @override
//   Widget build(BuildContext context) {
    
//   }

//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     throw UnimplementedError();
//   }
// }
