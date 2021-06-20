import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/crearevento.dart';
import 'package:gestionaproyecto/src/detalle.dart';
import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'detalleevento.dart';

String mensajeeventos;

class ListarEventos extends StatefulWidget {
  final String idproyecto;

  ListarEventos({Key key, this.idproyecto}) : super(key: key);
  @override
  _ListarEventosState createState() => _ListarEventosState();
}

class _ListarEventosState extends State<ListarEventos> {
  String url2 = 'http://gestionaproyecto.com/phpproyectotitulo/getEventos.php';
  int cantidadeventos;
  Future<List> getEventos() async {
    final response = await http
        .post(Uri.parse(url2), body: {"idproyecto": widget.idproyecto});
    var datauser = json.decode(response.body);
    if (datauser == null) {
      mensajeeventos = "No existen eventos en tu proyecto";
      print("entró");
    } else {
      cantidadeventos = datauser.length;
      if (cantidadeventos == 0) {
        mensajeeventos = "No existen eventos en tu proyecto";
      }
      print("la cantidad es");
      print(cantidadeventos);
    }

    return datauser;
  }

  @override
  void initState() {
    super.initState();
    mensajeeventos = "Cargando eventos...";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text("Eventos próximos"),
          backgroundColor: colorappbar,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: Icon(
                  Icons.add_alarm_outlined,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CrearEvento(
                                idproyecto: widget.idproyecto,
                              )));
                  // do something
                },
              ),
            )
          ],
        ),
        backgroundColor: colorfondo,
        body: Column(
          children: [
            Expanded(
              child: new FutureBuilder<List>(
                  future: getEventos(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    if (snapshot.hasData && cantidadeventos != 0) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: colorappbar,
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                'Selecciona un evento',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                            child: new listareventoss(
                              list: snapshot.data,
                              idproyecto: widget.idproyecto,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              mensajeeventos ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: colorappbar2),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
            ),
          ],
        ));
  }
}

class listareventoss extends StatefulWidget {
  final List list;
  final String idproyecto;

  const listareventoss({Key key, this.list, this.idproyecto}) : super(key: key);
  @override
  _listareventossState createState() => _listareventossState();
}

class _listareventossState extends State<listareventoss> {
  @override
  Widget build(BuildContext context) {
    if (widget.list == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: widget.list == null ? 0 : widget.list.length,
                itemBuilder: (context, i) {
                  return new Container(
                    child: GestureDetector(
                        onTap: () => {
                              print("la wea es " +
                                  widget.list[i]['idnotificaciones']),
                              Navigator.of(context).push(
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new DetalleEvento(
                                          idevento: widget.list[i]
                                              ['idnotificaciones'],
                                          idproyecto: widget.idproyecto,
                                        )),
                              ),
                            },
                        child: Column(
                          children: [
                            if (widget.list != null)
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
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              new Text(
                                                widget.list[i]['titulo'] + ": ",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                widget.list[i]['descripcion'],
                                                style:
                                                    TextStyle(fontSize: 18.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ])),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 20),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Icon(
                                            Icons.date_range,
                                            color: colorappbar2,
                                          ),
                                          if (widget.list[i]['fechaevento2'] !=
                                              null)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12, right: 12.0),
                                              child: Text(
                                                widget.list[i]['fechaevento2'],
                                                style:
                                                    TextStyle(fontSize: 18.0),
                                              ),
                                            ),
                                          Icon(
                                            Icons.access_time_sharp,
                                            color: colorappbar2,
                                          ),
                                          if (widget.list[i]['hora'] != null)
                                            Text(
                                              widget.list[i]['hora'],
                                              style: TextStyle(fontSize: 18.0),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: colorappbar2,
                                  ),
                                ],
                              )
                          ],
                        )),
                  );
                }),
          ),
        ],
      );
    }
  }
}

// class listarev extends StatefulWidget {
//   final List list;
//   final String idproyecto;

//   const listarev({Key key, this.list, this.idproyecto}) : super(key: key);
//   @override
//   _listarevState createState() => _listarevState();
// }

// class _listarevState extends State<listareventos> {
//   @override
//   Widget build(BuildContext context) {
    
//   }
// }
