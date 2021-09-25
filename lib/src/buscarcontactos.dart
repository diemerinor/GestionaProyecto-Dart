import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/detallecontacto.dart';
import 'package:http/http.dart' as http;
import 'package:expansion_tile_card/expansion_tile_card.dart';

import 'dart:async';
import 'dart:convert';

import '../main.dart';
import 'haztepremium.dart';

class BuscarContactos extends StatefulWidget {
  final String idusuario;
  final String identificadorusuario;

  const BuscarContactos({Key key, this.idusuario, this.identificadorusuario})
      : super(key: key);
  @override
  _BuscarContactosState createState() => _BuscarContactosState();
}

class _BuscarContactosState extends State<BuscarContactos> {
  String url2 =
      'http://gestionaproyecto.com/phpproyectotitulo/BuscarUsuario.php';

  TextEditingController controllerbuscar = new TextEditingController();
  TextEditingController controllerusuario = new TextEditingController();

  Future<List> getContactos() async {
    final response = await http
        .post(Uri.parse(url2), body: {"nombreusuario": widget.idusuario});
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorappbar,
          title: Text("Buscador"),
          actions: [],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Resultados con el nombre '" + widget.idusuario + "'",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: new FutureBuilder<List>(
                  future: getContactos(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? new listarcontactos(
                            list: snapshot.data,
                            idusuario: widget.idusuario,
                          )
                        : new Center(
                            child: new CircularProgressIndicator(),
                          );
                  }),
            ),
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
  Future<List> solicitudAmistad(idusuario1) async {
    String url3 =
        'http://gestionaproyecto.com/phpproyectotitulo/SolicitarAmistad.php';
    final response = await http.post(Uri.parse(url3),
        body: {"idusuario1": identificadorusuario, "idusuario2": idusuario1});
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
                                              Visibility(
                                                  visible: botonagregar,
                                                  child: Column(
                                                    children: [
                                                      Card(
                                                        color: Colors.green,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            "Solicitud enviada",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              Visibility(
                                                visible: !botonagregar,
                                                child: GestureDetector(
                                                  onTap: () => {
                                                    setState(() {
                                                      this.botonagregar =
                                                          !botonagregar;
                                                      print(botonagregar);
                                                    }),
                                                    solicitudAmistad(widget
                                                        .list[i]['idusuario'])
                                                  },
                                                  child: Card(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text("Invitar"),
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
