import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/crearseccion.dart';
import 'package:gestionaproyecto/src/detalle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'detalleseccion.dart';

String mensajeseccion;

class ListarSecciones extends StatefulWidget {
  final String idproyecto;

  ListarSecciones({Key key, this.idproyecto}) : super(key: key);
  @override
  _ListarSeccionesState createState() => _ListarSeccionesState();
}

class _ListarSeccionesState extends State<ListarSecciones> {
  int cantidadsecciones;
  Future<List> getSecciones() async {
    String url3 =
        'http://gestionaproyecto.com/phpproyectotitulo/getSecciones.php';
    final response = await http.post(Uri.parse(url3), body: {
      "idproyecto": widget.idproyecto,
    });

    var datauser2 = json.decode(response.body);

    cantidadsecciones = datauser2.length;
    print("Actualmente existen $cantidadsecciones secciones");

    return datauser2;
  }

  @override
  void initState() {
    super.initState();
    mensajeseccion = "Cargando secciones...";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text("Secciones del proyecto"),
          backgroundColor: colorappbar,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: Icon(
                  Icons.add_comment,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CrearSeccion(
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
                  future: getSecciones(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    if (snapshot.hasData && cantidadsecciones != 0) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: colorappbar,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Administra tus secciones',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: new listarsecciones(
                              list: snapshot.data,
                              idproyecto: widget.idproyecto,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              mensajeseccion ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: colorappbar2),
                            ),
                            Text(
                              'En la parte superior derecha, tienes la opción de crear un evento',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
            ),
          ],
        ));
  }
}

class listarsecciones extends StatefulWidget {
  final List list;
  final String idproyecto;

  const listarsecciones({Key key, this.list, this.idproyecto})
      : super(key: key);
  @override
  _listarseccionesState createState() => _listarseccionesState();
}

class _listarseccionesState extends State<listarsecciones> {
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
                        onTap: () => Navigator.of(context).push(
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new DetalleSeccion(
                                        list: widget.list,
                                        index: i,
                                      )),
                            ),
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
                                                widget.list[i]
                                                        ['nombreseccion'] +
                                                    ": ",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                widget.list[i]
                                                    ['descripcionseccion'],
                                                style:
                                                    TextStyle(fontSize: 18.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ])),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20.0,
                                          height: 20.0,
                                          decoration: new BoxDecoration(
                                            color: verde,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 5.0)),
                                        Text("Click para más información"),
                                      ],
                                    ),
                                  ),
                                  Divider(),
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
