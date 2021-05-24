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
import 'package:gestionaproyecto/src/registrargasto.dart';
import 'package:gestionaproyecto/src/registraringreso.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'dart:async';
import 'dart:convert';

import 'detalleproyecto.dart';

double porcentaje;
int largo = 0;
double metrosavance;
double metrostotales;
int cantidadmovimientos;
double porcentajeavance = 0;
String mensaje;

class DetalleMovimientos extends StatefulWidget {
  final String idproyecto;

  DetalleMovimientos({Key key, @required this.idproyecto}) : super(key: key);

  @override
  _DetalleMovimientosState createState() => _DetalleMovimientosState();
}

class _DetalleMovimientosState extends State<DetalleMovimientos> {
  @override
  void initState() {
    super.initState();
    mensaje = "Cargando movimientos financieros...";
  }

  var listaavance = [];
  int cantidad;
  List<double> listafinal;
  String url2 =
      'http://gestionaproyecto.com/phpproyectotitulo/ListarMovimientos.php';
  String caja;
  int cajafinal;
  String cajafinal2;
  Future<List> getFinanciera() async {
    final response = await http.post(Uri.parse(url2), body: {
      "idproyecto": widget.idproyecto,
    });
    var datauser = json.decode(response.body);
    int cantmov = datauser.length;
    print("el largo es  $cantmov");
    if (datauser != null && cantmov != 0) {
      print("si me meti aqui");
      caja = datauser[0]['cajatotal'];
      cajafinal = int.parse(caja);
      cajafinal2 = (NumberFormat.simpleCurrency(name: 'CLP', decimalDigits: 0)
          .format(cajafinal));
      print("en caja hay " + cajafinal2);
    } else {
      cantidadmovimientos = 0;
      mensaje = "No existen movimientos financieros";
    }
    //print("hay $cajafinal");
    return datauser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorappbar,
          title: Text("Movimientos financieros"),
        ),
        backgroundColor: colorfondo,
        body: new FutureBuilder<List>(
            future: getFinanciera(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (snapshot.hasData && cantidadmovimientos != 0) {
                print("holasss2");
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                          child: Container(
                            color: colorappbar,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "Caja actual: " + cajafinal2,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: new DatosAvance(
                        list: snapshot.data,
                        idproyecto: widget.idproyecto,
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.warning, color: Colors.amber, size: 60),
                      Text(
                        mensaje ?? '',
                        style: TextStyle(fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
            }));
  }
}

class DatosAvance extends StatefulWidget {
  final List list;
  final String idproyecto;

  DatosAvance({Key key, this.list, this.idproyecto}) : super(key: key);

  @override
  _DatosAvanceState createState() => _DatosAvanceState();
}

class _DatosAvanceState extends State<DatosAvance> {
  var datos2;

  @override
  Widget build(BuildContext context) {
    return widget.list == null
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              if (widget.list != null)
                Expanded(
                  child: FutureBuilder<List>(builder: (context, snapshot) {
                    return ListView.builder(
                        itemCount: widget.list == null ? 0 : widget.list.length,
                        itemBuilder: (context, i) {
                          if (widget.list[i]['idproyecto'] != null) {
                            print("aqui si entre");
                            return Column(
                              children: [
                                if (widget.list[i]['idtipomovimiento'] == '1')
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Card(
                                              color: verde,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.north_east,
                                                  size: 40,
                                                  color: Colors.white,
                                                ),
                                              )),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Text(
                                              "Se realizó un ingreso con titulo: " +
                                                  widget.list[i]['titulo'] +
                                                  " de " +
                                                  widget.list[i]['ingreso'] +
                                                  " quedando un total de " +
                                                  widget.list[i]['total'],
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider()
                                    ],
                                  )
                                else if (widget.list[i]['idtipomovimiento'] ==
                                    '2')
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Card(
                                              color: rojooscuro,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.south_east,
                                                  size: 40,
                                                  color: Colors.white,
                                                ),
                                              )),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Text(
                                              "Se realizó un gasto con titulo: " +
                                                  widget.list[i]['titulo'] +
                                                  " de " +
                                                  widget.list[i]['ingreso'] +
                                                  " quedando un total de " +
                                                  widget.list[i]['total'],
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider()
                                    ],
                                  )
                              ],
                            );
                          } else {
                            return Text("Hola");
                          }
                        });
                  }),
                ),
            ],
          );
  }
}
