import 'package:gestionaproyecto/main.dart';
import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'dart:async';

import 'app.dart';
import 'misproyectos.dart';

String nombrep;

class EditarProyecto extends StatefulWidget {
  final String idproyecto;

  const EditarProyecto({Key key, this.idproyecto}) : super(key: key);
  @override
  _EditarProyectoState createState() => _EditarProyectoState();
}

class _EditarProyectoState extends State<EditarProyecto> {
  TextEditingController controllernombre = new TextEditingController();
  TextEditingController controllerdescripcion = new TextEditingController();
  String url2 =
      'http://gestionaproyecto.com/phpproyectotitulo/getInfoproyecto.php';
  String seccionseleccionada;
  String categoriaseleccionada;
  List names = List();
  List categorias = List();
  var datauser2;
  String url6 =
      'http://gestionaproyecto.com/phpproyectotitulo/EditarProyecto.php';
  Future<List> editarproyecto() async {
    final response = await http.post(Uri.parse(url6), body: {
      "idproyecto": widget.idproyecto,
      "nombreproyecto": controllernombre.text,
      "descripcionproyecto": controllerdescripcion.text,
      "idcomuna": seccionseleccionada,
      "idcategoria": categoriaseleccionada,
    });
  }

  void initState() {
    super.initState();
    getCategorias();
    getSecciones();
    getinfoproyecto();
  }

  Future<List> getinfoproyecto() async {
    final response = await http.post(Uri.parse(url2), body: {
      "idproyecto": widget.idproyecto,
      "idusuario": identificadorusuario,
    });
    var datauser = json.decode(response.body);

    nombrep = datauser[0]['nombreproyecto'];
    String descrip = datauser[0]['descripcionproyecto'];
    controllernombre.text = nombrep;
    controllerdescripcion.text = descrip;
    seccionseleccionada = datauser[0]['idcomuna'];
    categoriaseleccionada = datauser[0]['idcategoria'];

    return datauser;
  }

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
    print(datauser2);
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
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continuar"),
      onPressed: () {
        Navigator.pop(context);
        editarproyecto();
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              child: Center(
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          width: MediaQuery.of(context).size.width * 0.7,
                          padding: EdgeInsets.only(top: 23),
                          child: ListView(
                            children: [
                              Text(
                                "Nombre proyecto",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
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
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              TextFormField(
                                controller: controllerdescripcion,
                                maxLines: null,
                                decoration: InputDecoration(
                                    hintText: 'Describa su proyecto'),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 20)),
                              Text(
                                "Comuna",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              DropdownButton<String>(
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
                              DropdownButton<String>(
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
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
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
      );
    }
  }
}
