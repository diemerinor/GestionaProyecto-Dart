import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/gestionavance.dart';

import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'dart:async';
import 'dart:convert';

int cantidadsecciones;

class EditarReporte extends StatefulWidget {
  final String idproyecto;
  final String idreporteavance;

  const EditarReporte({Key key, this.idproyecto, this.idreporteavance})
      : super(key: key);
  @override
  _EditarReporteState createState() => _EditarReporteState();
}

class _EditarReporteState extends State<EditarReporte> {
  String url =
      'http://gestionaproyecto.com/phpproyectotitulo/EditarReporte.php';
  var datauser2;

  TextEditingController controllerusuario = new TextEditingController();
  TextEditingController controllerdescripcion = new TextEditingController();
  final dateController = TextEditingController();

  Future<List> getinforeporte() async {
    String url7 =
        'http://gestionaproyecto.com/phpproyectotitulo/getInfoReporte.php';
    final response = await http.post(Uri.parse(url7), body: {
      "idproyecto": widget.idproyecto,
      "idreporteavance": widget.idreporteavance
    });
    var datauser = json.decode(response.body);
    print(datauser);
    setState(() {
      seccionseleccionada = datauser[0]['idseccion'];
      controllerusuario.text = datauser[0]['metrosavanzados'];
      controllerdescripcion.text = datauser[0]['descripcionavance'];
      textofecha = datauser[0]['fechareporte'];
    });

    return datauser;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    dateController.dispose();
    super.dispose();
  }

  String fechafinal;

  Future<List> editarreporte() async {
    DateTime fechahoy = DateTime.now();
    String auxfecha = fechahoy.toString();
    print(fechafinal);
    if (fechafinal == null) {
      fechafinal = textofecha;
    }
    print(fechafinal);
    final response = await http.post(Uri.parse(url), body: {
      "fechahoy": auxfecha,
      "fechareporte": fechafinal,
      "idseccion": seccionseleccionada,
      "metrosavanzados": controllerusuario.text,
      "idusuario": identificadorusuario,
      "idproyecto": widget.idproyecto,
      "descripcion": controllerdescripcion.text,
      "idreporte": widget.idreporteavance,
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
    getinforeporte();
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
        editarreporte();
        Navigator.of(context, rootNavigator: true).pop('dialog');
        showAlertDialog2(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("¿Está seguro de editar el reporte? "),
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
        title: Text("Editar reporte de avance"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Form(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Seleccione sección (*)",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.list,
                          color: Colors.black,
                        ),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Expanded(
                          child: new DropdownButton<String>(
                            value: seccionseleccionada,
                            hint: Text("Seleccione sección"),
                            items: names.map((list) {
                              return new DropdownMenuItem<String>(
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: new Text(list['nombreseccion'])),
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
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20)),
                    Text(
                      "Descripción reporte (*)",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 10)),
                    TextField(
                      maxLines: null,
                      controller: controllerdescripcion,
                      decoration: InputDecoration(
                        hintText: 'Ingrese descripción',
                        icon: Icon(
                          Icons.description,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20)),
                    Text(
                      "Cantidad avanzada (*)",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.singleLineFormatter
                        ],
                        keyboardType: TextInputType.number,
                        controller: controllerusuario,
                        decoration: InputDecoration(
                          hintText: 'Ingrese la cantidad que se avanzó',
                          icon: Icon(
                            Icons.east,
                            color: Colors.black,
                          ),
                        )),
                    Padding(padding: EdgeInsets.only(bottom: 20)),
                    Text(
                      "Fecha del reporte de avance(*)",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          color: Colors.black,
                        ),
                        Text(
                          "Fecha de hoy",
                          style: TextStyle(fontSize: 18),
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

                              final DateFormat formatter3 =
                                  DateFormat('yyyy-MM-dd');
                              fechafinal = formatter3.format(fechareporte);

                              textofecha = fechafinal2.toString();
                            });

                            variablephp = fechafinal3.toString();
                            print("la fecha seleccionada es $fechafinal");
                          }
                        },
                        decoration: InputDecoration(hintText: textofecha),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20)),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: new RaisedButton(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: new Text(
                              "Editar reporte",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          color: colorappbar,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: () {
                            if (controllerdescripcion.text == null ||
                                controllerdescripcion.text == '' ||
                                controllerusuario.text == null ||
                                controllerusuario.text == '' ||
                                seccionseleccionada == null) {
                              showAlertDialogerror(context);
                            } else {
                              print("holaaaa");
                              DateTime fechaaux = DateTime.now();
                              showAlertDialog(context);

                              // if (fechaaux.difference(fechareporte).inDays >=
                              //     0) {
                              //   print(fechaaux.difference(fechareporte).inDays);
                              // } else {
                              //   showAlertDialogerrorfecha(context);
                              //   print(fechaaux.difference(fechareporte).inDays);
                              // }
                            }

                            //login();
                          },
                        ),
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
    );
  }
}
