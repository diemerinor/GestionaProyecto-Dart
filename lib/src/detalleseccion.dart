import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/editarseccion.dart';
import 'package:http/http.dart' as http;

import 'gestionseccion.dart';
import 'dart:async';
import 'dart:convert';

class DetalleSeccion extends StatefulWidget {
  List list;
  int index;
  DetalleSeccion({this.index, this.list});

  @override
  _DetalleSeccionState createState() => _DetalleSeccionState();
}

class _DetalleSeccionState extends State<DetalleSeccion> {
  String url =
      'http://gestionaproyecto.com/phpproyectotitulo/deleteSeccion.php';
  String porcentaje = 'Cargando...';
  String avanzado = 'Cargando...';
  Future<List> deleteseccion() async {
    final response = await http.post(Uri.parse(url),
        body: {"idseccion": widget.list[widget.index]['idseccion']});
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
        deleteseccion();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListarSecciones(
                      idproyecto: widget.list[widget.index]['idproyecto'],
                    )));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("¿Está seguro de eliminar la sección? "),
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

  Future<List> getinfoproyecto() async {
    String url7 =
        'http://gestionaproyecto.com/phpproyectotitulo/getInfoSeccion2.php';
    final response = await http.post(Uri.parse(url7), body: {
      "idseccion": widget.list[widget.index]['idseccion'],
    });
    var datauser = json.decode(response.body);
    setState(() {
      if (datauser != null && datauser[0]['metros'] != null) {
        String auxavan = datauser[0]['metros'];
        double auxporce = double.parse(auxavan);
        String auxmetrosseccion = datauser[0]['metrosseccion'];
        double auxtotal = double.parse(auxmetrosseccion);
        avanzado = datauser[0]['metros'] + " " + datauser[0]['nombreunidad'];
        double porcen = (auxporce * 100) / auxtotal;

        //porcen = porcen.toString as double;
        print(porcen);
        porcentaje = porcen.toStringAsFixed(2);
        porcentaje = porcentaje + "%";
      } else {
        avanzado = "0 " + datauser[0]['nombreunidad'];
        porcentaje = "0%";
      }
      print(porcentaje);
    });

    return datauser;
  }

  @override
  void initState() {
    super.initState();
    getinfoproyecto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorfondo,
      appBar: AppBar(
        backgroundColor: colorappbar,
        title: new Text("Información sección"),
      ),
      body: Container(
        child: new Center(
            child: new Column(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(
                top: 30.0,
              ),
            ),
            new Text(
              widget.list[widget.index]['nombreseccion'],
              style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            new Text(
              widget.list[widget.index]['descripcionseccion'],
              style: new TextStyle(fontSize: 20.0),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: new BoxDecoration(
                      color: verde,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 10.0)),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      "Total sección:\n" +
                          widget.list[widget.index]['metrosseccion'] +
                          " " +
                          widget.list[widget.index]['nombreunidad'],
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: new BoxDecoration(
                      color: azul,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 10.0)),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text("Avanzado:\n" + avanzado,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: new BoxDecoration(
                      color: rojooscuro,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 10.0)),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text("Porcentaje de avance:\n" + porcentaje,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    child: Icon(
                      Icons.monetization_on,
                      color: colorappbar,
                      size: 23,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 10.0)),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: new Text(
                      "Valor sección: \$" +
                          widget.list[widget.index]['preciounitario'],
                      textAlign: TextAlign.start,
                      style: new TextStyle(fontSize: 20.0),
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RaisedButton(
                  child: Text(
                    "Editar",
                    style: TextStyle(fontSize: 20),
                  ),
                  color: colorappbar,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditarSeccion(
                                  idproyecto: widget.list[widget.index]
                                      ['idproyecto'],
                                  idseccion: widget.list[widget.index]
                                      ['idseccion'],
                                )));
                  },
                ),
                Padding(padding: EdgeInsets.only(right: 16)),
                RaisedButton(
                  onPressed: () => {
                    showAlertDialog(context),
                  },
                  child: Text("Eliminar", style: TextStyle(fontSize: 20)),
                  color: colorappbar,
                  textColor: Colors.white,
                ),
              ],
            )
          ],
        )),
      ),
    );
  }
}
