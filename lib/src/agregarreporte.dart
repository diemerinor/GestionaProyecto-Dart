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
    final response = await http.post(Uri.parse(url), body: {
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
        insertreporte();
        Navigator.pop(context);
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
        title: Text("Ingresa un reporte"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 10,
            child: Center(
              child: Form(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ListView(
                        children: <Widget>[
                          new Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            padding: EdgeInsets.only(top: 23),
                            child: ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, bottom: 12),
                                    child: Container(
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
                                  ),
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, bottom: 12),
                                    child: Container(
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
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 5)
                                            ]),
                                        child: TextFormField(
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .singleLineFormatter
                                          ],
                                          keyboardType: TextInputType.number,
                                          controller: controllerusuario,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Padding(
                                  //   padding:
                                  //       const EdgeInsets.only(top: 12, bottom: 12),
                                  //   child: Container(
                                  //     color: colorappbar,
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.all(5.0),
                                  //       child: Text(
                                  //         "Unidad de medida:",
                                  //         style: TextStyle(
                                  //             fontSize: 18,
                                  //             color: Colors.white,
                                  //             fontWeight: FontWeight.bold),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // Column(
                                  //   children: [
                                  //     Container(
                                  //       width:
                                  //           MediaQuery.of(context).size.width * 0.7,
                                  //       height:
                                  //           MediaQuery.of(context).size.width * 0.1,
                                  //       child: new DropdownButton<String>(
                                  //         value: unidadseleccionada,
                                  //         hint: Text("Seleccione unidad"),
                                  //         items: unidades.map((list) {
                                  //           return new DropdownMenuItem<String>(
                                  //             child: new Text(list['nombreunidad']),
                                  //             value: list['idunidaddemedida']
                                  //                 .toString(),
                                  //           );
                                  //         }).toList(),
                                  //         onChanged: (value) {
                                  //           setState(() {
                                  //             unidadseleccionada = value;
                                  //           });
                                  //         },
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, bottom: 12),
                                    child: Container(
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
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
                                          fechafinal =
                                              formatter.format(fechareporte);

                                          textofecha = fechafinal.toString();
                                          final DateFormat formatter2 =
                                              DateFormat('dd-MM-yyyy');
                                          String fechafinal3 =
                                              formatter2.format(fechareporte);

                                          variablephp = fechafinal3.toString();
                                          print(
                                              "la fecha seleccionada es $fechafinal");
                                        }
                                      },
                                      decoration:
                                          InputDecoration(hintText: textofecha),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, bottom: 12),
                                    child: Container(
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
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.17,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 5)
                                        ]),
                                    child: TextField(
                                      maxLines: 4,
                                      controller: controllerdescripcion,
                                      decoration: InputDecoration(
                                          hintText: 'Ingrese descripción'),
                                    ),
                                  ),
                                  Container(
                                    width: 120,
                                    child: new RaisedButton(
                                      child: new Text("Ingresar reporte"),
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
                                  Text(mensaje,
                                      style: TextStyle(
                                          fontSize: 25.0, color: Colors.red)),
                                ]),
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
    );
  }
}
