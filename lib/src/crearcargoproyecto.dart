import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/gestionmateriales.dart';

import 'package:flutter/services.dart';
import 'package:gestionaproyecto/src/gestionrrhh.dart';

import 'package:http/http.dart' as http;

import 'dart:async';

class CrearCargo extends StatefulWidget {
  final String idproyecto;

  const CrearCargo({Key key, this.idproyecto}) : super(key: key);
  @override
  _CrearCargoState createState() => _CrearCargoState();
}

class _CrearCargoState extends State<CrearCargo> {
  String url = 'http://gestionaproyecto.com/phpproyectotitulo/InsertCargo.php';
  var datauser2;
  bool gestionavance = false;
  bool gestionrrhh = false;
  bool gestionmateriales = false;
  bool gestionfinanciera = false;
  int gesav = 0;
  int gesrrhh = 0;
  int gesmat = 0;
  int gesfin = 0;

  TextEditingController controllernombre = new TextEditingController();
  TextEditingController controllerdescripcion = new TextEditingController();

  TextEditingController controllerstock = new TextEditingController();
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
  }

  String fechafinal;

  Future<List> insertcargo() async {
    final response = await http.post(Uri.parse(url), body: {
      "idproyecto": widget.idproyecto,
      "nombrecargo": controllernombre.text,
      "descripcion": controllerdescripcion.text,
      "gestionavance": '$gestionavance',
      "gestionrrhh": '$gestionrrhh',
      "gestionmateriales": '$gestionmateriales',
      "gestionfinanciera": '$gestionfinanciera',
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
                builder: (context) => GestionRRHH(
                      idproyecto: widget.idproyecto,
                    )));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Se ha registrado correctamente"),
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
        insertcargo();
        Navigator.of(context, rootNavigator: true).pop('dialog');

        showAlertDialog2(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("¿Está seguro de crear el cargo?"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorappbar,
        title: Text("Crear cargo"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(bottom: 20)),
                    Text(
                      "Nombre cargo (*)",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    TextFormField(
                      controller: controllernombre,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.work,
                            color: Colors.black,
                          ),
                          hintText: 'Título de cargo'),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20)),
                    Text(
                      "Descripción",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    TextFormField(
                      controller: controllerdescripcion,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Describa las funciones del cargo',
                        icon: Icon(
                          Icons.description,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20)),
                    Text(
                      "Permisos:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Row(
                      children: [
                        Text(
                          "Gestión de avance:",
                          style: TextStyle(fontSize: 20),
                        ),
                        Switch(
                          value: gestionavance,
                          onChanged: (value) {
                            setState(() {
                              gestionavance = value;
                              if (gestionavance == false) {
                                gesav = 0;
                              } else {
                                gesav = 1;
                              }
                              print(gestionavance);
                            });
                          },
                          activeTrackColor: colorappbar,
                          activeColor: colorappbar2,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Gestión financiera:",
                          style: TextStyle(fontSize: 20),
                        ),
                        Switch(
                          value: gestionfinanciera,
                          onChanged: (value) {
                            setState(() {
                              gestionfinanciera = value;
                              if (gestionfinanciera == false) {
                                gesfin = 0;
                              } else {
                                gesfin = 1;
                              }
                              print(gestionfinanciera);
                            });
                          },
                          activeTrackColor: colorappbar,
                          activeColor: colorappbar2,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Gestión de RRHH:",
                          style: TextStyle(fontSize: 20),
                        ),
                        Switch(
                          value: gestionrrhh,
                          onChanged: (value) {
                            setState(() {
                              gestionrrhh = value;
                              if (gestionrrhh == false) {
                                gesrrhh = 0;
                              } else {
                                gesrrhh = 1;
                              }
                              print(gestionrrhh);
                            });
                          },
                          activeTrackColor: colorappbar,
                          activeColor: colorappbar2,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Gestión de materiales:",
                          style: TextStyle(fontSize: 20),
                        ),
                        Switch(
                          value: gestionmateriales,
                          onChanged: (value) {
                            setState(() {
                              gestionmateriales = value;
                              if (gestionmateriales == false) {
                                gesmat = 0;
                              } else {
                                gesmat = 1;
                              }
                              print(gestionmateriales);
                            });
                          },
                          activeTrackColor: colorappbar,
                          activeColor: colorappbar2,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: RaisedButton(
                          child: new Text(
                            "Crear cargo",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: colorappbar,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                          onPressed: () {
                            showAlertDialog(context);

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
    );
  }
}
