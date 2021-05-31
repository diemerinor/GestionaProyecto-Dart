import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import 'dart:async';
import 'dart:convert';

import 'misproyectos.dart';

String fechainicial;
String fechatermino;
String fechafinal3, fechafinal4;

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
  TextEditingController controllermonto = new TextEditingController();
  final dateController = TextEditingController();
  final dateController2 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    dateController.dispose();
    dateController2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getSecciones();
    getCategorias();
  }

  String fechafinal;
  DateTime fechahoyy = DateTime.now();

  Future<List> insertproyecto() async {
    final response = await http.post(Uri.parse(url), body: {
      "idusuario": identificadorusuario,
      "nombreproyecto": controllernombre.text,
      "descripcionproyecto": controllerdescripcion.text,
      "idcomuna": seccionseleccionada,
      "idcategoria": categoriaseleccionada,
      "cajatotal": controllermonto.text,
      "fechahoy": '$fechahoyy',
      "fechainicial": fechafinal3,
      "fechatermino": fechafinal4,
    });
  }

  List names = List();
  List categorias = List();

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

  Future<List> getCategorias() async {
    String url4 =
        'http://gestionaproyecto.com/phpproyectotitulo/getCategorias.php';
    final response = await http.get(
      Uri.parse(url4),
    );
    datauser2 = json.decode(response.body);
    setState(() {
      categorias = datauser2;
    });

    return datauser2;
  }

  String textofecha = "Seleccione...";
  String textofecha2 = "Seleccione...";
  DateTime fechareporte;
  DateTime fechareporte2;
  String fechass;

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
                builder: (context) => MisProyectos(
                      idusuario: identificadorusuario,
                    )));
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
        Navigator.pop(context);
        insertproyecto();
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
      content: Text("La fecha inicial no puede ser mayor que la de término"),
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
  String categoriaseleccionada;

  List idssecciones = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorappbar,
        title: Text("Crea tu proyecto"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Center(
              child: Form(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nombre proyecto (*)",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      TextFormField(
                        controller: controllernombre,
                        decoration:
                            InputDecoration(hintText: 'Ingrese el nombre'),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 20)),
                      Text(
                        "Descripción",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      TextFormField(
                        controller: controllerdescripcion,
                        maxLines: null,
                        decoration:
                            InputDecoration(hintText: 'Describa su proyecto'),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 20)),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Fecha inicio ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: textofecha,
                                      icon: Icon(
                                        Icons.date_range,
                                        color: Colors.black,
                                      ),
                                    ),
                                    enabled: true,
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

                                        setState(() {
                                          final DateFormat formatter3 =
                                              DateFormat('yyyy-MM-dd');
                                          fechafinal3 =
                                              formatter3.format(fechareporte);
                                          final DateFormat formatter2 =
                                              DateFormat('dd-MM-yyyy');
                                          String fechafinal2 =
                                              formatter2.format(fechareporte);

                                          textofecha = fechafinal2.toString();
                                        });

                                        fechainicial = fechafinal3.toString();
                                        print(
                                            "la fecha seleccionada es $fechafinal");
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(left: 20)),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Fecha término",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: textofecha2,
                                      icon: Icon(
                                        Icons.date_range,
                                        color: Colors.black,
                                      ),
                                    ),
                                    enabled: true,
                                    readOnly: true,
                                    controller: dateController2,
                                    onTap: () async {
                                      var date2 = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100));
                                      if (date2 != null) {
                                        fechareporte2 = date2;

                                        final DateFormat formatter =
                                            DateFormat('dd-MM-yyyy');
                                        fechafinal =
                                            formatter.format(fechareporte2);

                                        textofecha2 = fechafinal.toString();

                                        setState(() {
                                          final DateFormat formatter3 =
                                              DateFormat('yyyy-MM-dd');
                                          fechafinal4 =
                                              formatter3.format(fechareporte2);
                                          final DateFormat formatter2 =
                                              DateFormat('dd-MM-yyyy');
                                          String fechafinal2 =
                                              formatter2.format(fechareporte);

                                          textofecha2 = fechafinal2.toString();
                                        });

                                        fechatermino = fechafinal4.toString();
                                        print(
                                            "la fecha seleccionada es $fechafinal");
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 20)),
                      Text(
                        "Capital inicial: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      TextFormField(
                        controller: controllermonto,
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
                      Text(
                        "Al no rellenar este campo, se completará con 0",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 20)),
                      Text(
                        "Comuna",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      DropdownButtonFormField<String>(
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
                      Text(
                        "Categoria",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      DropdownButtonFormField<String>(
                        value: categoriaseleccionada,
                        hint: Text("Seleccione categoria"),
                        items: categorias.map((list) {
                          return new DropdownMenuItem<String>(
                            child: new Text(list['nombrecategoria']),
                            value: list['idcategoria'].toString(),
                          );
                        }).toList(),
                        onChanged: (value3) {
                          setState(() {
                            categoriaseleccionada = value3;
                            print("se selecciono el valor $value3");
                          });
                        },
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 20)),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: new RaisedButton(
                            child: new Text(
                              "Crear proyecto",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: colorappbar,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0)),
                            onPressed: () {
                              if (controllerdescripcion.text == null ||
                                  controllerdescripcion.text == '' ||
                                  controllernombre.text == null ||
                                  controllernombre.text == '' ||
                                  seccionseleccionada == null ||
                                  categoriaseleccionada == null) {
                                showAlertDialogerror(context);
                              } else {
                                if (fechareporte
                                        .difference(fechareporte2)
                                        .inMinutes <=
                                    0) {
                                  showAlertDialog(context);
                                } else {
                                  showAlertDialogerrorfecha(context);
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
    );
  }
}

class Provincias {
  int idprovincia;
  String nombreprovincia;

  Provincias(int idprovincia, String nombreprovincia) {
    this.idprovincia = idprovincia;
    this.nombreprovincia = nombreprovincia;
  }
}
