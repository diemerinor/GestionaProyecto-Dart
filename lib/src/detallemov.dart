import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';

import 'editarmovimiento.dart';
import 'gestionfinanciera.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class DetalleMov extends StatefulWidget {
  final String idmov;
  final String idproyecto;
  DetalleMov({this.idmov, this.idproyecto});

  @override
  _DetalleMovState createState() => _DetalleMovState();
}

class _DetalleMovState extends State<DetalleMov> {
  String url = 'http://gestionaproyecto.com/phpproyectotitulo/DeleteMov.php';
  String porcentaje = 'Cargando...';
  String avanzado = 'Cargando...';
  String titulo, ingreso, fechapublicacion, idtipomovimiento;

  Future<List> deletemov() async {
    print("aloooooo" + widget.idmov);
    final response = await http
        .post(Uri.parse(url), body: {"idnotificaciones": widget.idmov});
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.pop(context);
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
                builder: (context) => GestionFinanciera(
                      idproyecto: widget.idproyecto,
                    )));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("¿Está seguro de eliminar el movimiento financiero? "),
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
        'http://gestionaproyecto.com/phpproyectotitulo/getInfoMov.php';
    final response = await http.post(Uri.parse(url7), body: {
      "idmov": widget.idmov,
    });

    var datauser = json.decode(response.body);
    setState(() {
      titulo = datauser[0]['titulo'];
      ingreso = datauser[0]['ingreso'];
      fechapublicacion = datauser[0]['fechapub'];
      idtipomovimiento = datauser[0]['idtipomovimiento'];
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
          title: new Text("Información movimiento"),
        ),
        body: Container(
          child: new Center(
              child: new Column(
            children: <Widget>[
              if (titulo == null)
                Text("Cargando información...")
              else
                Column(
                  children: [
                    new Padding(
                      padding: const EdgeInsets.only(
                        top: 30.0,
                      ),
                    ),
                    new Text(
                      titulo,
                      style: new TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    new Text(
                      ingreso,
                      style: new TextStyle(fontSize: 20.0),
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
                            decoration: new BoxDecoration(
                              color: verde,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10.0)),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              "Movimiento :\n\$" + ingreso,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            decoration: new BoxDecoration(
                              color: azul,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10.0)),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              "Fecha movimiento :\n" + fechapublicacion,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 20,
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
                                    builder: (context) => EditarMovimiento(
                                          idproyecto: widget.idproyecto,
                                          idtipomovimiento: idtipomovimiento,
                                          idmovimiento: widget.idmov,
                                        )));
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
