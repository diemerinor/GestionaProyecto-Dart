import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/detallemovimientos.dart';
import 'package:gestionaproyecto/src/registrargasto.dart';
import 'package:gestionaproyecto/src/registraringreso.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:intl/intl.dart';

import 'dart:async';
import 'dart:convert';

String caja;

String nombreproyectoss;
int cajafinal;
int largo = 0;
int cantidadmovimientos = 0;

class GestionFinanciera extends StatefulWidget {
  final String idproyecto;

  GestionFinanciera({Key key, this.idproyecto}) : super(key: key);
  @override
  _GestionFinancieraState createState() => _GestionFinancieraState();
}

class DatosGrafico {
  final String fecha;
  final double metros;
  final double metrosavanzados;
  final String idtipomovimiento;

  DatosGrafico(
      this.fecha, this.metros, this.metrosavanzados, this.idtipomovimiento);
}

class _GestionFinancieraState extends State<GestionFinanciera> {
  List<charts.Series> seriesList;

  String url2 =
      'http://gestionaproyecto.com/phpproyectotitulo/getMovimientos.php';

  String cajafinal2;
  int cantmov;
  int sizeMov;

  Future<List> getFinanciera() async {
    final response = await http.post(Uri.parse(url2), body: {
      "idproyecto": widget.idproyecto,
    });

    var datauser = json.decode(response.body);
    cantmov = datauser.length;
    sizeMov = datauser.length;
    cajafinal = 0;
    if (cantmov > 0) {
      nombreproyectoss = datauser[0]['nombreproyecto'];
      //caja = datauser[cantmov]['total'];
      //cajafinal = int.parse(caja);

      for (int i = 0; i < cantmov; i++) {
        var aux1 = datauser[i]['ingreso'];
        int aux2 = int.parse(aux1);
        if (datauser[i]['idtipomovimiento'] == '1') {
          cajafinal = cajafinal + aux2;
        } else if (datauser[i]['idtipomovimiento'] == '2') {
          cajafinal = cajafinal - aux2;
        }
      }

      cantmov = cantmov - 1;
      cantidadmovimientos = cantmov;
      cajafinal2 = (NumberFormat.simpleCurrency(name: 'USD', decimalDigits: 0)
          .format(cajafinal));
    }
    return datauser;
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
                    return ListView(
                      children: [
                        if (sizeMov > 0)
                          Container(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Expanded(
                              child: new listarinfofinanciera(
                                listainfo: snapshot.data,
                                idproyecto: widget.idproyecto,
                                cajafinal2: cajafinal2,
                                cajafinal: cajafinal,
                              ),
                            ),
                          ),
                        if (sizeMov > 0)
                          Container(
                            child: Expanded(
                              child: new DatosFinanciera(
                                listainfo: snapshot.data,
                                idproyecto: widget.idproyecto,
                                cajafinal2: cajafinal2,
                                cajafinal: cajafinal,
                              ),
                            ),
                          ),
                        Column(
                          children: [
                            if (sizeMov == 0)
                              Container(
                                padding: EdgeInsets.only(bottom: 20, top: 20),
                                child: Text(
                                  "No existen movimientos financieros",
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                      onTap: () => {
                                            Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          new RegistrarGasto(
                                                            idproyecto: widget
                                                                .idproyecto,
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
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                        children: <Widget>[
                                                          Icon(Icons.south_east,
                                                              size: 60),
                                                          Text(
                                                            'Registrar\ngasto',
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ]),
                                                  ))),
                                        ],
                                      )),
                                  GestureDetector(
                                      onTap: () => {
                                            Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          new RegistrarIngreso(
                                                            idproyecto: widget
                                                                .idproyecto,
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
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                        children: <Widget>[
                                                          Icon(Icons.north_east,
                                                              size: 60),
                                                          Text(
                                                            'Registrar\ningreso',
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                            textAlign: TextAlign
                                                                .center,
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
                      ],
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

class DatosFinanciera extends StatefulWidget {
  final List listainfo;
  final String idproyecto;
  final String cajafinal2;
  final int cajafinal;

  const DatosFinanciera(
      {Key key,
      this.listainfo,
      this.idproyecto,
      this.cajafinal2,
      this.cajafinal})
      : super(key: key);

  @override
  _DatosFinancieraState createState() => _DatosFinancieraState();
}

class _DatosFinancieraState extends State<DatosFinanciera> {
  List<charts.Series> seriesList;
  var datos2;

  List<charts.Series<DatosGrafico, String>> _DatosGr() {
    //print(widget.listainfo[0]["fechareportado"]);
    List<DatosGrafico> datos = [
      DatosGrafico(
          (widget.listainfo[0]["fechareportado"]),
          double.parse(widget.listainfo[0]["ingreso"]),
          3,
          widget.listainfo[0]["idtipomovimiento"])
    ];
    int i = 0;
    print("cantidad $cantidadmovimientos");
    int valorfinal = cantidadmovimientos + 1;
    while (i < valorfinal && i < 5) {
      print(widget.listainfo[i]["fechareportado"]);
      print("aca entro $i");
      datos.add(DatosGrafico(
          (widget.listainfo[i]["fechareportado"]),
          double.parse(widget.listainfo[i]["ingreso"]),
          4,
          widget.listainfo[i]["idtipomovimiento"]));

      i++;
    }
    print(datos);
    final blue = charts.MaterialPalette.blue.makeShades(2);
    final red = charts.MaterialPalette.red.makeShades(2);
    final green = charts.MaterialPalette.green.makeShades(2);

    porcentaje = porcentajeavance / 100;

    return [
      charts.Series<DatosGrafico, String>(
          id: 'Datos',
          domainFn: (DatosGrafico datosg, _) => datosg.fecha,
          measureFn: (DatosGrafico datosg, _) => datosg.metros,
          data: datos,
          colorFn: (DatosGrafico datosg, _) {
            switch (datosg.idtipomovimiento) {
              case "1":
                {
                  return green[1];
                }
              case "2":
                {
                  return red[1];
                }
            }
          })
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
    // TODO: implement initState
    super.initState();
    if (cantidadmovimientos >= 0) {
      seriesList = _DatosGr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (cantidadmovimientos >= 0)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new DetalleMovimientos(
                            idproyecto: widget.idproyecto,
                            saldo: widget.cajafinal2)),
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.all(10),
                    elevation: 4,
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.red, width: 10),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                              ),
                              Text("Gastos"),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                              ),
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.green, width: 10),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                              ),
                              Text("Ingresos"),
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            height: MediaQuery.of(context).size.height * 0.22,
                            child: barChart()),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "Haz click para más detalles",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        else
          Text("No hay datos suficientes")
      ],
    );
  }
}

class listarinfofinanciera extends StatefulWidget {
  final List listainfo;
  final String idproyecto;
  final String cajafinal2;
  final int cajafinal;

