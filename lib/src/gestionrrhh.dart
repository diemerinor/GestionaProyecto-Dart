import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/gestionarproyecto.dart';
import 'package:gestionaproyecto/src/listartrabajadores.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

int cantidadtrabajadores;

class GestionRRHH extends StatefulWidget {
  final String idproyecto;
  final String idusuario;
  GestionRRHH({this.idproyecto, this.idusuario});
  @override
  _GestionRRHHState createState() => _GestionRRHHState();
}

class _GestionRRHHState extends State<GestionRRHH> {
  @override
  void initState() {
    super.initState();
    cantidadtrabajadores = 0;
  }

  String url2 =
      'http://gestionaproyecto.com/phpproyectotitulo/getParticipantes.php';
  int indiceproyecto;
  Future<List> getTrabajadores() async {
    final response =
        await http.post(Uri.parse(url2), body: {"idproyecto": "6"});
    var datauser = json.decode(response.body);
    int auxseccion = 0;
    int largodatauser = datauser.length;
    print("el largo es $largodatauser");
    for (auxseccion = 0; auxseccion < largodatauser; auxseccion++) {
      cantidadtrabajadores++;
    }
    cantidadtrabajadores--;
    print("la cantidad de trabajadores final es $cantidadtrabajadores");
    return datauser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Gestión RRHH"),
          backgroundColor: colorappbar,
        ),
        body: new FutureBuilder<List>(
            future: getTrabajadores(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? new detallesrrhh(
                      list: snapshot.data,
                      idusuario: widget.idusuario,
                      idproyecto: widget.idproyecto,
                    )
                  : new Center(
                      child: new CircularProgressIndicator(),
                    );
            }));
  }
}

class detallesrrhh extends StatefulWidget {
  final List list;
  final String idusuario;
  final String idproyecto;

  const detallesrrhh({Key key, this.list, this.idusuario, this.idproyecto})
      : super(key: key);
  @override
  _detallesrrhhState createState() => _detallesrrhhState();
}

class _detallesrrhhState extends State<detallesrrhh> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          Column(children: <Widget>[
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.all(15),
                elevation: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Actualmente existen $cantidadtrabajadores trabajadores en el proyecto además de ti",
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text("Listar trabajadores"),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new ListarTrabajadores(
                                  idproyecto: widget.idproyecto,
                                  idusuario: widget.idusuario,
                                )));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text("Agregar trabajador"),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
