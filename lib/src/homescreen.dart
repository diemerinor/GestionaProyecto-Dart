import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:gestionaproyecto/src/misproyectos.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestionaproyecto/main.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class Homescreen extends StatefulWidget {
  final String idusuario;
  Homescreen({Key key, @required this.idusuario}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  SharedPreferences sharedPreferences;

  String url3 = 'http://gestionaproyecto.com/phpproyectotitulo/getEventos.php';

  // ignore: missing_return

  Future<List> getEventos() async {
    final response =
        await http.post(Uri.parse(url3), body: {'idusuario': widget.idusuario});
    print("el usuario esssss " + widget.idusuario);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new FutureBuilder<List>(
          future: getEventos(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? new listareventos(
                    list: snapshot.data,
                    idusuariofinal: widget.idusuario,
                  )
                : new Center(
                    child: new CircularProgressIndicator(),
                  );
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
    return Center(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              color: Color.fromRGBO(46, 12, 21, 20),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      "Bienvenid@",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      lognombreus + " " + logapellidos,
                      style: TextStyle(
                          fontSize: 27,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MisProyectos(
                              idusuario: identificadorusuario,
                            ))),
                child: Column(
                  children: [
                    Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.only(top: 2, bottom: 10),
                        elevation: 10,

                        // Dentro de esta propiedad usamos ClipRRect
                        child: ClipRRect(
                          // Los bordes del contenido del card se cortan usando BorderRadius
                          borderRadius: BorderRadius.circular(10),

                          // EL widget hijo que será recortado segun la propiedad anterior
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.10,
                            width: MediaQuery.of(context).size.width * 0.90,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              "assets/images/misproyectos.jpg"))),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Center(
                                        child: Text(
                                          'MIS PROYECTOS',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 36,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                )),
          ),
          Center(
            child: Text(
              "- Actividad -",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: <Widget>[
                GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Notificaciones(
                                  idusuario: identificadorusuario,
                                ))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.all(15),
                            elevation: 10,

                            // Dentro de esta propiedad usamos ClipRRect
                            child: ClipRRect(
                              // Los bordes del contenido del card se cortan usando BorderRadius
                              borderRadius: BorderRadius.circular(10),

                              // EL widget hijo que será recortado segun la propiedad anterior
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.40,
                                child: Stack(
                                  children: <Widget>[
                                    Container(color: Colors.redAccent),
                                    ListView(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              // Icon(
                                              //   Icons.alarm,
                                              //   size: 30,
                                              //   color: Colors.white,
                                              // ),
                                              new Container(
                                                padding:
                                                    EdgeInsets.only(top: 0),
                                                child: new CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  child: Text(
                                                    "0",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.06,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.30,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle),
                                              ),
                                              Text(
                                                'Nuevas\nnotificaciones',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    )),
                GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Notificaciones(
                                  idusuario: identificadorusuario,
                                ))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.all(15),
                            elevation: 10,

                            // Dentro de esta propiedad usamos ClipRRect
                            child: ClipRRect(
                              // Los bordes del contenido del card se cortan usando BorderRadius
                              borderRadius: BorderRadius.circular(10),

                              // EL widget hijo que será recortado segun la propiedad anterior
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.40,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      color: Colors.blue,
                                    ),
                                    ListView(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              // Icon(
                                              //   Icons.alarm,
                                              //   size: 30,
                                              //   color: Colors.white,
                                              // ),
                                              new Container(
                                                padding:
                                                    EdgeInsets.only(top: 0),
                                                child: new CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  child: Text(
                                                    "0",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.06,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.30,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle),
                                              ),
                                              Text(
                                                'Mensajes\nrecibidos',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    )),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: <Widget>[
                GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Notificaciones(
                                  idusuario: identificadorusuario,
                                ))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.all(15),
                            elevation: 10,

                            // Dentro de esta propiedad usamos ClipRRect
                            child: ClipRRect(
                              // Los bordes del contenido del card se cortan usando BorderRadius
                              borderRadius: BorderRadius.circular(10),

                              // EL widget hijo que será recortado segun la propiedad anterior
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.40,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      color: Colors.green,
                                    ),
                                    ListView(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              // Icon(
                                              //   Icons.alarm,
                                              //   size: 30,
                                              //   color: Colors.white,
                                              // ),
                                              new Container(
                                                padding:
                                                    EdgeInsets.only(top: 0),
                                                child: new CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  child: Text(
                                                    "0",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.06,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.30,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle),
                                              ),
                                              Text(
                                                'Eventos\nesta semana',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    )),
                GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Notificaciones(
                                  idusuario: identificadorusuario,
                                ))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.all(15),
                            elevation: 10,

                            // Dentro de esta propiedad usamos ClipRRect
                            child: ClipRRect(
                              // Los bordes del contenido del card se cortan usando BorderRadius
                              borderRadius: BorderRadius.circular(10),

                              // EL widget hijo que será recortado segun la propiedad anterior
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.40,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      color: Colors.deepOrange,
                                    ),
                                    ListView(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              // Icon(
                                              //   Icons.alarm,
                                              //   size: 30,
                                              //   color: Colors.white,
                                              // ),
                                              new Container(
                                                padding:
                                                    EdgeInsets.only(top: 0),
                                                child: new CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  child: Text(
                                                    "0",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.06,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.30,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle),
                                              ),
                                              Text(
                                                'Solicitudes\namistad',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
