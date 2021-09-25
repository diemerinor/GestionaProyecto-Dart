import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/buscarcontactos.dart';
import 'package:gestionaproyecto/src/detallecontacto.dart';
import 'package:http/http.dart' as http;
import 'package:expansion_tile_card/expansion_tile_card.dart';

import 'dart:async';
import 'dart:convert';

import '../main.dart';

class Solicitudes extends StatefulWidget {
  final String idusuario;

  const Solicitudes({Key key, this.idusuario}) : super(key: key);
  @override
  _SolicitudesState createState() => _SolicitudesState();
}

class _SolicitudesState extends State<Solicitudes> {
  String url2 =
      'http://gestionaproyecto.com/phpproyectotitulo/getSolicitud.php';
  bool botonagregar = false;
  TextEditingController controllerbuscar = new TextEditingController();
  var solicitudes = [];

  Future<List> getContactos() async {
    final response = await http
        .post(Uri.parse(url2), body: {"idusuario": identificadorusuario});
    solicitudes = json.decode(response.body);
    print(solicitudes);
    return solicitudes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorappbar,
          title: Text("Solicitudes"),
        ),
        body: Column(
          children: [
            Visibility(
                visible: botonagregar,
                child: Column(
                  children: [
                    TextFormField(
                        controller: controllerbuscar,
                        decoration: InputDecoration(
                          hintText: 'Agregar contacto',
                          icon: Icon(
                            Icons.east,
                            color: Colors.black,
                          ),
                        )),
                    RaisedButton(
                        child: Text(
                          "Buscar",
                          style: TextStyle(fontSize: 20),
                        ),
                        textColor: Colors.white,
                        color: colorappbar,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BuscarContactos(
                                        idusuario: controllerbuscar.text,
                                        identificadorusuario:
                                            identificadorusuario,
                                      )));
                          // sharedPreferences.clear();
                          // sharedPreferences.commit();
                        }),
                  ],
                )),
            Expanded(
              child: new FutureBuilder<List>(
                  future: getContactos(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    if (snapshot.hasData) {
                      if (solicitudes != null && !solicitudes.isEmpty) {
                        return new listarcontactos(
                          list: snapshot.data,
                          idusuario: widget.idusuario,
                        );
                      } else {
                        return Center(
                            child: Text(
                          "No existen solicitudes",
                          style: TextStyle(fontSize: 25),
                        ));
                      }
                    } else {
                      return Center(
                          child: Text(
                        "Cargando solicitudes...",
                        style: TextStyle(fontSize: 25),
                      ));
                    }
                  }),
            )
          ],
        ));
  }
}

class listarcontactos extends StatefulWidget {
  final List list;
  final String idusuario;

  const listarcontactos({Key key, this.list, this.idusuario}) : super(key: key);
  @override
  _listarcontactosState createState() => _listarcontactosState();
}

class _listarcontactosState extends State<listarcontactos> {
  Future<List> eliminarAmistad(idusuario1) async {
    String url3 =
        'http://gestionaproyecto.com/phpproyectotitulo/RechazarSolicitud.php';
    final response = await http.post(Uri.parse(url3),
        body: {"idusuario": idusuario1, "idusuario2": identificadorusuario});
  }

  Future<List> aceptarAmistad(idusuario1) async {
    String url3 =
        'http://gestionaproyecto.com/phpproyectotitulo/AceptarSolicitud.php';
    final response = await http.post(Uri.parse(url3),
        body: {"idusuario": idusuario1, "idusuario2": identificadorusuario});
  }

  bool botonagregar = false;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: widget.list == null ? 0 : widget.list.length,
        itemBuilder: (context, i) {
          int idusuarioid = int.parse(widget.list[i]['idusuario']);

          return Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if ((widget.list[i]['idusuario'] != widget.idusuario))
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ExpansionTileCard(
                          baseColor: colorappbar,
                          expandedColor: colorappbar,
                          title: Row(
                            children: [
                              Text(
                                widget.list[i]['nombreusuario'] +
                                    " " +
                                    widget.list[i]['apellidos'],
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          children: <Widget>[
                            Divider(
                              thickness: 0.4,
                              height: 0.4,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (widget.list[i]['fotoperfil'] !=
                                              null)
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              height: 120,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: colorappbar,
                                                      width: 2),
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: new AssetImage(
                                                          widget.list[i]
                                                              ['fotoperfil']))),
                                            )
                                          else
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              height: 120,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.red,
                                                      width: 3),
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: new AssetImage(
                                                          'assets/images/sinfotoperfil.jpg'))),
                                            ),
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 15)),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: Text(
                                              "${widget.list[i]['acercademi']}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: Row(children: [
                                              GestureDetector(
                                                onTap: () => {
                                                  aceptarAmistad(widget.list[i]
                                                      ['idusuario']),
                                                  Navigator.pop(context),
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Solicitudes(
                                                              idusuario:
                                                                  identificadorusuario,
                                                            )),
                                                  )
                                                },
                                                child: Card(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text("Aceptar"),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => {
                                                  eliminarAmistad(widget.list[i]
                                                      ['idusuario']),
                                                  Navigator.pop(context),
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Solicitudes(
                                                              idusuario:
                                                                  identificadorusuario,
                                                            )),
                                                  )
                                                },
                                                child: Card(
                                                  color: Colors.redAccent,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Rechazar",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
