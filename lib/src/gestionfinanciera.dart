import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/agregarreporte.dart';
import 'package:gestionaproyecto/src/detallemovimientos.dart';
import 'package:gestionaproyecto/src/gestionarproyecto.dart';
import 'package:gestionaproyecto/src/listartrabajadores.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:gestionaproyecto/src/registrargasto.dart';
import 'package:gestionaproyecto/src/registraringreso.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'dart:async';
import 'dart:convert';

import 'detalleproyecto.dart';

String caja;
int cajafinal;
String cajafinal2;

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
    if (datauser != null) {
      caja = datauser[0]['cajatotal'];
      cajafinal = int.parse(caja);
      cajafinal2 = (NumberFormat.simpleCurrency(name: 'CLP', decimalDigits: 0)
          .format(cajafinal));

      print("la cosita es " + cajafinal2);
    }
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
      backgroundColor: colorfondo,
      body: Column(
        children: [
          Expanded(
            child: new FutureBuilder<List>(
                future: getFinanciera(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if (snapshot.hasData) {
                    return new listarinfofinanciera(
                      listainfo: snapshot.data,
                      idproyecto: widget.idproyecto,
                    );
                  } else {
                    return new Center(
                      child: new CircularProgressIndicator(),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}

class listarinfofinanciera extends StatefulWidget {
  final List listainfo;
  final String idproyecto;

  const listarinfofinanciera({Key key, this.listainfo, this.idproyecto})
      : super(key: key);
  @override
  _listarinfofinancieraState createState() => _listarinfofinancieraState();
}

class _listarinfofinancieraState extends State<listarinfofinanciera> {
  @override
  Widget build(BuildContext context) {
    return widget.listainfo == null
        ? Center(child: CircularProgressIndicator())
        : Container(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Caja\nactual:",
                                style: TextStyle(fontSize: 25),
                                textAlign: TextAlign.center,
                              ),
                              Padding(padding: EdgeInsets.only(left: 20)),
                              Text(
                                cajafinal2,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        color: colorappbar,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            '- Movimientos financieros -',
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                new DetalleMovimientos(
                                                    idproyecto:
                                                        widget.idproyecto)),
                                      ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Card(
                                              elevation: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child:
                                                    Column(children: <Widget>[
                                                  Icon(Icons.list, size: 60),
                                                  Text(
                                                    'Listar\nmovimientos',
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ]),
                                              ))),
                                    ],
                                  )),
                              GestureDetector(
                                  onTap: () => {
                                        Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new RegistrarIngreso(
                                                    idproyecto:
                                                        widget.idproyecto,
                                                    caja: cajafinal,
                                                  )),
                                        )
                                      },
                                  child: Column(
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Card(
                                              elevation: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child:
                                                    Column(children: <Widget>[
                                                  Icon(Icons.north_east,
                                                      size: 60),
                                                  Text(
                                                    'Registrar\ningreso',
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ]),
                                              ))),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 10)),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Card(
                                          elevation: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(children: <Widget>[
                                              Icon(Icons.bar_chart, size: 60),
                                              Text(
                                                'Balance\ngráfico',
                                                style: TextStyle(fontSize: 20),
                                                textAlign: TextAlign.center,
                                              ),
                                            ]),
                                          ))),
                                ],
                              )),
                              GestureDetector(
                                  onTap: () => {
                                        Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new RegistrarGasto(
                                                    idproyecto:
                                                        widget.idproyecto,
                                                    caja: cajafinal,
                                                  )),
                                        )
                                      },
                                  child: Column(
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Card(
                                              elevation: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child:
                                                    Column(children: <Widget>[
                                                  Icon(Icons.south_east,
                                                      size: 60),
                                                  Text(
                                                    'Registrar\ngasto',
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ]),
                                              ))),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
