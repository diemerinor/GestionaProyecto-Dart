import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/gestionarproyecto.dart';
import 'package:gestionaproyecto/src/gestionavance.dart';
import 'package:gestionaproyecto/src/listartrabajadores.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';

import 'package:flutter/services.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'dart:async';
import 'dart:convert';

import 'detalleproyecto.dart';

class CrearProyecto extends StatefulWidget {
  final String idusuario;

  const CrearProyecto({Key key, this.idusuario}) : super(key: key);
  @override
  _CrearProyectoState createState() => _CrearProyectoState();
}

class _CrearProyectoState extends State<CrearProyecto> {
  String url =
      'http://gestionaproyecto.com/phpproyectotitulo/InsertProyecto.php';
  var datauser2;

  TextEditingController controllernombre = new TextEditingController();
  TextEditingController controllerdescripcion = new TextEditingController();
  final dateController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getSecciones();
  }

  String fechafinal;

  Future<List> insertproyecto() async {
    final response = await http.post(Uri.parse(url), body: {
      "idusuario": identificadorusuario,
      "nombreproyecto": controllernombre.text,
      "descripcionproyecto": controllerdescripcion.text,
      "idcomuna": seccionseleccionada,
    });
  }

  List names = List();
  List unidades = List();

  Future<List> getSecciones() async {
    String url3 =
        'http://gestionaproyecto.com/phpproyectotitulo/getComunas.php';
    final response = await http.get(
      Uri.parse(url3),
    );
    datauser2 = json.decode(response.body);
    print(datauser2);
    setState(() {
      names = datauser2;
    });

    return datauser2;
  }

  String textofecha;
  DateTime fechareporte;
  String fechass;
  String variablephp;

  showAlertDialog2(BuildContext context) {
    // set up the buttons

    Widget continueButton = FlatButton(
      child: Text("Continuar"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             GestionAvance(idproyecto: widget.idproyecto)));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Se ha subido correctamente"),
      actions: [
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
        insertproyecto();
        Navigator.pop(context);
        showAlertDialog2(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("¿Está seguro de crear el proyecto? "),
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

  String mensaje = '';
  String rol;
  bool fechaeditable = false;

  bool _checkbox = true;
  bool _checkboxListTile = false;
  String seccionseleccionada;
  String unidadseleccionada;

  List idssecciones = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(46, 12, 21, 20),
        title: Text("Crea tu proyecto"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Card(
                child: Center(
                  child: Form(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            width: MediaQuery.of(context).size.width * 0.7,
                            padding: EdgeInsets.only(top: 23),
                            child: ListView(
                              children: [
                                Text(
                                  "Nombre proyecto",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                TextFormField(
                                  controller: controllernombre,
                                  decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.account_box,
                                        color: Colors.black,
                                      ),
                                      hintText: 'Ingrese su correo o telefono'),
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 20)),
                                Text(
                                  "Descripción",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                TextFormField(
                                  controller: controllerdescripcion,
                                  decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.account_box,
                                        color: Colors.black,
                                      ),
                                      hintText: 'Ingrese su correo o telefono'),
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 20)),
                                Text(
                                  "Comuna",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                DropdownButton<String>(
                                  value: seccionseleccionada,
                                  hint: Text("Seleccione comuna"),
                                  items: names.map((list) {
                                    return new DropdownMenuItem<String>(
                                      child: new Text(list['nombrecomuna']),
                                      value: list['idcomuna'].toString(),
                                    );
                                  }).toList(),
                                  onChanged: (value2) {
                                    setState(() {
                                      seccionseleccionada = value2;
                                      print("se selecciono el valor $value2");
                                    });
                                  },
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 20)),
                                Container(
                                  width: 90,
                                  child: new RaisedButton(
                                    child: new Text("Crear proyecto"),
                                    color: Colors.greenAccent,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0)),
                                    onPressed: () {
                                      showAlertDialog(context);

                                      //login();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
