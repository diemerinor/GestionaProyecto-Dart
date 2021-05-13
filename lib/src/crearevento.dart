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

class CrearEvento extends StatefulWidget {
  final String idproyecto;

  const CrearEvento({Key key, this.idproyecto}) : super(key: key);

  @override
  _CrearEventoState createState() => _CrearEventoState();
}

class _CrearEventoState extends State<CrearEvento> {
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

  DateTime fechadeahora = DateTime.now();
  String textofecha;
  DateTime fechareporte;
  TimeOfDay horareporte;

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

  Future<List> insertingreso() async {
    String aux = controllerdescripcion.text;
    int monto = int.parse(aux);
    int total = cajafinal + monto;
    String finaltotal = total.toString();
    final response = await http.post(Uri.parse(url), body: {
      "idusuario": identificadorusuario,
      "titulo": controllernombre.text,
      "monto": controllerdescripcion.text,
      "total": finaltotal,
      "fechareporte": variablephp,
      "idproyecto": widget.idproyecto
    });
  }

  String fechafinal;
  String mensaje = '';
  String rol;
  bool fechaeditable = false;

  bool _checkbox = true;
  bool _checkboxListTile = false;
  String seccionseleccionada;
  String unidadseleccionada;

  List idssecciones = List();
  String _selectedTime;
  String _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorappbar,
        title: Text("Crear evento"),
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
                            height: MediaQuery.of(context).size.height * 0.6,
                            width: MediaQuery.of(context).size.width * 0.7,
                            padding: EdgeInsets.only(top: 23),
                            child: ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12, bottom: 12),
                                  child: Container(
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
                                  decoration: InputDecoration(hintText: ''),
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 20)),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12, bottom: 12),
                                  child: Container(
                                    color: colorappbar,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "Descripción:",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  maxLines: null,
                                  controller: controllerdescripcion,
                                  decoration: InputDecoration(hintText: ''),
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 20)),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12, bottom: 12),
                                  child: Container(
                                    color: colorappbar,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "Fecha evento:",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  padding: EdgeInsets.all(8),
                                  child: TextField(
                                    enabled: true,
                                    readOnly: true,
                                    controller: dateController,
                                    onTap: () async {
                                      var date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100));

                                      var hour = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                          initialEntryMode:
                                              TimePickerEntryMode.input,
                                          builder: (context, _) {
                                            return MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        // Using 12-Hour format
                                                        alwaysUse24HourFormat:
                                                            true),
                                                // If you want 24-Hour format, just change alwaysUse24HourFormat to true
                                                child: _);
                                          });

                                      if (date != null && hour != null) {
                                        fechareporte = date;

                                        //horareporte = hour;
                                        //String hola = horareporte.toString();

                                        setState(() {
                                          _selectedTime = hour.format(context);

                                          textofecha = variablephp.toString();
                                          //variablephp = fechafinal.toString();
                                        });
                                        print(
                                            "la fecha seleccionada es $fechareporte y la hora $_selectedTime");
                                      }
                                    },
                                    decoration:
                                        InputDecoration(hintText: textofecha),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
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
