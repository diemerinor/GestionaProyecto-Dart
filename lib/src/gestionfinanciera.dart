import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/agregarreporte.dart';
import 'package:gestionaproyecto/src/gestionarproyecto.dart';
import 'package:gestionaproyecto/src/listartrabajadores.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'detalleproyecto.dart';

String caja;
int cajafinal;
//String textopeso = '$';

class GestionFinanciera extends StatefulWidget {
  final String idproyecto;

  GestionFinanciera({Key key, this.idproyecto}) : super(key: key);
  @override
  _GestionFinancieraState createState() => _GestionFinancieraState();
}

class _GestionFinancieraState extends State<GestionFinanciera> {
  String url2 =
      'http://gestionaproyecto.com/phpproyectotitulo/getMovimientos.php';

  Future<List> getFinanciera() async {
    final response = await http.post(Uri.parse(url2), body: {
      "idproyecto": widget.idproyecto,
    });
    var datauser = json.decode(response.body);
    caja = datauser[0]['caja'];
    cajafinal = int.parse(caja);
    //print("hay $cajafinal");
    return datauser;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFinanciera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gestion Financiera",
        ),
        backgroundColor: colorappbar,
      ),
      body: Column(
        children: [
          Expanded(
            child: new FutureBuilder<List>(
                future: getFinanciera(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? new listarinfofinanciera(
                          listainfo: snapshot.data,
                        )
                      : new Center(
                          child: new CircularProgressIndicator(),
                        );
                }),
          ),
        ],
      ),
    );
  }
}

class listarinfofinanciera extends StatefulWidget {
  final List listainfo;

  const listarinfofinanciera({Key key, this.listainfo}) : super(key: key);
  @override
  _listarinfofinancieraState createState() => _listarinfofinancieraState();
}

class _listarinfofinancieraState extends State<listarinfofinanciera> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.16,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      child: ListView(
                        children: [
                          Text(
                            "Actualmente en caja hay",
                            style: TextStyle(fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '\$$caja',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                Text(
                  '- Movimientos financieros -',
                  style: TextStyle(fontSize: 22),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: new Text(
                      "Listar movimientos",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    color: Colors.black,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: new Text(
                      "Registrar ingreso",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    color: Colors.black,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: new Text(
                      "Registrar gasto",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    color: Colors.black,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
