import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'dart:async';
import 'dart:convert';

import 'detallemov.dart';

double porcentaje;
int largo = 0;
double metrosavance;
double metrostotales;
int cantidadmovimientos;
double porcentajeavance = 0;
String mensaje;

class DetalleMovimientos extends StatefulWidget {
  final String idproyecto;
  final String saldo;
  DetalleMovimientos({Key key, @required this.idproyecto, this.saldo})
      : super(key: key);

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
  Future<List> getFinanciera() async {
    final response = await http.post(Uri.parse(url2), body: {
      "idproyecto": widget.idproyecto,
    });
    var datauser = json.decode(response.body);
    int cantmov = datauser.length;
    cantmov = cantmov - 1;
    if (datauser != null && cantmov != 0) {
    } else {
      cantidadmovimientos = 0;
      mensaje = "No existen movimientos financieros";
    }
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
              if (snapshot.hasData && snapshot.data.length > 0) {
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
                                "Caja actual: " + widget.saldo,
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
                            return Column(
                              children: [
                                if (widget.list[i]['idtipomovimiento'] == '1')
                                  GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new DetalleMov(
                                                  idmov: widget.list[i]
                                                      ['idnotificaciones'],
                                                  idproyecto:
                                                      widget.idproyecto)),
                                    ),
                                    child: Column(
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
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Se realizó un ingreso con titulo: " +
                                                      widget.list[i]['titulo'] +
                                                      " de \$" +
                                                      widget.list[i]['ingreso'],
                                                  style:
                                                      TextStyle(fontSize: 21),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                else if (widget.list[i]['idtipomovimiento'] ==
                                    '2')
                                  GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new DetalleMov(
                                                  idmov: widget.list[i]
                                                      ['idnotificaciones'],
                                                  idproyecto:
                                                      widget.idproyecto)),
                                    ),
                                    child: Column(
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
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Se realizó un gasto con titulo: " +
                                                      widget.list[i]['titulo'] +
                                                      " de \$" +
                                                      widget.list[i]['ingreso'],
                                                  style:
                                                      TextStyle(fontSize: 21),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.date_range,
                                        size: 20,
                                      ),
                                      Text(
                                        widget.list[i]['fechapub'],
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider()
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