  const listarinfofinanciera(
      {Key key,
      this.listainfo,
      this.idproyecto,
      this.cajafinal2,
      this.cajafinal})
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
                          // Text(
                          //   nombreproyectoss,
                          //   style: TextStyle(fontSize: 20),
                          //   textAlign: TextAlign.center,
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.cajafinal2,
                                style: TextStyle(
                                    color: colorappbar,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Text(
                            "Saldo disponible",
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
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
                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //     children: [
                        //       GestureDetector(
                        //           onTap: () => Navigator.of(context).push(
                        //                 new MaterialPageRoute(
                        //                     builder: (BuildContext context) =>
                        //                         new DetalleMovimientos(
                        //                             idproyecto:
                        //                                 widget.idproyecto,
                        //                             saldo: widget.cajafinal2)),
                        //               ),
                        //           child: Column(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.center,
                        //             children: [
                        //               Container(
                        //                   width: MediaQuery.of(context)
                        //                           .size
                        //                           .width *
                        //                       0.4,
                        //                   child: Card(
                        //                       elevation: 5,
                        //                       child: Padding(
                        //                         padding:
                        //                             const EdgeInsets.all(8.0),
                        //                         child:
                        //                             Column(children: <Widget>[
                        //                           Icon(Icons.list, size: 60),
                        //                           Text(
                        //                             'Listar\nmovimientos',
                        //                             style:
                        //                                 TextStyle(fontSize: 20),
                        //                             textAlign: TextAlign.center,
                        //                           ),
                        //                         ]),
                        //                       ))),
                        //             ],
                        //           )),
                        //       GestureDetector(
                        //           onTap: () => {
                        //                 Navigator.of(context).push(
                        //                   new MaterialPageRoute(
                        //                       builder: (BuildContext context) =>
                        //                           new RegistrarIngreso(
                        //                             idproyecto:
                        //                                 widget.idproyecto,
                        //                             caja: widget.cajafinal,
                        //                           )),
                        //                 )
                        //               },
                        //           child: Column(
                        //             children: [
                        //               Container(
                        //                   width: MediaQuery.of(context)
                        //                           .size
                        //                           .width *
                        //                       0.4,
                        //                   child: Card(
                        //                       elevation: 5,
                        //                       child: Padding(
                        //                         padding:
                        //                             const EdgeInsets.all(8.0),
                        //                         child:
                        //                             Column(children: <Widget>[
                        //                           Icon(Icons.north_east,
                        //                               size: 60),
                        //                           Text(
                        //                             'Registrar\ningreso',
                        //                             style:
                        //                                 TextStyle(fontSize: 20),
                        //                             textAlign: TextAlign.center,
                        //                           ),
                        //                         ]),
                        //                       ))),
                        //             ],
                        //           )),
                        //     ],
                        //   ),
                        // ),
                        // Padding(padding: EdgeInsets.only(bottom: 10)),
                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //     children: [
                        //       GestureDetector(
                        //           child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           Container(
                        //               width: MediaQuery.of(context).size.width *
                        //                   0.4,
                        //               child: Card(
                        //                   elevation: 5,
                        //                   child: Padding(
                        //                     padding: const EdgeInsets.all(8.0),
                        //                     child: Column(children: <Widget>[
                        //                       Icon(Icons.bar_chart, size: 60),
                        //                       Text(
                        //                         'Balance\ngráfico',
                        //                         style: TextStyle(fontSize: 20),
                        //                         textAlign: TextAlign.center,
                        //                       ),
                        //                     ]),
                        //                   ))),
                        //         ],
                        //       )),
                        //       GestureDetector(
                        //           onTap: () => {
                        //                 Navigator.of(context).push(
                        //                   new MaterialPageRoute(
                        //                       builder: (BuildContext context) =>
                        //                           new RegistrarGasto(
                        //                             idproyecto:
                        //                                 widget.idproyecto,
                        //                             caja: widget.cajafinal,
                        //                           )),
                        //                 )
                        //               },
                        //           child: Column(
                        //             children: [
                        //               Container(
                        //                   width: MediaQuery.of(context)
                        //                           .size
                        //                           .width *
                        //                       0.4,
                        //                   child: Card(
                        //                       elevation: 5,
                        //                       child: Padding(
                        //                         padding:
                        //                             const EdgeInsets.all(8.0),
                        //                         child:
                        //                             Column(children: <Widget>[
                        //                           Icon(Icons.south_east,
                        //                               size: 60),
                        //                           Text(
                        //                             'Registrar\ngasto',
                        //                             style:
                        //                                 TextStyle(fontSize: 20),
                        //                             textAlign: TextAlign.center,
                        //                           ),
                        //                         ]),
                        //                       ))),
                        //             ],
                        //           )),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
