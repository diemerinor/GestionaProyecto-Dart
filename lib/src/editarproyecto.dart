import 'package:flutter/services.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/detalleproyecto.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:convert';
import 'dart:async';

import 'app.dart';
import 'misproyectos.dart';

String nombrep;

class EditarProyecto extends StatefulWidget {
  final List list;
  final String idproyecto;
  final int index;

  const EditarProyecto({Key key, this.idproyecto, this.index, this.list})
      : super(key: key);
  @override
  _EditarProyectoState createState() => _EditarProyectoState();
}

class _EditarProyectoState extends State<EditarProyecto> {
  TextEditingController controllernombre = new TextEditingController();
  TextEditingController controllerdescripcion = new TextEditingController();
  TextEditingController controllermonto = new TextEditingController();
  final dateController = TextEditingController();
  final dateController2 = TextEditingController();
  String url2 =
      'http://gestionaproyecto.com/phpproyectotitulo/getInfoproyecto.php';
  String seccionseleccionada;
  String categoriaseleccionada;
  String estadoproyecto;
  List names = List();
  List categorias = List();
  var datauser2;
  DateTime fechareporte;
  String textofecha = "Seleccione...";
  String textofecha2 = "Seleccione...";
  String fechainicial;
  String fechatermino;
  String fechafinal3, fechafinal4;
  DateTime fechareporte2;
  String fechass;
  String fechafinal;
  DateTime fechahoyy = DateTime.now();

  void initState() {
    super.initState();
    getCategorias();
    getSecciones();
    getinfoproyecto();
  }

  var datauser;

  Future<List> getinfoproyecto() async {
    final response = await http.post(Uri.parse(url2), body: {
      "idproyecto": widget.idproyecto,
      "idusuario": identificadorusuario,
    });
    datauser = json.decode(response.body);

    nombrep = datauser[0]['nombreproyecto'];
    String descrip = datauser[0]['descripcionproyecto'];
    controllernombre.text = nombrep;
    controllerdescripcion.text = descrip;
    controllermonto.text = datauser[0]['metrostotales'];
    dateController.text = datauser[0]['fechainicial'];
    dateController2.text = datauser[0]['fechatermino'];
    seccionseleccionada = datauser[0]['idcomuna'];
    categoriaseleccionada = datauser[0]['idcategoria'];
    setState(() {
      estadoproyecto = datauser[0]['estado_proyecto'];
    });
    return datauser;
  }

  String url6 =
      'http://gestionaproyecto.com/phpproyectotitulo/EditarProyecto.php';
  Future<List> editarproyecto() async {
    print("hola");
    print(estadoproyecto);
    final response = await http.post(Uri.parse(url6), body: {
      "idproyecto": widget.idproyecto,
      "nombreproyecto": controllernombre.text,
      "descripcionproyecto": controllerdescripcion.text,
      "metrostotales": controllermonto.text,
      "fechainicio": dateController.text,
      "fechatermino": dateController2.text,
      "estadoproyecto": estadoproyecto
    });
  }

  Future<List> getSecciones() async {
    String url3 =
        'http://gestionaproyecto.com/phpproyectotitulo/getComunas.php';
    final response = await http.get(
      Uri.parse(url3),
    );
    datauser2 = json.decode(response.body);
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
        editarproyecto();
        Navigator.of(context, rootNavigator: true).pop('dialog');
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MisProyectos(
                      list: widget.list,
                      index: widget.index,
                      idusuario: identificadorusuario,
                      editado: true,
                      idproyectoeditado: widget.idproyecto,
                    )));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("¿Está seguro de editar el proyecto? "),
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
    if (nombrep == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        backgroundColor: colorfondo,
        appBar: AppBar(
          title: new Text("Editar proyecto"),
          backgroundColor: colorappbar,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Form(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Column(
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
                                        hintText: 'Ingrese el nombre  '),
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
                                    maxLines: null,
                                    decoration: InputDecoration(
                                        hintText: 'Describa su proyecto'),
                                  ),
                                  Padding(padding: EdgeInsets.only(bottom: 20)),
                                  Text(
                                    "Metros totales",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
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
                                      FilteringTextInputFormatter
                                          .singleLineFormatter
                                    ],
                                    keyboardType: TextInputType.number,
                                  ),
                                  Padding(padding: EdgeInsets.only(bottom: 20)),
                                  Text(
                                    "Fecha inicio",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Container(
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
                                  Padding(padding: EdgeInsets.only(bottom: 20)),
                                  Text(
                                    "Fecha término",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Container(
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
                                            fechafinal4 = formatter3
                                                .format(fechareporte2);
                                            final DateFormat formatter2 =
                                                DateFormat('dd-MM-yyyy');
                                            String fechafinal2 =
                                                formatter2.format(fechareporte);

                                            textofecha2 =
                                                fechafinal2.toString();
                                          });

                                          fechatermino = fechafinal4.toString();
                                          print(
                                              "la fecha seleccionada es $fechafinal");
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(bottom: 20)),
                                  Text(
                                    "Estado proyecto",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: DropdownButton<String>(
                                      value: estadoproyecto,
                                      hint: Text(
                                        "Seleccione estado",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      items: [
                                        DropdownMenuItem(
                                          child: Text("Completado"),
                                          value: "Completado",
                                        ),
                                        DropdownMenuItem(
                                          child: Text("En progreso"),
                                          value: "En Progreso",
                                        ),
                                      ],
                                      onChanged: (value2) {
                                        setState(() {
                                          estadoproyecto = value2;
                                          print(
                                              "se selecciono el valor $value2");
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(bottom: 20)),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: new RaisedButton(
                                      child: new Text(
                                        "Editar proyecto",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: colorappbar,
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(20.0)),
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
              ],
            ),
          ),
        ),
      );
    }
  }
}
