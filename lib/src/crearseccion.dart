import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/gestionmateriales.dart';

import 'package:flutter/services.dart';
import 'package:gestionaproyecto/src/gestionseccion.dart';

import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

class CrearSeccion extends StatefulWidget {
  final String idproyecto;

  const CrearSeccion({Key key, this.idproyecto}) : super(key: key);
  @override
  _CrearSeccionState createState() => _CrearSeccionState();
}

class _CrearSeccionState extends State<CrearSeccion> {
  var datauser2;

  TextEditingController controllernombre = new TextEditingController();
  TextEditingController controllerdescripcion = new TextEditingController();
  TextEditingController controllercantidad = new TextEditingController();
  TextEditingController controllervalor = new TextEditingController();
  final dateController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    dateController.dispose();
    super.dispose();
  }

  List unidades = List();

  String fechafinal;
  String unidadseleccionada;
  Future<List> getUnidades() async {
    String url4 = 'http://gestionaproyecto.com/phpproyectotitulo/getUnidad.php';
    final response = await http.get(
      Uri.parse(url4),
    );
    datauser2 = json.decode(response.body);
    print(datauser2);
    setState(() {
      unidades = datauser2;
    });

    return datauser2;
  }

  @override
  void initState() {
    super.initState();
    getUnidades();
  }

  Future<List> insertseccion() async {
    String url5 =
        'http://gestionaproyecto.com/phpproyectotitulo/InsertSeccion.php';
    final response = await http.post(Uri.parse(url5), body: {
      "idproyecto": widget.idproyecto,
      "nombreseccion": controllernombre.text,
      "descripcionseccion": controllerdescripcion.text,
      "metrosseccion": controllercantidad.text,
      "idunidaddemedida": unidadseleccionada,
      "valor": controllervalor.text
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
                builder: (context) => ListarSecciones(
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
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continuar"),
      onPressed: () {
        insertseccion();
        Navigator.pop(context);
        showAlertDialog2(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("¿Está seguro de crear la sección?"),
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
        title: Text("Crear sección proyecto"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nombre sección(*)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextFormField(
                  controller: controllernombre,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.storage,
                        color: Colors.black,
                      ),
                      hintText: 'Ingrese el nombre de la sección'),
                ),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                Text(
                  "Descripción sección",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextFormField(
                  controller: controllerdescripcion,
                  maxLines: null,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.description,
                        color: Colors.black,
                      ),
                      hintText: 'Describa la sección'),
                ),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.34,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Cantidad sección",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            TextFormField(
                              controller: controllercantidad,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.corporate_fare,
                                  color: Colors.black,
                                ),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.singleLineFormatter
                              ],
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 16)),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Unidad",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            DropdownButton<String>(
                              value: unidadseleccionada,
                              hint: Text("Seleccione unidad"),
                              items: unidades.map((list) {
                                return new DropdownMenuItem<String>(
                                  child: new Text(list['nombreunidad']),
                                  value: list['idunidaddemedida'].toString(),
                                );
                              }).toList(),
                              onChanged: (value2) {
                                setState(() {
                                  unidadseleccionada = value2;
                                  print("se selecciono el valor $value2");
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 15)),
                Text(
                  "Cantidad y unidad que se medirá la sección\nPor ejemplo:500 metros",
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                ),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                Text(
                  "Valor sección:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                TextFormField(
                  controller: controllervalor,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.monetization_on,
                      color: Colors.black,
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.singleLineFormatter
                  ],
                  keyboardType: TextInputType.number,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: RaisedButton(
                      child: new Text(
                        "Crear sección",
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
    );
  }
}
