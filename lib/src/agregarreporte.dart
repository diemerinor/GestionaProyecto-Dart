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

int cantidadsecciones;

class Agregarreporte extends StatefulWidget {
  final String idproyecto;

  const Agregarreporte({Key key, this.idproyecto}) : super(key: key);
  @override
  _AgregarreporteState createState() => _AgregarreporteState();
}

class _AgregarreporteState extends State<Agregarreporte> {
  String url =
      'http://gestionaproyecto.com/phpproyectotitulo/InsertReporte.php';
  var datauser2;

  TextEditingController controllerusuario = new TextEditingController();
  TextEditingController controllerdescripcion = new TextEditingController();
  final dateController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    dateController.dispose();
    super.dispose();
  }

  String fechafinal;

  Future<List> insertreporte() async {
    DateTime fechahoy = DateTime.now();
    String auxfecha = fechahoy.toString();
    final response = await http.post(Uri.parse(url), body: {
      "fechahoy": auxfecha,
      "fechareporte": variablephp,
      "idseccion": seccionseleccionada,
      "metrosavanzados": controllerusuario.text,
      "idusuario": identificadorusuario,
      "idproyecto": widget.idproyecto,
      "descripcion": controllerdescripcion.text,
    });
  }

  List names = List();
  List unidades = List();

  Future<List> getSecciones() async {
    String url3 =
        'http://gestionaproyecto.com/phpproyectotitulo/getSecciones.php';
    final response = await http.post(Uri.parse(url3), body: {
      "idproyecto": widget.idproyecto,
    });
    datauser2 = json.decode(response.body);
    setState(() {
      names = datauser2;
    });

    return datauser2;
  }

  Future<List> getUnidades() async {
    String url4 = 'http://gestionaproyecto.com/phpproyectotitulo/getUnidad.php';
    final response = await http.get(
      Uri.parse(url4),
    );
    var datauser3 = json.decode(response.body);
    setState(() {
      unidades = datauser3;
    });

    int cantidadunidades = datauser3.length;
    print("Actualmente existen $cantidadunidades unidadesdemedida");

    return datauser3;
  }

  String textofecha;
  DateTime fechareporte;
  String fechass;
  String variablephp;
  @override
  void initState() {
    super.initState();
    getSecciones();
    getUnidades();
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

  showAlertDialog2(BuildContext context) {
    // set up the buttons

    Widget continueButton = FlatButton(
      child: Text("Continuar"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    GestionAvance(idproyecto: widget.idproyecto)));
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
        insertreporte();
        Navigator.of(context, rootNavigator: true).pop('dialog');
        showAlertDialog2(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("¿Está seguro de subir el reporte? "),
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
        title: Text("Ingresa un reporte"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 10,
            child: Center(
              child: Form(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: colorappbar,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Seleccione sección:",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 10)),
                      new DropdownButton<String>(
                        value: seccionseleccionada,
                        hint: Text("Seleccione sección"),
                        items: names.map((list) {
                          return new DropdownMenuItem<String>(
                            child: new Text(list['nombreseccion']),
                            value: list['idseccion'].toString(),
                          );
                        }).toList(),
                        onChanged: (value2) {
                          setState(() {
                            seccionseleccionada = value2;
                            print("se selecciono el valor $value2");
                          });
                        },
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 10)),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: colorappbar,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Cantidad:",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 10)),
                      TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.singleLineFormatter
                        ],
                        keyboardType: TextInputType.number,
                        controller: controllerusuario,
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 10)),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: colorappbar,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Fecha reporte:",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 10)),
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
                        width: MediaQuery.of(context).size.width,
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

                              textofecha = fechafinal.toString();
                              final DateFormat formatter2 =
                                  DateFormat('dd-MM-yyyy');
                              String fechafinal3 =
                                  formatter2.format(fechareporte);
                              setState(() {
                                final DateFormat formatter2 =
                                    DateFormat('dd-MM-yyyy');
                                String fechafinal2 =
                                    formatter2.format(fechareporte);

                                textofecha = fechafinal2.toString();
                              });

                              variablephp = fechafinal3.toString();
                              print("la fecha seleccionada es $fechafinal");
                            }
                          },
                          decoration: InputDecoration(hintText: textofecha),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 10)),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: colorappbar,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Descripción reporte:",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 10)),
                      TextField(
                        maxLines: null,
                        controller: controllerdescripcion,
                        decoration:
                            InputDecoration(hintText: 'Ingrese descripción'),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 10)),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: new RaisedButton(
                          child: new Text(
                            "Ingresar reporte",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: colorappbar,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: () {
                            if (controllerdescripcion.text == null ||
                                controllerdescripcion.text == '' ||
                                controllerusuario.text == null ||
                                controllerusuario.text == '' ||
                                variablephp == null ||
                                seccionseleccionada == null) {
                              showAlertDialogerror(context);
                            } else {
                              DateTime fechaaux = DateTime.now();
                              if (fechaaux.difference(fechareporte).inDays >=
                                  0) {
                                print(fechaaux.difference(fechareporte).inDays);
                                showAlertDialog(context);
                              } else {
                                showAlertDialogerrorfecha(context);
                                print(fechaaux.difference(fechareporte).inDays);
                              }
                            }

                            //login();
                          },
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 10)),
                      Text(mensaje,
                          style: TextStyle(fontSize: 25.0, color: Colors.red)),
                    ],
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
