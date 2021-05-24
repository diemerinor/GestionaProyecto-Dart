import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/gestionarproyecto.dart';
import 'package:gestionaproyecto/src/gestionavance.dart';
import 'package:gestionaproyecto/src/gestionfinanciera.dart';
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
import 'misproyectos.dart';

class RegistrarIngreso extends StatefulWidget {
  final String idproyecto;
  final int caja;

  const RegistrarIngreso({Key key, this.idproyecto, this.caja})
      : super(key: key);
  @override
  _RegistrarIngresoState createState() => _RegistrarIngresoState();
}

class _RegistrarIngresoState extends State<RegistrarIngreso> {
  String url =
      'http://gestionaproyecto.com/phpproyectotitulo/InsertIngreso.php';
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

  String textofecha;
  DateTime fechareporte;
  String fechass;
  String variablephp;
  @override
  void initState() {
    super.initState();
    fechadehoy(true);
  }

  void fechadehoy(bool value) {
    bool fechaeshoy = value;
    if (fechaeshoy == true) {
      fechareporte = DateTime.now();
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      fechafinal = formatter.format(fechareporte);
      textofecha = fechafinal.toString();
      final DateFormat formatter2 = DateFormat('yyyy-MM-dd');
      String fechafinal2 = formatter2.format(fechareporte);
      variablephp = fechafinal2.toString();
    }
  }

  String fechafinal;

  Future<List> insertingreso() async {
    String aux = controllerdescripcion.text;
    int monto = int.parse(aux);
    int total = cajafinal + monto;
    DateTime fechahoyy = DateTime.now();
    String auxfecha = fechahoyy.toString();
    String finaltotal = total.toString();

    final response = await http.post(Uri.parse(url), body: {
      "fechahoy": auxfecha,
      "idusuario": identificadorusuario,
      "titulo": controllernombre.text,
      "monto": controllerdescripcion.text,
      "total": finaltotal,
      "fechareporte": variablephp,
      "idproyecto": widget.idproyecto
    });
  }

  showAlertDialog2(BuildContext context) {
    // set up the buttons

    Widget continueButton = FlatButton(
      child: Text("Continuar"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GestionFinanciera(
                      idproyecto: widget.idproyecto,
                    )));
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
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continuar"),
      onPressed: () {
        insertingreso();
        Navigator.of(context, rootNavigator: true).pop('dialog');
        showAlertDialog2(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("¿Está seguro de insertar el ingreso? "),
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

  showAlertDialogerror(BuildContext context) {
    // set up the buttons

    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text("Debe completar todos los datos"),
      actions: [
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogerrorfecha(BuildContext context) {
    // set up the buttons

    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text("Debe introducir una fecha menor o igual al día de hoy"),
      actions: [
        cancelButton,
      ],
    );

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
        backgroundColor: colorappbar,
        title: Text("Registra ingreso"),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: colorappbar,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Título:",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: controllernombre,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.account_box,
                                  color: Colors.black,
                                ),
                                hintText: ''),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 20)),
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: colorappbar,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Monto:",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: controllerdescripcion,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.account_box,
                                color: Colors.black,
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.singleLineFormatter
                            ],
                            keyboardType: TextInputType.number,
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 20)),
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: colorappbar,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Fecha ingreso:",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Fecha de hoy",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Checkbox(
                                value: _checkbox,
                                onChanged: (value) {
                                  fechadehoy(value);
                                  setState(() {
                                    _checkbox = !_checkbox;
                                    fechaeditable = !value;
                                  });
                                },
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            padding: EdgeInsets.all(8),
                            child: TextField(
                              enabled: fechaeditable,
                              readOnly: true,
                              controller: dateController,
                              onTap: () async {
                                var date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));
                                if (date != null) {
                                  fechareporte = date;

                                  final DateFormat formatter =
                                      DateFormat('dd-MM-yyyy');
                                  fechafinal = formatter.format(fechareporte);
                                  setState(() {
                                    textofecha = fechafinal.toString();
                                    //variablephp = fechafinal.toString();
                                  });

                                  final DateFormat formatter2 =
                                      DateFormat('yyyy-MM-dd');
                                  String fechafinal3 =
                                      formatter2.format(fechareporte);

                                  variablephp = fechafinal3.toString();
                                  print("la fecha seleccionada es $textofecha");
                                }
                              },
                              decoration: InputDecoration(hintText: textofecha),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: new RaisedButton(
                                child: new Text(
                                  "Insertar ingreso",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: colorappbar,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                onPressed: () {
                                  if (controllerdescripcion.text == null ||
                                      controllerdescripcion.text == '' ||
                                      controllernombre.text == null ||
                                      controllernombre.text == '' ||
                                      fechareporte == null) {
                                    showAlertDialogerror(context);
                                  } else {
                                    DateTime fechaaux = DateTime.now();
                                    if (fechaaux
                                            .difference(fechareporte)
                                            .inDays >=
                                        0) {
                                      print(fechaaux
                                          .difference(fechareporte)
                                          .inDays);
                                      showAlertDialog(context);
                                    } else {
                                      showAlertDialogerrorfecha(context);
                                      print(fechaaux
                                          .difference(fechareporte)
                                          .inDays);
                                    }
                                  }

                                  //login();
                                },
                              ),
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
