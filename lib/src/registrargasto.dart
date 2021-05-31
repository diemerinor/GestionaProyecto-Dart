import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/gestionfinanciera.dart';

import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'dart:async';

class RegistrarGasto extends StatefulWidget {
  final String idproyecto;
  final int caja;

  const RegistrarGasto({Key key, this.idproyecto, this.caja}) : super(key: key);
  @override
  _RegistrarGastoState createState() => _RegistrarGastoState();
}

class _RegistrarGastoState extends State<RegistrarGasto> {
  String url =
      'http://gestionaproyecto.com/phpproyectotitulo/RegistrarGasto.php';
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
  String mensaje2 = '';

  Future<List> insertgasto() async {
    String aux = controllerdescripcion.text;
    int monto = int.parse(aux);
    int total = cajafinal - monto;
    String finaltotal = total.toString();
    DateTime fechahooy = DateTime.now();
    String auxfecha = fechahooy.toString();
    final response = await http.post(Uri.parse(url), body: {
      "idusuario": identificadorusuario,
      "titulo": controllernombre.text,
      "monto": controllerdescripcion.text,
      "total": finaltotal,
      "fechahoy": auxfecha,
      "fechareporte": variablephp,
      "idproyecto": widget.idproyecto
    });
  }

  showAlertDialog2(BuildContext context) {
    // set up the buttons

    Widget continueButton = FlatButton(
      child: Text("Continuar"),
      onPressed: () {
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
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continuar"),
      onPressed: () {
        insertgasto();
        Navigator.pop(context);
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
      backgroundColor: colorfondo,
      appBar: AppBar(
        backgroundColor: colorappbar,
        title: Text("Registra gasto"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Center(
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Motivo gasto (*)",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        TextFormField(
                          controller: controllernombre,
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.south_east,
                                color: Colors.black,
                              ),
                              hintText:
                                  'Ingrese el motivo del gasto de dinero'),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 20)),
                        Text(
                          "Monto (*)",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        TextFormField(
                          style: TextStyle(color: colortextoss),
                          controller: controllerdescripcion,
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.monetization_on,
                                color: Colors.black,
                              ),
                              hintText: 'Ingrese el monto'),
                          onChanged: (text) {
                            setState(() {
                              String aux = controllerdescripcion.text;
                              int aux2 = int.parse(aux);
                              int total = widget.caja - aux2;
                              print(total);
                              if (total < 0) {
                                colortextoss = Colors.red;
                                mensaje2 = "El saldo quedará negativo";
                              } else {
                                colortextoss = Colors.black;
                                mensaje2 = '';
                              }
                            });
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.singleLineFormatter
                          ],
                          keyboardType: TextInputType.number,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Saldo actual: \$${widget.caja}",
                              style: TextStyle(
                                  fontSize: 16, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              mensaje2,
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 20)),
                        Text(
                          "Fecha gasto (*)",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Row(
                          children: [
                            Icon(Icons.date_range, color: Colors.black),
                            Text(
                              "Fecha de hoy",
                              style: TextStyle(fontSize: 16),
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
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
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
                                    print(
                                        "la fecha seleccionada es $textofecha");
                                  }
                                },
                                decoration:
                                    InputDecoration(hintText: textofecha),
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 30)),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: new RaisedButton(
                              child: new Text(
                                "Registrar gasto",
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
    );
  }
}
