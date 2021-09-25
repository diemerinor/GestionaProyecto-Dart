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
import 'editarcargoproyecto.dart';
import 'editarreporte.dart';
import 'gestionavance.dart';

double porcentaje;
int largo = 0;
double metrosavance;
double metrostotales;
int cantidadsecciones;
double porcentajeavance = 0;
String mensaje;

class DetalleAvance extends StatefulWidget {
  final String idproyecto;

  DetalleAvance({Key key, @required this.idproyecto}) : super(key: key);

  @override
  _DetalleAvanceState createState() => _DetalleAvanceState();
}

class _DetalleAvanceState extends State<DetalleAvance> {
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
      var metrostot = metrosseccion.toStringAsFixed(2);
      metrostotales = double.parse(metrostot);
      porcentajeavance = (metrosavance * 100) / metrostotales;
      var auxiliarmetrostotales = porcentajeavance.toStringAsFixed(3);
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
          title: Text("Detalle Avance"),
        ),
        backgroundColor: colorfondo,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: new FutureBuilder<List>(
                  future: getAvance(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    if (snapshot.hasData) {
                      if (largo != 0) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Avances",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(right: 10)),
                                    Container(
                                      width: 10.0,
                                      height: 10.0,
                                      decoration: new BoxDecoration(
                                        color: colorappbar,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 2,
                                        color: colorappbar,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: new DatosAvance(
                                list: snapshot.data,
                                datosavance: listafinal,
                                idproyecto: widget.idproyecto,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Text("No existe nada");
                      }
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          children: [
                            Center(
                                child: Text(
                              mensaje ?? '',
                              style: TextStyle(fontSize: 20),
                            )),
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
  String url = 'http://gestionaproyecto.com/phpproyectotitulo/DeleteAvance.php';
  String avanceaeliminar;
  Future<List> deleteavance() async {
    final response =
        await http.post(Uri.parse(url), body: {"idavance": avanceaeliminar});
  }

  @override
  void initState() {
    super.initState();
    mensaje = "Cargando avances...";
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continuar"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        deleteavance();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GestionAvance(
                      idproyecto: widget.idproyecto,
                    )));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("¿Está seguro de eliminar el reporte? "),
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
    return widget.list == null
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Divider(),
              if (widget.list != null)
                Expanded(
                  child: FutureBuilder<List>(builder: (context, snapshot) {
                    return ListView.builder(
                        itemCount: widget.list == null ? 0 : widget.list.length,
                        itemBuilder: (context, i) {
                          if (widget.list[i]['idreporteavance'] != null) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15),
                                  child: Text(
                                      "Sección: " +
                                          widget.list[i]['nombreseccion'],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15),
                                  child: Text(
                                      "Descripcion: " +
                                          widget.list[i]['descripcionavance'],
                                      style: TextStyle(
                                        fontSize: 20,
                                      )),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15),
                                  child: Text(
                                      "Avance: " +
                                          widget.list[i]['metrosavanzados'] +
                                          " " +
                                          widget.list[i]['nombreunidad'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: verde)),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       left: 15.0, right: 15),
                                //   child: Text(
                                //       "Total: " +
                                //           widget.list[i]['metrostotales'] +
                                //           " " +
                                //           widget.list[i]['nombreunidad'],
                                //       style: TextStyle(
                                //           fontWeight: FontWeight.bold,
                                //           fontSize: 20,
                                //           color: verde)),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () =>
                                              Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    new EditarReporte(
                                                      idproyecto:
                                                          widget.idproyecto,
                                                      idreporteavance: widget
                                                              .list[i]
                                                          ['idreporteavance'],
                                                    )),
                                          ),
                                          child: Card(
                                            color: Colors.teal,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => {
                                            setState(() {
                                              avanceaeliminar = widget.list[i]
                                                  ['idreporteavance'];
                                            }),
                                            showAlertDialog(context),
                                          },
                                          child: Card(
                                            color: colorappbar2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Row(
                                        children: [
                                          Icon(
                                            Icons.date_range,
                                            size: 20,
                                          ),
                                          Text(
                                            widget.list[i]['fechareportado3'],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ],
                                      ))
                                    ],
                                  ),
                                ),
                                Divider(),
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
