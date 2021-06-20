import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/detalle.dart';
import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

int seleccionado;
int cantidadeventos = 0;
int cantidadmov = 0;
Color financiamiento;
Color eventoscolor;
Color todoscolor;
Color letrasfinanciamiento;
Color letraseventos;
Color letrastodos;
bool visiblefinanciamiento;
bool visibleeventos;
bool visibletodos;

class Notificaciones extends StatefulWidget {
  final String idusuario;

  const Notificaciones({Key key, this.idusuario}) : super(key: key);
  @override
  _NotificacionesState createState() => _NotificacionesState();
}

class _NotificacionesState extends State<Notificaciones> {
  String url2 =
      'http://gestionaproyecto.com/phpproyectotitulo/getNotificaciones.php';
  String url4 =
      'http://gestionaproyecto.com/phpproyectotitulo/getMovimientosNotif.php';

  // ignore: missing_return

  Future<List> getNotificaciones() async {
    final response =
        await http.post(Uri.parse(url4), body: {'idusuario': widget.idusuario});
    var datauser = jsonDecode(response.body);

    return datauser;
  }

  @override
  void initState() {
    // TODO: implement initState

    financiamiento = colorappbar2;
    letrasfinanciamiento = Colors.white;
    eventoscolor = colorappbar2;
    letraseventos = Colors.white;

    todoscolor = Colors.white;
    letrastodos = colorappbar2;

    visiblefinanciamiento = true;
    visibleeventos = false;
    visibletodos = false;

    seleccionado = 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorfondo,
      appBar: AppBar(
        title: new Text("Actividad"),
        backgroundColor: colorappbar,
        elevation: 0,
      ),
      body: new FutureBuilder<List>(
          future: getNotificaciones(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? new listatrabaj(
                    list: snapshot.data,
                    seleccionado: seleccionado,
                  )
                : new Center(
                    child: new CircularProgressIndicator(),
                  );
          }),
    );
  }
}

class listatrabaj extends StatefulWidget {
  final List list;
  final int seleccionado;
  listatrabaj({this.list, this.seleccionado});

  @override
  _listatrabajState createState() => _listatrabajState();
}

class _listatrabajState extends State<listatrabaj> {
  String fechayhoranotificacion;
  DateTime fechayhora;
  int anos;

  String fechayhoranotificacion2;
  DateTime fechayhora2;
  int anos2;
  Duration tiempodiferencia2;

