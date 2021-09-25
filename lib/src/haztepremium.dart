import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/detallecontacto.dart';
import 'package:http/http.dart' as http;
import 'package:expansion_tile_card/expansion_tile_card.dart';

import 'dart:async';
import 'dart:convert';

import '../main.dart';

class HaztePremium extends StatefulWidget {
  final String idusuario;

  const HaztePremium({Key key, this.idusuario}) : super(key: key);
  @override
  _HaztePremiumState createState() => _HaztePremiumState();
}

class _HaztePremiumState extends State<HaztePremium> {
  String url =
      'http://gestionaproyecto.com/phpproyectotitulo/InsertSolicitud.php';
  Future<List> haztePremium(planseleccionado) async {
    final response = await http.post(Uri.parse(url), body: {
      "idusuario": widget.idusuario,
      "planseleccionado": planseleccionado
    });
    showAlertDialog(context);
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Continuar"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
          "Se realizó una solicitud de Demostración, serás contactado dentro de los próximos días"),
      actions: [
        cancelButton,
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorappbar,
          title: Text("Suscripciones"),
        ),
        body: Center(
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: ExpansionTileCard(
                            baseColor: colorappbar,
                            expandedColor: colorappbar,
                            title: Row(
                              children: [
                                Text(
                                  "Plan Medium",
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              height: 120,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.yellow,
                                                      width: 3),
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: new AssetImage(
                                                          'assets/images/letram.jpg'))),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "- Colabora con hasta 50 usuarios",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text("- Crea hasta 3 proyectos",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              new RaisedButton(
                                                child: new Text(
                                                    "Solicitar contacto"),
                                                color: Colors.white,
                                                textColor: Colors.black,
                                                shape:
                                                    new RoundedRectangleBorder(
                                                        borderRadius:
                                                            new BorderRadius
                                                                    .circular(
                                                                30.0)),
                                                onPressed: () {
                                                  haztePremium("Plan Medium");
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: ExpansionTileCard(
                            baseColor: colorappbar,
                            expandedColor: colorappbar,
                            title: Row(
                              children: [
                                Text(
                                  "Plan Premium",
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
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              height: 120,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.yellow,
                                                      width: 3),
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: new AssetImage(
                                                          'assets/images/letrap.jpg'))),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "- Colabora con más de 100 usuarios",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                  "- Crea proyectos ilimitados",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              new RaisedButton(
                                                child: new Text(
                                                    "Solicitar contacto"),
                                                color: Colors.white,
                                                textColor: Colors.black,
                                                shape:
                                                    new RoundedRectangleBorder(
                                                        borderRadius:
                                                            new BorderRadius
                                                                    .circular(
                                                                30.0)),
                                                onPressed: () {
                                                  haztePremium("Plan Premium");
                                                },
                                              ),
                                            ],
                                          ),
                                        )
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
              )
            ],
          ),
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
                                              Card(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text("Invitar"),
                                                ),
                                              ),
                                              Card(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child:
                                                      Text("Eliminar contacto"),
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
