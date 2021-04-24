import 'package:gestionaproyecto/src/gestionavance.dart';
import 'package:gestionaproyecto/src/gestionrrhh.dart';
import 'package:gestionaproyecto/src/listartrabajadores.dart';
import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestionaproyecto/src/gestionarproyecto.dart';

import 'gestionfinanciera.dart';

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
    super.initState();
    loginStatus();
  }

  void deletetrabajador() {
    String url =
        'http://gestionaproyecto.com/phpproyectotitulo/getProyecto.php';
  }

  Future<List> loginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginApp()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("el usuario tiene como rol: " +
        widget.idusuario +
        " y el rol del proyecto es " +
        widget.idproyecto);
    return Scaffold(
      appBar: AppBar(
        title: new Text("Gestiona tu proyecto"),
        backgroundColor: colorappbar,
      ),
      body: new ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(children: <Widget>[
              new Card(
                  color: colorappbar,
                  child: new Center(
                      child: new Column(
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.all(5),
                      ),
                      new Text(
                        widget.list[widget.index]['nombreproyecto'],
                        style:
                            new TextStyle(fontSize: 25.0, color: Colors.white),
                      ),
                      new Text(
                        widget.list[widget.index]['descripcionproyecto'],
                        style:
                            new TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                      Divider(),
                    ],
                  ))),
              Container(
                  height: MediaQuery.of(context).size.height * 0.17,
                  margin: EdgeInsets.all(6.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                            onTap: () => Navigator.of(context).push(
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          new GestionAvance(
                                            idproyecto: widget.idproyecto,
                                          )),
                                ),
                            child: Container(
                                width: 180,
                                child: Card(
                                    child: Column(children: <Widget>[
                                  Icon(Icons.addchart_rounded, size: 80),
                                  Text(
                                    'Gestión\nde Avance',
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ])))),
                        GestureDetector(
                            onTap: () => Navigator.of(context).push(
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          new GestionRRHH(
                                            idproyecto: widget.idproyecto,
                                            idusuario: widget.idusuario,
                                          )),
                                ),
                            child: Container(
                                width: 180,
                                child: Card(
                                    child: Column(children: <Widget>[
                                  Icon(Icons.supervised_user_circle_rounded,
                                      size: 80),
                                  Text(
                                    'Gestión\nde RRHH',
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ]))))
                      ])),
              Container(
                  height: MediaQuery.of(context).size.height * 0.17,
                  margin: EdgeInsets.all(6.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                            child: Container(
                                width: 180,
                                child: Card(
                                    child: Column(children: <Widget>[
                                  Icon(Icons.extension_rounded, size: 80),
                                  Text(
                                    'Gestión\nde Materiales',
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ])))),
                        GestureDetector(
                            onTap: () => Navigator.of(context).push(
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          new GestionFinanciera(
                                            idproyecto: widget.idproyecto,
                                          )),
                                ),
                            child: Container(
                                width: 180,
                                child: Card(
                                    child: Column(children: <Widget>[
                                  Icon(Icons.monetization_on_rounded, size: 80),
                                  Text(
                                    'Gestión \n financiera',
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ]))))
                      ])),
              Container(
                  height: MediaQuery.of(context).size.height * 0.17,
                  margin: EdgeInsets.all(6.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                            child: Container(
                                width: 180,
                                child: Card(
                                    child: Column(children: <Widget>[
                                  Icon(Icons.file_copy_rounded, size: 80),
                                  Text(
                                    'Archivos\nproyecto',
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ])))),
                        GestureDetector(
                            child: Container(
                                width: 180,
                                child: Card(
                                    child: Column(children: <Widget>[
                                  Icon(Icons.alarm_rounded, size: 80),
                                  Text(
                                    'Eventos\npróximos',
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ]))))
                      ])),
              Container(
                  height: MediaQuery.of(context).size.height * 0.17,
                  margin: EdgeInsets.all(6.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                            onTap: () => Navigator.of(context).push(
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          new ListarTrabajadores(
                                            idproyecto: widget.idproyecto,
                                            idusuario: widget.idusuario,
                                          )),
                                ),
                            child: Container(
                                width: 180,
                                child: Card(
                                    child: Column(children: <Widget>[
                                  Icon(Icons.people_alt_rounded, size: 80),
                                  Text(
                                    'Participantes\nproyecto',
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ])))),
                        GestureDetector(
                            child: Container(
                                width: 180,
                                child: Card(
                                    child: Column(children: <Widget>[
                                  Icon(Icons.info, size: 80),
                                  Text(
                                    'Información\nproyecto',
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ]))))
                      ])),
              RaisedButton(
                child: new Text(
                  "Abandonar proyecto",
                  style: TextStyle(fontSize: 20),
                ),
                color: Colors.red,
                textColor: Colors.white,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () {},
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
