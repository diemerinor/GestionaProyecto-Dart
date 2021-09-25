import 'package:dio/dio.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/crearmaterial.dart';
import 'package:gestionaproyecto/src/detalle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'editarmaterial.dart';

var datos = [];
int cantmateriales;
String mensajemat;

class GestionarMateriales extends StatefulWidget {
  final String idproyecto;

  const GestionarMateriales({Key key, this.idproyecto}) : super(key: key);
  @override
  _GestionarMaterialesState createState() => _GestionarMaterialesState();
}

class _GestionarMaterialesState extends State<GestionarMateriales> {
  final dio = new Dio();
  String _searchText = "";
  List names = new List(); // names we get from API
  List filteredNames = new List();
  void initState() {
    mensajemat = "Cargando materiales...";
    super.initState();
  }

  String url4 =
      'http://gestionaproyecto.com/phpproyectotitulo/getMateriales.php';
  Future<List> getMateriales() async {
    final response = await http
        .post(Uri.parse(url4), body: {'idproyecto': widget.idproyecto});
    var datauser = jsonDecode(response.body);
    if (datauser != null) {
      cantmateriales = datauser.length;

      int aux = 1;

      datos = [datauser[0]['nombrerecurso']];

      while (aux < cantmateriales) {
        datos.add(datauser[aux]['nombrerecurso']);
        // print("la cantidad es ${datauser[aux]["nombrerecurso"]}");
        aux++;
      }
    } else if (datauser == null) {
      mensajemat = "No existen materiales en este proyecto";
      cantmateriales = 0;
    }

    // setState(() {
    //   names = datos;
    //   filteredNames = names;
    // });
    print(datos);

    return datauser;
  }

  final Controller1 = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorfondo,
      appBar: AppBar(
        title: new Text("Materiales"),
        backgroundColor: colorappbar,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CrearMaterial(
                            idproyecto: widget.idproyecto,
                          ))),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: new FutureBuilder<List>(
                  future: getMateriales(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    if (snapshot.hasData) {
                      return Container(
                        child: new listarmateriales(
                            list: snapshot.data, idproyecto: widget.idproyecto),
                      );
                    } else {
                      return Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                mensajemat ?? '',
                                style: TextStyle(fontSize: 25),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }
}

class listarmateriales extends StatefulWidget {
  final List list;
  final String idproyecto;

  const listarmateriales({Key key, this.list, this.idproyecto})
      : super(key: key);
  @override
  _listarmaterialesState createState() => _listarmaterialesState();
}

class _listarmaterialesState extends State<listarmateriales> {
  final Controller1 = new TextEditingController();

  String url =
      'http://gestionaproyecto.com/phpproyectotitulo/DeleteMaterial.php';
  String materialaeliminar;
  Future<List> deletematerial() async {
    print(materialaeliminar);
    final response = await http
        .post(Uri.parse(url), body: {"idmaterial": materialaeliminar});
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
        Navigator.pop(context);
        Navigator.pop(context);
        deletematerial();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GestionarMateriales(
                      idproyecto: widget.idproyecto,
                    )));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("¿Está seguro de eliminar el material? "),
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
    if (widget.list == null) {
      if (cantmateriales == 0)
        Text("hola");
      else
        return Center(child: CircularProgressIndicator());
    } else {
      return Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: colorappbar,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10, top: 5, bottom: 5),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: new Text(
                        "Nombre material",
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10, top: 5, bottom: 5),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: new Text(
                        "Stock",
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10, top: 5, bottom: 5),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: new Text(
                        "Acciones",
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: new ListView.builder(
                itemCount: widget.list == null ? 0 : widget.list.length,
                itemBuilder: (context, i) {
                  return new Container(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10, top: 5, bottom: 5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: new Text(
                                    widget.list[i]['nombrerecurso'],
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10, top: 5, bottom: 5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: new Text(
                                    widget.list[i]['stock'],
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10, top: 5, bottom: 5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Color.fromRGBO(17, 97, 73, 4),
                                          size: 40,
                                        ),
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditarMaterial(
                                                      idmaterial: widget.list[i]
                                                          ["idrecursomat"],
                                                      idproyecto:
                                                          widget.idproyecto,
                                                    ))),
                                      ),
                                      IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 40,
                                          ),
                                          onPressed: () => {
                                                setState(() {
                                                  materialaeliminar = widget
                                                      .list[i]['idrecursomat'];
                                                }),
                                                showAlertDialog(context)
                                              }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]));
                }),
          ),
        ],
      );
    }
  }
}
