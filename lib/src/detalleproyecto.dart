import 'package:gestionaproyecto/src/editarproyecto.dart';
import 'package:gestionaproyecto/src/gestionavance.dart';
import 'package:gestionaproyecto/src/gestionrrhh.dart';
import 'package:gestionaproyecto/src/gestionseccion.dart';
import 'package:gestionaproyecto/src/importararchivos.dart';
import 'package:gestionaproyecto/src/listartrabajadores.dart';
import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'gestionfinanciera.dart';
import 'gestionmateriales.dart';
import 'listareventos.dart';
import 'misproyectos.dart';

String fechainicials = null;
String fechafinals = null;
String auxinicial, auxfinal;

class DetalleProyecto extends StatefulWidget {
  List list;
  int index;
  String idusuario;
  final String idproyecto;

  DetalleProyecto({this.index, this.list, this.idusuario, this.idproyecto});

  @override
  _DetalleProyectoState createState() => _DetalleProyectoState();
}

class _DetalleProyectoState extends State<DetalleProyecto> {
  int indiceproyecto;
  int identusuario;
  SharedPreferences sharedPreferences;
  void initState() {
    getfechas();
    super.initState();
  }

  String url4 =
      'http://gestionaproyecto.com/phpproyectotitulo/getFechasProyecto.php';

  Future<List> getfechas() async {
    print("el id proyecto es" + widget.idproyecto);
    final response = await http.post(Uri.parse(url4), body: {
      "idproyecto": widget.idproyecto,
    });
    var datauser = json.decode(response.body);
    print(datauser);
    setState(() {
      fechainicials = datauser[0]['textofechainicial'];
      fechafinals = datauser[0]['textofechafinal'];
    });

    return datauser;
  }

  String url =
      'http://gestionaproyecto.com/phpproyectotitulo/DeleteProyecto.php';