  @override
  Widget build(BuildContext context) {
    return widget.list == null
        ? Center(child: CircularProgressIndicator())
        : Column(children: [
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              if (widget.list.length != 0)
                Container(
                  decoration: new BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          colorappbar,
                          colorappbar,
                        ],
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(
                            "Filtra tus notificaciones",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (seleccionado != 3) {
                                        visiblefinanciamiento = false;
                                        visibleeventos = false;
                                        visibletodos = true;
                                        print("actualmente es $visibletodos");
                                        financiamiento = colorappbar2;
                                        letrasfinanciamiento = Colors.white;
                                        todoscolor = Colors.white;
                                        letrastodos = colorappbar2;
                                        eventoscolor = colorappbar2;
                                        letraseventos = Colors.white;
                                        seleccionado = 3;
                                      }
                                    });
                                  },
                                  child: Card(
                                    color: todoscolor,
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Text(
                                          "Todos",
                                          style: TextStyle(
                                              fontSize: 14,
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
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (seleccionado != 1) {
                                        visiblefinanciamiento = true;
                                        visibleeventos = false;
                                        visibletodos = false;
                                        print(
                                            "actualmente es $visiblefinanciamiento");
                                        financiamiento = Colors.white;
                                        letrasfinanciamiento = colorappbar2;
                                        todoscolor = colorappbar2;
                                        letrastodos = Colors.white;
                                        eventoscolor = colorappbar2;
                                        letraseventos = Colors.white;

                                        seleccionado = 1;
                                      }
                                    });
                                  },
                                  child: Card(
                                    color: financiamiento,
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Text(
                                          "Financiamiento",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: letrasfinanciamiento,
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
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (seleccionado != 2) {
                                        visiblefinanciamiento = false;
                                        visibleeventos = true;
                                        visibletodos = false;
                                        print("actualmente es $visibleeventos");

                                        financiamiento = colorappbar2;
                                        letrasfinanciamiento = Colors.white;
                                        todoscolor = colorappbar2;
                                        letrastodos = Colors.white;
                                        eventoscolor = Colors.white;
                                        letraseventos = colorappbar2;

                                        seleccionado = 2;
                                      }
                                    });
                                  },
                                  child: Card(
                                    color: eventoscolor,
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Text(
                                          "Eventos",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: letraseventos,
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
                      fechayhoranotificacion =
                          widget.list[i]['fechapublicacion'];
                      fechayhora = DateTime.parse(fechayhoranotificacion);
                      Duration tiempodiferencia =
                          DateTime.now().difference(fechayhora);
                      if (tiempodiferencia.inDays > 365) {
                        anos = ((tiempodiferencia.inDays) / 365).toInt();
                      }

                      if (widget.list[i]['descripcion'] != null) {
                        fechayhoranotificacion2 =
                            widget.list[i]['fechapublicacion'];
                        fechayhora2 = DateTime.parse(fechayhoranotificacion2);
                        tiempodiferencia2 =
                            DateTime.now().difference(fechayhora2);
                        if (tiempodiferencia2.inDays > 365) {
                          anos2 = ((tiempodiferencia2.inDays) / 365).toInt();
                        }
                      }

                      return Column(children: [
                        if (widget.list[i]['nombreproyecto'] == null)
                          Container(
                            child: Text(
                              "No existen notificaciones en tus proyectos",
                              style: TextStyle(fontSize: 17.0),
                            ),
                          )
                        else if (seleccionado == 1 &&
                            widget.list[i]["ingreso"] != null)
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new Detalle(
                                          list: widget.list,
                                          index: i,
                                        )),
                              ),
                              child: Column(
                                children: [
                                  if (widget.list[i]["idtipomovimiento"] == "1")
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Card(
                                                color: verde,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Icon(
                                                    Icons.north_east,
                                                    size: 40,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                    child: Text(
                                                        widget.list[i]
                                                            ['nombreproyecto'],
                                                        style: TextStyle(
                                                            fontSize: 17.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.70,
                                                    child: Text(
                                                      "Se realizó un ingreso de " +
                                                          widget.list[i]
                                                              ['ingreso'],
                                                      style: TextStyle(
                                                          fontSize: 17.0),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (tiempodiferencia.inMinutes < 60)
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              'Hace ${tiempodiferencia.inMinutes} minutos',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          )
                                        else if (tiempodiferencia.inDays == 0 &&
                                            tiempodiferencia.inMinutes > 60)
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              'Hace ${tiempodiferencia.inHours} horas',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          )
                                        else if (tiempodiferencia.inDays <= 365)
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                                'Hace ${tiempodiferencia.inDays} días',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontStyle: FontStyle.italic,
                                                )),
                                          )
                                        else if (tiempodiferencia.inDays >= 365)
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                                'Hace más de $anos años',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontStyle: FontStyle.italic,
                                                )),
                                          )
                                      ],
                                    )
                                  else if (widget.list[i]["idtipomovimiento"] ==
                                      "2")
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Card(
                                                color: rojooscuro,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Icon(
                                                    Icons.south_east,
                                                    size: 40,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                    child: Text(
                                                        widget.list[i]
                                                            ['nombreproyecto'],
                                                        style: TextStyle(
                                                            fontSize: 17.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.70,
                                                    child: Text(
                                                      "Se realizó un gasto de " +
                                                          widget.list[i]
                                                              ['ingreso'],
                                                      style: TextStyle(
                                                          fontSize: 17.0),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (tiempodiferencia.inMinutes < 60)
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              'Hace ${tiempodiferencia.inMinutes} minutos',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          )
                                        else if (tiempodiferencia.inDays == 0)
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              'Hace ${tiempodiferencia.inHours} horas',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          )
                                        else if (tiempodiferencia.inDays <= 365)
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                                'Hace ${tiempodiferencia.inDays} días',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontStyle: FontStyle.italic,
                                                )),
                                          )
                                        else if (tiempodiferencia.inDays >= 365)
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                                'Hace más de $anos años',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontStyle: FontStyle.italic,
                                                )),
                                          ),
                                      ],
                                    ),
                                  Divider(
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          )
                        else if (seleccionado == 2 &&
                            widget.list[i]["descripcion"] != null)
                          Container(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          new Detalle(
                                            list: widget.list,
                                            index: i,
                                          )),
                                ),
                                child: Column(
                                  children: [
                                    if (widget.list[i]["descripcion"] == null)
                                      Text("No existe")
                                    else if (widget.list[i]["descripcion"] !=
                                        null)
                                      Column(children: <Widget>[
                                        Row(
                                          children: [
                                            Card(
                                                color: azul,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Icon(
                                                    Icons.alarm,
                                                    size: 40,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                    child: Text(
                                                        widget.list[i]
                                                            ['nombreproyecto'],
                                                        style: TextStyle(
                                                            fontSize: 17.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.70,
                                                    child: Text(
                                                      widget.list[i]['titulo'] +
                                                          ": " +
                                                          widget.list[i]
                                                              ["descripcion"],
                                                      style: TextStyle(
                                                          fontSize: 17.0),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.date_range,
                                                          size: 25),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5)),
                                                      Text(
                                                        widget.list[i]
                                                            ["fecha_evento"],
                                                        style: TextStyle(
                                                            fontSize: 19),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10)),
                                                      Icon(Icons.alarm,
                                                          size: 25),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5)),
                                                      Text(
                                                          widget.list[i]
                                                              ["hora_evento"],
                                                          style: TextStyle(
                                                              fontSize: 19)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (tiempodiferencia.inMinutes < 60)
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              'Hace ${tiempodiferencia.inMinutes} minutos',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          )
                                        else if (tiempodiferencia2.inDays == 0)
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              'Hace ${tiempodiferencia2.inHours} horas',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          )
                                        else if (tiempodiferencia2.inDays <=
                                            365)
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                                'Hace ${tiempodiferencia2.inDays} días',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontStyle: FontStyle.italic,
                                                )),
                                          )
                                        else if (tiempodiferencia2.inDays >=
                                            365)
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                                'Hace más de $anos2 años',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontStyle: FontStyle.italic,
                                                )),
                                          ),
                                        Divider(
                                          color: Colors.black,
                                        ),
                                      ]),
                                  ],
                                ),
                              ))
                        else if (seleccionado == 3)
                          Container(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          new Detalle(
                                            list: widget.list,
                                            index: i,
                                          )),
                                ),
                                child: Column(
                                  children: [
                                    if (widget.list[i]["descripcion"] == null &&
                                        widget.list[i]['idtipomovimiento'] ==
                                            null)
                                      Text("No existe")
                                    else if (widget.list[i]["descripcion"] !=
                                        null)
                                      Column(children: <Widget>[
                                        Row(
                                          children: [
                                            Card(
                                                color: azul,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Icon(
                                                    Icons.alarm,
                                                    size: 40,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                    child: Text(
                                                        widget.list[i]
                                                            ['nombreproyecto'],
                                                        style: TextStyle(
                                                            fontSize: 17.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.70,
                                                    child: Text(
                                                      widget.list[i]['titulo'] +
                                                          ": " +
                                                          widget.list[i]
                                                              ["descripcion"],
                                                      style: TextStyle(
                                                          fontSize: 17.0),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.date_range,
                                                          size: 25),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5)),
                                                      Text(
                                                        widget.list[i]
                                                            ["fecha_evento"],
                                                        style: TextStyle(
                                                            fontSize: 19),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10)),
                                                      Icon(Icons.alarm,
                                                          size: 25),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5)),
                                                      Text(
                                                          widget.list[i]
                                                              ["hora_evento"],
                                                          style: TextStyle(
                                                              fontSize: 19)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (tiempodiferencia.inMinutes < 60)
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              'Hace ${tiempodiferencia.inMinutes} minutos',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          )
                                        else if (tiempodiferencia2.inDays == 0)
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              'Hace ${tiempodiferencia2.inHours} horas',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          )
                                        else if (tiempodiferencia2.inDays <=
                                            365)
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                                'Hace ${tiempodiferencia2.inDays} días',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontStyle: FontStyle.italic,
                                                )),
                                          )
                                        else if (tiempodiferencia2.inDays >=
                                            365)
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                                'Hace más de $anos2 años',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontStyle: FontStyle.italic,
                                                )),
                                          ),
                                        Divider(
                                          color: Colors.black,
                                        ),
                                      ])
                                    else if (widget.list[i]
                                            ["idtipomovimiento"] ==
                                        "1")
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Card(
                                                  color: verde,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Icon(
                                                      Icons.north_east,
                                                      size: 40,
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                      child: Text(
                                                          widget.list[i][
                                                              'nombreproyecto'],
                                                          style: TextStyle(
                                                              fontSize: 17.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.70,
                                                      child: Text(
                                                        "Se realizó un ingreso de " +
                                                            widget.list[i]
                                                                ['ingreso'],
                                                        style: TextStyle(
                                                            fontSize: 17.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (tiempodiferencia.inMinutes < 60)
                                            Container(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                'Hace ${tiempodiferencia.inMinutes} minutos',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            )
                                          else if (tiempodiferencia.inDays == 0)
                                            Container(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                'Hace ${tiempodiferencia.inHours} horas',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            )
                                          else if (tiempodiferencia.inDays <=
                                              365)
                                            Container(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                  'Hace ${tiempodiferencia.inDays} días',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontStyle: FontStyle.italic,
                                                  )),
                                            )
                                          else if (tiempodiferencia.inDays >=
                                              365)
                                            Container(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                  'Hace más de $anos años',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontStyle: FontStyle.italic,
                                                  )),
                                            ),
                                          Divider(
                                            color: Colors.black,
                                          ),
                                        ],
                                      )
                                    else if (widget.list[i]
                                            ["idtipomovimiento"] ==
                                        "2")
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Card(
                                                  color: rojooscuro,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Icon(
                                                      Icons.south_east,
                                                      size: 40,
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                      child: Text(
                                                          widget.list[i][
                                                              'nombreproyecto'],
                                                          style: TextStyle(
                                                              fontSize: 17.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.70,
                                                      child: Text(
                                                        "Se realizó un gasto de " +
                                                            widget.list[i]
                                                                ['ingreso'],
                                                        style: TextStyle(
                                                            fontSize: 17.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (tiempodiferencia.inMinutes < 60)
                                            Container(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                'Hace ${tiempodiferencia.inMinutes} minutos',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            )
                                          else if (tiempodiferencia.inDays == 0)
                                            Container(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                'Hace ${tiempodiferencia.inHours} horas',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            )
                                          else if (tiempodiferencia.inDays <=
                                              365)
                                            Container(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                  'Hace ${tiempodiferencia.inDays} días',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontStyle: FontStyle.italic,
                                                  )),
                                            )
                                          else if (tiempodiferencia.inDays >=
                                              365)
                                            Container(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                  'Hace más de $anos años',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontStyle: FontStyle.italic,
                                                  )),
                                            ),
                                          Divider(
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ))
                      ]);
                    }),
              ),
            ),
          ]);
  }
}
