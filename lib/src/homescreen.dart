import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:gestionaproyecto/src/misproyectos.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestionaproyecto/main.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'infoperfil.dart';

class Homescreen extends StatefulWidget {
  final String idusuario;
  Homescreen({Key key, @required this.idusuario}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  SharedPreferences sharedPreferences;

  String url3 =
      'http://gestionaproyecto.com/phpproyectotitulo/getInfoPerfil.php';
  String idusuarioc;

  // ignore: missing_return

  Future<List> getEventos() async {
    final response =
        await http.post(Uri.parse(url3), body: {'idusuario': widget.idusuario});
    print("el usuario esssss " + widget.idusuario);

    var datauser = json.decode(response.body);
    idusuarioc = datauser[0]['idusuario'];
    return datauser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorfondo,
      body: new FutureBuilder<List>(
          future: getEventos(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            if (snapshot.hasData) {
              return new listareventos(
                list: snapshot.data,
                idusuariofinal: idusuarioc,
              );
            } else {
              return new Center(
                child: new CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class listareventos extends StatefulWidget {
  String idusuariofinal;
  final List list;

  listareventos({Key key, this.list, this.idusuariofinal}) : super(key: key);
  @override
  _listareventosState createState() => _listareventosState();
}

class _listareventosState extends State<listareventos> {
  String fechayhoranotificacion;
  DateTime fechayhora;
  int anos;
  @override
  Widget build(BuildContext context) {
    return widget.idusuariofinal == null
        ? Center(child: CircularProgressIndicator())
        : FutureBuilder<List>(builder: (context, snapshot) {
            return ListView.builder(
                itemCount: widget.list == null ? 0 : 1,
                itemBuilder: (context, i) {
                  return Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.21,
                          decoration: new BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  colorappbar,
                                  Colors.lightGreen,
                                ],
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter),
                            /*image: DecorationImage(
                      fit: BoxFit.cover,
                      image: new AssetImage('assets/images/misproyectos.jpg')) */
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 8.0, right: 14),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.09,
                                    child: Image(
                                        image: new AssetImage(
                                            'assets/images/logo3.png')),
                                  ),
                                  Text(
                                    widget.list[i]['nombreusuario'] +
                                        " " +
                                        widget.list[i]['apellidos'],
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "HOME",
                                    style: TextStyle(
                                      fontSize: 29,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MisProyectos(
                                                    idusuario:
                                                        identificadorusuario,
                                                  ))),
                                      child: Card(
                                        elevation: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            children: <Widget>[
                                              Card(
                                                  color: Colors.red,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            7.0),
                                                    child: Icon(
                                                      Icons.location_city,
                                                      size: 40,
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 5.0,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Mis Proyectos",
                                                      style: TextStyle(
                                                        fontSize: 23,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Contactos(
                                                    idusuario:
                                                        identificadorusuario,
                                                  ))),
                                      child: Card(
                                        elevation: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            children: <Widget>[
                                              Card(
                                                  color: Colors.blue,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            7.0),
                                                    child: Icon(
                                                      Icons.people_alt_rounded,
                                                      size: 40,
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 5.0,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Contactos",
                                                      style: TextStyle(
                                                          fontSize: 23,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Notificaciones(
                                                    idusuario:
                                                        identificadorusuario,
                                                  ))),
                                      child: Card(
                                        elevation: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            children: <Widget>[
                                              Card(
                                                  color: Colors.green,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            7.0),
                                                    child: Icon(
                                                      Icons.notifications,
                                                      size: 40,
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 5.0,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Actividad",
                                                      style: TextStyle(
                                                          fontSize: 23,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => InfoPerfil(
                                                    idusuario:
                                                        identificadorusuario,
                                                  ))),
                                      child: Card(
                                        elevation: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            children: <Widget>[
                                              Card(
                                                  color: Colors.purple,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            7.0),
                                                    child: Icon(
                                                      Icons.account_circle,
                                                      size: 40,
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 5.0,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Mi Perfil",
                                                      style: TextStyle(
                                                          fontSize: 23,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => InfoPerfil(
                                                    idusuario:
                                                        identificadorusuario,
                                                  ))),
                                      child: Card(
                                        elevation: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            children: <Widget>[
                                              Card(
                                                  color: Color.fromRGBO(
                                                      65, 47, 31, 10),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            7.0),
                                                    child: Icon(
                                                      Icons.settings,
                                                      size: 40,
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 7.0,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Configuración",
                                                      style: TextStyle(
                                                          fontSize: 23,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          });
  }
}