  Future<List> deleteproyecto() async {
    final response = await http
        .post(Uri.parse(url), body: {"idproyecto": widget.idproyecto});
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
        Navigator.pop(context);
        Navigator.pop(context);
        deleteproyecto();
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
      content: Text("¿Está seguro de borrar el proyecto? "),
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
    print("el usuario tiene como rol: " +
        widget.idusuario +
        " y el rol del proyecto es " +
        widget.idproyecto);

    if (fechainicials == null || fechafinals == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          title: new Text("Gestiona tu proyecto"),
          backgroundColor: colorappbar,
          elevation: 0,
        ),
        backgroundColor: colorfondo,
        body: new ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Column(children: <Widget>[
                new Container(
                    width: MediaQuery.of(context).size.width,
                    color: colorappbar,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 10, left: 10, top: 5, bottom: 5),
                                child: new Text(
                                  widget.list[widget.index]['nombreproyecto'],
                                  style: new TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_city,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    new Text(
                                      widget.list[widget.index]['nombrecomuna'],
                                      style: new TextStyle(
                                          fontSize: 17.0, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.admin_panel_settings_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    Text(
                                      "Rol: " +
                                          widget.list[widget.index]
                                              ['NombreRol'],
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.date_range,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    Text(
                                      "Fecha inicio: " + fechainicials,
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 10, left: 10, bottom: 20),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.date_range,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    Text(
                                      "Fecha término: " + fechafinals,
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            if (widget.list[widget.index]['CodigoRol'] == "1")
                              Container(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () => {
                                        Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new EditarProyecto(
                                                    idproyecto:
                                                        widget.idproyecto,
                                                  )),
                                        ),
                                      },
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.12,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.12,
                                          child: Card(
                                            color: Colors.black87,
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                          )),
                                    ),
                                    GestureDetector(
                                      onTap: () => {
                                        showAlertDialog(context),
                                      },
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.12,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.12,
                                          child: Card(
                                            color: Colors.red,
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              )
                            else if (widget.list[widget.index]['CodigoRol'] ==
                                "2")
                              Column(
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.12,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.12,
                                      child: Card(
                                        color: Colors.red,
                                        child: Icon(
                                          Icons.exit_to_app,
                                          color: Colors.white,
                                        ),
                                      ))
                                ],
                              )
                          ],
                        )
                      ],
                    )),
                Padding(padding: EdgeInsets.only(top: 20)),
                Container(
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.all(6.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new GestionAvance(
                                                    idproyecto:
                                                        widget.idproyecto,
                                                  )),
                                        ),
                                    child: Column(
                                      children: [
                                        Container(
                                            width: 180,
                                            child: Card(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(children: <Widget>[
                                                Icon(Icons.addchart_rounded,
                                                    size: 40),
                                                Text(
                                                  'Gestión\nde Avance',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ]),
                                            ))),
                                      ],
                                    )),
                                GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new GestionRRHH(
                                                    idproyecto:
                                                        widget.idproyecto,
                                                    idusuario: widget.idusuario,
                                                  )),
                                        ),
                                    child: Column(
                                      children: [
                                        Container(
                                            width: 180,
                                            child: Card(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(children: <Widget>[
                                                Icon(
                                                    Icons
                                                        .supervised_user_circle_rounded,
                                                    size: 40),
                                                Text(
                                                  'Gestión\nde RRHH',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ]),
                                            ))),
                                      ],
                                    ))
                              ])),
                      Container(
                          margin: EdgeInsets.all(6.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new GestionarMateriales(
                                                    idproyecto:
                                                        widget.idproyecto,
                                                  )),
                                        ),
                                    child: Column(
                                      children: [
                                        Container(
                                            width: 180,
                                            child: Card(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(children: <Widget>[
                                                Icon(Icons.extension_rounded,
                                                    size: 40),
                                                Text(
                                                  'Gestión\nde Materiales',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ]),
                                            ))),
                                      ],
                                    )),
                                GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new GestionFinanciera(
                                                    idproyecto:
                                                        widget.idproyecto,
                                                  )),
                                        ),
                                    child: Column(
                                      children: [
                                        Container(
                                            width: 180,
                                            child: Card(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(children: <Widget>[
                                                Icon(
                                                    Icons
                                                        .monetization_on_rounded,
                                                    size: 40),
                                                Text(
                                                  'Gestión \n financiera',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ]),
                                            ))),
                                      ],
                                    ))
                              ])),
                      Container(
                          margin: EdgeInsets.all(6.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new ImportarArchivo(
                                                      idproyecto:
                                                          widget.idproyecto,
                                                      nombreproyecto: widget
                                                                  .list[
                                                              widget.index]
                                                          ['nombreproyecto'])),
                                        ),
                                    child: Column(
                                      children: [
                                        Container(
                                            width: 180,
                                            child: Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child:
                                                    Column(children: <Widget>[
                                                  Icon(Icons.file_copy_rounded,
                                                      size: 40),
                                                  Text(
                                                    'Archivos\nproyecto',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ]),
                                              ),
                                            )),
                                      ],
                                    )),
                                GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new ListarEventos(
                                                    idproyecto:
                                                        widget.idproyecto,
                                                  )),
                                        ),
                                    child: Column(
                                      children: [
                                        Container(
                                            width: 180,
                                            child: Card(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(children: <Widget>[
                                                Icon(Icons.alarm_rounded,
                                                    size: 40),
                                                Text(
                                                  'Eventos\npróximos',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ]),
                                            ))),
                                      ],
                                    ))
                              ])),
                      Container(
                          margin: EdgeInsets.all(6.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new ListarTrabajadores(
                                                    idproyecto:
                                                        widget.idproyecto,
                                                    idusuario: widget.idusuario,
                                                  )),
                                        ),
                                    child: Column(
                                      children: [
                                        Container(
                                            width: 180,
                                            child: Card(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(children: <Widget>[
                                                Icon(Icons.people_alt_rounded,
                                                    size: 40),
                                                Text(
                                                  'Participantes\nproyecto',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ]),
                                            ))),
                                      ],
                                    )),
                                GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new ListarSecciones(
                                                    idproyecto:
                                                        widget.idproyecto,
                                                  )),
                                        ),
                                    child: Column(
                                      children: [
                                        Container(
                                            width: 180,
                                            child: Card(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(children: <Widget>[
                                                Icon(Icons.list_outlined,
                                                    size: 40),
                                                Text(
                                                  'Secciones\nproyecto',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ]),
                                            ))),
                                      ],
                                    ))
                              ])),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      );
    }
  }
}
