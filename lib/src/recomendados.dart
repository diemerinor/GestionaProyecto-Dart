import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/buscarcontactos.dart';
import 'package:gestionaproyecto/src/detallecontacto.dart';
import 'package:http/http.dart' as http;
import 'package:expansion_tile_card/expansion_tile_card.dart';

import 'dart:async';
import 'dart:convert';

import '../main.dart';

class Contactos extends StatefulWidget {
  final String idusuario;

  const Contactos({Key key, this.idusuario}) : super(key: key);
  @override
  _ContactosState createState() => _ContactosState();
}

class _ContactosState extends State<Contactos> {
  String url2 = 'http://gestionaproyecto.com/phpproyectotitulo/getAmistad.php';
  bool botonagregar = false;
  TextEditingController controllerbuscar = new TextEditingController();

  Future<List> getContactos() async {
    final response =
        await http.post(Uri.parse(url2), body: {"idusuario": widget.idusuario});
    return json.decode(response.body);
  }

  deleteContacto() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorappbar,
          title: Text("Contactos"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: Icon(
                  Icons.group_add,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    this.botonagregar = !botonagregar;
                    print(botonagregar);
                  });
                },
              ),
            )
          ],
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Mis contactos",
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
  Future<List> eliminarAmistad(idusuario1) async {
    String url3 =
        'http://gestionaproyecto.com/phpproyectotitulo/EliminarAmistad.php';
    final response = await http.post(Uri.parse(url3),
        body: {"idusuario1": idusuario1, "idusuario2": identificadorusuario});
  }

  showAlertDialog(BuildContext context, auxiliar) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continuar"),
      onPressed: () {
        eliminarAmistad(auxiliar);

        Navigator.of(context, rootNavigator: true).pop('dialog');
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Contactos(
                      idusuario: identificadorusuario,
                    )));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("??Est??s seguro de eliminar a tu contacto? "),
      actions: [
        cancelButton,
        continueButton,
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
                                              // GestureDetector(
                                              //   child: Card(
                                              //     child: Padding(
                                              //       padding:
                                              //           const EdgeInsets.all(
                                              //               8.0),
                                              //       child: Text("Invitar"),
                                              //     ),
                                              //   ),
                                              // ),
                                              GestureDetector(
                                                onTap: () => {
                                                  setState(() {
                                                    this.botonagregar =
                                                        !botonagregar;
                                                    print(botonagregar);
                                                  }),
                                                  showAlertDialog(
                                                      context,
                                                      widget.list[i]
                                                          ['idusuario']),
                                                },
                                                child: Card(
                                                  color: Colors.redAccent,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Eliminar contacto",
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
                    // if ((widget.list[i]['idusuario'] != widget.idusuario))
                    //   GestureDetector(
                    //     onTap: () => Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => DetallesContacto(
                    //                   list: widget.list,
                    //                   index: i,
                    //                 ))),
                    //     child: Card(
                    //       child: Container(
                    //         width: MediaQuery.of(context).size.width * 0.9,
                    //         height: MediaQuery.of(context).size.height * 0.07,
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Row(
                    //             children: [
                    //               Text(
                    //                 widget.list[i]['nombreusuario'] +
                    //                     " " +
                    //                     widget.list[i]['apellidos'],
                    //                 style: TextStyle(fontSize: 20),
                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.only(left: 8.0),
                    //                 child: Icon(
                    //                   Icons.message,
                    //                   color: Colors.red,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
