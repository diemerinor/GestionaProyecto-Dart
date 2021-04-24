import 'package:flutter/material.dart';
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

double porcentaje;
int largo;
double metrosavance;
double metrostotales;
int cantidadsecciones;
double porcentajeavance;

class GestionAvance extends StatefulWidget {
  final String idproyecto;

  GestionAvance({Key key, @required this.idproyecto}) : super(key: key);

  @override
  _GestionAvanceState createState() => _GestionAvanceState();
}

class _GestionAvanceState extends State<GestionAvance> {
  var listaavance = [];
  List<double> listafinal;
  String url2 = 'http://gestionaproyecto.com/phpproyectotitulo/getAvance.php';
  Future<List> getAvance() async {
    final response = await http.post(Uri.parse(url2), body: {
      "idproyecto": widget.idproyecto,
    });
    var datauser = json.decode(response.body);

    int aux = 0;
    double nuevoaux = 0;
    metrosavance = 0;
    metrostotales = 0;
    for (int auxseccion = 0;
        datauser[auxseccion]['idseccion'] == null;
        auxseccion++) {
      cantidadsecciones++;
    }
    print("en total hay $cantidadsecciones secciones");
    double metrosseccion;
    if (datauser[0]['metrosavanzados'] != null) {
      for (aux = 0; aux < datauser.length; aux++) {
        String auxmetros = datauser[aux]["metrosavanzados"];
        double metrosavanzados = double.parse(auxmetros);

        String auxmetrosseccion2 = datauser[aux]["metrostotales"];
        metrosseccion = double.parse(auxmetrosseccion2);

        String aux2 = datauser[aux]['metrosavanzados'];
        double aux3 = double.parse(aux2);
        metrosavance = metrosavance + aux3;
      }
      var metrostot = metrosseccion.toStringAsFixed(2);
      metrostotales = double.parse(metrostot);
      porcentajeavance = (metrosavance * 100) / metrostotales;
      var auxiliarmetrostotales = porcentajeavance.toStringAsFixed(3);
      porcentajeavance = double.parse(auxiliarmetrostotales);
      listafinal = listaavance.cast<double>();
    }

    return datauser;
  }

  Future<List> getSecciones() async {
    String url3 =
        'http://gestionaproyecto.com/phpproyectotitulo/getSecciones.php';
    final response = await http.post(Uri.parse(url3), body: {
      "idproyecto": widget.idproyecto,
    });
    var datauser2 = json.decode(response.body);

    cantidadsecciones = datauser2.length;
    print("Actualmente existen $cantidadsecciones secciones");

    return datauser2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(46, 12, 21, 20),
          title: Text("Gestión de avance"),
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.18,
              child: Expanded(
                child: new FutureBuilder<List>(
                    future: getSecciones(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      return snapshot.hasData
                          ? new Secciones(
                              listasecciones: snapshot.data,
                              idproyecto: widget.idproyecto,
                            )
                          : new Center(
                              child: new CircularProgressIndicator(),
                            );
                    }),
              ),
            ),
            Expanded(
              child: new FutureBuilder<List>(
                  future: getAvance(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? new DatosAvance(
                            list: snapshot.data,
                            datosavance: listafinal,
                            idproyecto: widget.idproyecto,
                          )
                        : new Center(
                            child: new CircularProgressIndicator(),
                          );
                  }),
            ),
          ],
        ));
  }
}

class DatosAvance extends StatefulWidget {
  final List list;
  final List<double> datosavance;
  final String idproyecto;

  DatosAvance({Key key, this.list, this.datosavance, this.idproyecto})
      : super(key: key);

  @override
  _DatosAvanceState createState() => _DatosAvanceState();
}

class _DatosAvanceState extends State<DatosAvance> {
  List<charts.Series> seriesList;
  var datos2;

  encontrarlargo() {
    largo = widget.list.length;
  }

  List<charts.Series<DatosGrafico, String>> _DatosGr() {
    largo = widget.list.length;
    List<DatosGrafico> datos = [
      DatosGrafico(widget.list[0]["fechareporte"],
          double.parse(widget.list[0]["metrosavanzados"]), 3),
      DatosGrafico(widget.list[1]["fechareporte"],
          double.parse(widget.list[1]["metrosavanzados"]), 3),
      DatosGrafico(widget.list[2]["fechareporte"],
          double.parse(widget.list[2]["metrosavanzados"]), 3),
      DatosGrafico(widget.list[3]["fechareporte"],
          double.parse(widget.list[3]["metrosavanzados"]), 3),
    ];

    porcentaje = porcentajeavance / 100;
    print("el porcentaje es $porcentaje");

    return [
      charts.Series<DatosGrafico, String>(
        id: 'Datos',
        domainFn: (DatosGrafico datosg, _) => datosg.fecha,
        measureFn: (DatosGrafico datosg, _) => datosg.metros,
        data: datos,
      )
    ];
  }

  barChart() {
    return charts.BarChart(
      seriesList,
      animate: true,
    );
  }

  @override
  void initState() {
    super.initState();

    seriesList = _DatosGr();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: encontrarlargo(),
        builder: (context, snapshot) {
          return ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.all(10),
                        elevation: 4,
                        child: Container(
                            margin:
                                EdgeInsets.only(left: 60, right: 60, top: 20),
                            height: MediaQuery.of(context).size.height * 0.18,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Porcentaje de avance",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Center(
                                    child: Text(
                                  "$porcentajeavance%",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                )),
                                Text(
                                  "Se han avanzado $metrosavance metros de un total de $metrostotales metros",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 17),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  margin: EdgeInsets.all(10),
                                  elevation: 4,
                                  child: Stack(children: [
                                    Container(
                                      color: Colors.black,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.017,
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                    ),
                                    Container(
                                      color: Colors.blue,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.017,
                                      width: MediaQuery.of(context).size.width *
                                          porcentaje *
                                          0.5,
                                    )
                                  ]),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Center(
                    child: Text(
                      "Últimos días trabajados",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Column(
                  children: [
                    if (widget.list[0]["metrosavanzados"].length >= 4)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.all(10),
                              elevation: 4,
                              child: Container(
                                  margin: EdgeInsets.only(
                                      left: 30, right: 30, top: 20),
                                  height:
                                      MediaQuery.of(context).size.height * 0.22,
                                  child: barChart()),
                            ),
                          ),
                        ),
                      )
                    else
                      Text("No hay datos suficientes")
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new RaisedButton(
                      child: new Text(
                        "Agregar reporte de avance",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.black,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Agregarreporte(
                                      idproyecto: widget.idproyecto,
                                    )));
                      },
                    ),
                  ],
                )
              ]);
        });
  }
}

class DatosGrafico {
  final String fecha;
  final double metros;
  final double metrosavanzados;

  DatosGrafico(this.fecha, this.metros, this.metrosavanzados);
}

class Secciones extends StatefulWidget {
  final List listasecciones;
  final String idproyecto;

  const Secciones({Key key, this.listasecciones, this.idproyecto})
      : super(key: key);
  @override
  _SeccionesState createState() => _SeccionesState();
}

class _SeccionesState extends State<Secciones> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(builder: (context, snapshot) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                child: Text(
                  "Actualmente existen $cantidadsecciones secciones en tu proyecto",
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                )),
          ),
          new RaisedButton(
            child: new Text(
              "Ver secciones",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.black,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Agregarreporte(
                            idproyecto: widget.idproyecto,
                          )));
            },
          ),
        ],
      );
    });
  }
}
