import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/detallemovimientos.dart';
import 'package:gestionaproyecto/src/editarseccion.dart';
import 'package:gestionaproyecto/src/listareventos.dart';
import 'package:http/http.dart' as http;

import 'editarevento.dart';
import 'gestionfinanciera.dart';
import 'gestionseccion.dart';
import 'dart:async';
import 'dart:convert';

class DetalleEvento extends StatefulWidget {
  final String idevento;
  final String idproyecto;
  DetalleEvento({this.idevento, this.idproyecto});

  @override
  _DetalleEventoState createState() => _DetalleEventoState();
}

class _DetalleEventoState extends State<DetalleEvento> {
  String url = 'http://gestionaproyecto.com/phpproyectotitulo/DeleteEvento.php';
  String porcentaje = 'Cargando...';
  String avanzado = 'Cargando...';
  String titulo, descripcion, hora, fechaevento;

  Future<List> deletemov() async {
    print("aloooooo" + widget.idevento);
    final response =
        await http.post(Uri.parse(url), body: {"idevento": widget.idevento});
  }

  showAlertDialog(BuildContext context) {
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
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        deletemov();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListarEventos(
                      idproyecto: widget.idproyecto,
                    )));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("¿Está seguro de eliminar el evento? "),
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

  Future<List> getinfomov() async {
    String url7 =
        'http://gestionaproyecto.com/phpproyectotitulo/getInfoEvento.php';
    print("el idevento es" + widget.idevento);
    print("el idproyecto es" + widget.idproyecto);

    final response = await http.post(Uri.parse(url7),
        body: {"idevento": widget.idevento, "idproyecto": widget.idproyecto});

    var datauser = json.decode(response.body);
    setState(() {
      titulo = datauser[0]['titulo'];
      descripcion = datauser[0]['descripcion'];
      hora = datauser[0]['hora'];
      fechaevento = datauser[0]['fechaevento2'];
    });
    return datauser;
  }

  @override
  void initState() {
    super.initState();
    getinfomov();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorfondo,
        appBar: AppBar(
          backgroundColor: colorappbar,
          title: new Text("Información evento"),
        ),
        body: Container(
          child: new Center(
              child: new Column(
            children: <Widget>[
              if (titulo == null)
                Text("Cargando información...")
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new Padding(
                      padding: const EdgeInsets.only(
                        top: 30.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25),
                      child: new Text(
                        titulo,
                        style: new TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25),
                      child: new Text(
                        descripcion,
                        style: new TextStyle(fontSize: 22.0),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            child: Icon(Icons.date_range),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10.0)),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              "Fecha :\n" + fechaevento,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            child: Icon(Icons.alarm),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10.0)),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              "Hora :\n" + hora,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RaisedButton(
                          child: Text(
                            "Editar",
                            style: TextStyle(fontSize: 20),
                          ),
                          color: colorappbar,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditarEvento(
                                        idproyecto: widget.idproyecto,
                                        idevento: widget.idevento)));
                          },
                        ),
                        Padding(padding: EdgeInsets.only(right: 16)),
                        RaisedButton(
                          onPressed: () => {
                            showAlertDialog(context),
                          },
                          child:
                              Text("Eliminar", style: TextStyle(fontSize: 20)),
                          color: colorappbar,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ],
                )
            ],
          )),
        ));
  }
}
