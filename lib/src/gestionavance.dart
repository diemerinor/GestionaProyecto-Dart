import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/agregarreporte.dart';
import 'package:gestionaproyecto/src/gestionseccion.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'detalleavance.dart';

double porcentaje;
int largo = 0;
double metrosavance;
double metrostotales;
int cantidadsecciones;
double porcentajeavance = 0;
String mensaje;

class GestionAvance extends StatefulWidget {
  final String idproyecto;

  GestionAvance({Key key, @required this.idproyecto}) : super(key: key);

  @override
  _GestionAvanceState createState() => _GestionAvanceState();
}

class _GestionAvanceState extends State<GestionAvance> {
  var listaavance = [];
  int cantidad;
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
    if (datauser == null) {
      mensaje = "No existen registros";
    } else if (datauser != null) {
      largo = datauser.length;
      mensaje = "";
    }
    double metrosseccion;
    if (datauser != null) {
      for (aux = 0; aux < datauser.length; aux++) {
        String auxmetros = datauser[aux]["metrosavanzados"];
        double metrosavanzados = double.parse(auxmetros);

        String auxmetrosseccion2 = datauser[aux]["metrostotales"];
        metrosseccion = double.parse(auxmetrosseccion2);

        String aux2 = datauser[aux]['metrosavanzados'];
        double aux3 = double.parse(aux2);
        metrosavance = metrosavance + aux3;
      }
      print("estoy aca");
      print(metrosseccion);
      print(metrosavance);
      var metrostot = metrosseccion.toStringAsFixed(6);
      metrostotales = double.parse(metrostot);
      porcentajeavance = (metrosavance * 100) / metrostotales;
      print(porcentajeavance);
      var auxiliarmetrostotales = porcentajeavance.toStringAsFixed(4);
      porcentajeavance = double.parse(auxiliarmetrostotales);
      listafinal = listaavance.cast<double>();
    } else {
      largo = 0;
      print("ni entro");
    }
    print("el largo quedo en $largo");
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
          backgroundColor: colorappbar,
          title: Text("Gestión de avance"),
        ),
        backgroundColor: colorfondo,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.09,
              child: Column(
                children: [
                  Expanded(
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
                ],
              ),
            ),
            Expanded(
              child: new FutureBuilder<List>(
                  future: getAvance(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    if (snapshot.hasData) {
                      if (largo != 0) {
                        return new DatosAvance(
                          list: snapshot.data,
                          datosavance: listafinal,
                          idproyecto: widget.idproyecto,
                        );
                      } else {
                        return Text("No existe nada");
                      }
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          children: [
                            Text(mensaje ?? '', style: TextStyle(fontSize: 25)),
                            RaisedButton(
                              child: new Text(
                                "Crear reporte de avance",
                                style: (TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                              ),
                              color: colorappbar,
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(20.0)),
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
                        ),
                      );
                    }
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

  List<charts.Series<DatosGrafico, String>> _DatosGr() {
    List<DatosGrafico> datos = [
      DatosGrafico((widget.list[0]["fechareportado3"]),
          double.parse(widget.list[0]["metrosavanzados"]), 3)
    ];
    int i = 1;

    while (i < largo && i < 5) {
      datos.add(DatosGrafico((widget.list[i]["fechareportado3"]),
          double.parse(widget.list[i]["metrosavanzados"]), 3));

      i++;
    }

    porcentaje = porcentajeavance / 100;

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
    mensaje = "Cargando avances";
    if (largo > 0) {
      seriesList = _DatosGr();
    }
  }

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
                        itemCount: widget.list == null ? 0 : 1,
                        itemBuilder: (context, i) {
                          if (widget.list != null) {
                            return Column(
                              children: [
                                if (largo > 0)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetalleAvance(
                                                    idproyecto:
                                                        widget.idproyecto,
                                                  ))),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        margin: EdgeInsets.all(10),
                                        elevation: 4,
                                        child: Expanded(
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 60, right: 60, top: 20),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Column(
                                                children: <Widget>[
                                                  Column(
                                                    children: [
                                                      Text(
                                                        "Porcentaje de avance",
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Center(
                                                          child: Text(
                                                        "$porcentajeavance%",
                                                        style: TextStyle(
                                                            fontSize: 40,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                      Card(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        margin:
                                                            EdgeInsets.all(10),
                                                        elevation: 4,
                                                        child: Stack(children: [
                                                          Container(
                                                            color: Colors.black,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.017,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.5,
                                                          ),
                                                          Container(
                                                            color: colorappbar2,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.017,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                porcentaje *
                                                                0.5,
                                                          )
                                                        ]),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 8.0),
                                                        child: Text(
                                                          "Haz click para más detalles",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 17),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                new RaisedButton(
                                  child: new Text(
                                    "Agregar reporte de avance",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: colorappbar,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0)),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Agregarreporte(
                                                  idproyecto: widget.idproyecto,
                                                )));
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Center(
                                    child: Text(
                                      "Últimos días trabajados",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    if (largo > 0)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              margin: EdgeInsets.all(10),
                                              elevation: 4,
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      top: 20),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.22,
                                                  child: barChart()),
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      Text("No hay datos suficientes")
                                  ],
                                ),
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
    return widget.listasecciones == null
        ? Center(child: CircularProgressIndicator())
        : FutureBuilder<List>(builder: (context, snapshot) {
            return ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Gestiona por sección",
                            style: TextStyle(fontSize: 20),
                          ),
                          Padding(padding: EdgeInsets.only(right: 10)),
                          new RaisedButton(
                            child: new Text(
                              "Ver más",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: colorappbar,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(3.0)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ListarSecciones(
                                            idproyecto: widget.idproyecto,
                                          )));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                // ListView.builder(
                //     itemCount: widget.listasecciones == null ? 0 : 1,
                //     itemBuilder: (context, i) {
                //       if (widget.listasecciones[0]['idseccion'] != null) {
                //         return Container(
                //           width: MediaQuery.of(context).size.width,
                //           child: Padding(
                //             padding: const EdgeInsets.all(20.0),
                //             child: Center(
                //               child: Row(
                //                 children: [
                //                   Text(
                //                     "Gestiona por sección",
                //                     style: TextStyle(fontSize: 20),
                //                     textAlign: TextAlign.center,
                //                   ),
                //                   Padding(padding: EdgeInsets.only(right: 10)),
                //                   new RaisedButton(
                //                     child: new Text(
                //                       "Ver más",
                //                       style: TextStyle(
                //                           color: Colors.white, fontSize: 20),
                //                     ),
                //                     color: Colors.black,
                //                     shape: new RoundedRectangleBorder(
                //                         borderRadius:
                //                             new BorderRadius.circular(3.0)),
                //                     onPressed: () {
                //                       Navigator.push(
                //                           context,
                //                           MaterialPageRoute(
                //                               builder: (context) =>
                //                                   Agregarreporte(
                //                                     idproyecto:
                //                                         widget.idproyecto,
                //                                   )));
                //                     },
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ),
                //         );
                //       } else {
                //         return Text("Hola");
                //       }
                //     }),
              ],
            );
          });
  }
}
