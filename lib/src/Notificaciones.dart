import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/detalle.dart';
import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

class Notificaciones extends StatefulWidget {
  final String idusuario;

  const Notificaciones({Key key, this.idusuario}) : super(key: key);
  @override
  _NotificacionesState createState() => _NotificacionesState();
}

class _NotificacionesState extends State<Notificaciones> {
  String url2 =
      'http://gestionaproyecto.com/phpproyectotitulo/getNotificaciones.php';
  String url3 = 'http://gestionaproyecto.com/phpproyectotitulo/getData.php';

  // ignore: missing_return

  Future<List> getNotificaciones() async {
    final response =
        await http.post(Uri.parse(url2), body: {'idusuario': widget.idusuario});
    return json.decode(response.body);
  }

  // Future<List> getEventos() async {
  //   final response2 = await http.get(Uri.parse(url3));
  //   return json.decode(response2.body);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Actividad"),
        backgroundColor: colorappbar,
      ),
      body: new FutureBuilder<List>(
          future: getNotificaciones(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? new listatrabaj(
                    list: snapshot.data,
                  )
                : new Center(
                    child: new CircularProgressIndicator(),
                  );
          }),
    );
  }
}

class listatrabaj extends StatefulWidget {
  final List list;
  listatrabaj({this.list});

  @override
  _listatrabajState createState() => _listatrabajState();
}

class _listatrabajState extends State<listatrabaj> {
  String fechayhoranotificacion;
  DateTime fechayhora;
  int anos;

  String fechayhoranotificacion2;
  DateTime fechayhora2;
  int anos2;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: widget.list == null ? 0 : widget.list.length,
      itemBuilder: (context, i) {
        fechayhoranotificacion = widget.list[i]['fechayhora'];
        fechayhora = DateTime.parse(fechayhoranotificacion);
        Duration tiempodiferencia = DateTime.now().difference(fechayhora);

        if (tiempodiferencia.inDays > 365) {
          anos = ((tiempodiferencia.inDays) / 365).toInt();
        }

        fechayhoranotificacion2 = widget.list[i]['fechapublicacion'];
        fechayhora2 = DateTime.parse(fechayhoranotificacion2);
        Duration tiempodiferencia2 = DateTime.now().difference(fechayhora2);
        if (tiempodiferencia2.inDays > 365) {
          anos2 = ((tiempodiferencia2.inDays) / 365).toInt();
        }

        return new Container(
          padding: const EdgeInsets.all(10.0),
          child: new GestureDetector(
            onTap: () => Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context) => new Detalle(
                        list: widget.list,
                        index: i,
                      )),
            ),
            child: Column(
              children: <Widget>[
                Column(children: <Widget>[
                  if (widget.list[i]['idproyecto'] == null)
                    Text(
                      "No existen datos asociados",
                      style: TextStyle(fontSize: 20.0),
                    )
                  else if (widget.list[i]['idtipomovimiento'] == '1')
                    Column(children: <Widget>[
                      Text(widget.list[i]['nombreproyecto'],
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                      Text(
                        "Se realizó un ingreso de " +
                            widget.list[i]['montomovimiento'] +
                            " quedando un total de " +
                            widget.list[i]['caja'],
                        style: TextStyle(fontSize: 20.0),
                      ),
                      if (tiempodiferencia.inDays == 0)
                        Container(
                          alignment: Alignment.topRight,
                          child: Text(
                            'Se realizó hace ${tiempodiferencia.inHours} horas',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        )
                      else if (tiempodiferencia.inDays <= 365)
                        Container(
                          alignment: Alignment.topRight,
                          child: Text(
                              'Se realizó hace ${tiempodiferencia.inDays} días',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontStyle: FontStyle.italic,
                              )),
                        )
                      else if (tiempodiferencia.inDays >= 365)
                        Container(
                          alignment: Alignment.topRight,
                          child: Text('Se realizó hace más de $anos años',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontStyle: FontStyle.italic,
                              )),
                        ),
                      Divider(
                        color: Colors.black,
                      ),
                    ]),
                  if (widget.list[i]["idevento"] != null)
                    Column(children: <Widget>[
                      Text(widget.list[i]['nombreevento'],
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                      Text(
                        widget.list[i]["descripcion"],
                        style: TextStyle(fontSize: 20.0),
                      ),
                      if (tiempodiferencia2.inDays == 0)
                        Container(
                          alignment: Alignment.topRight,
                          child: Text(
                            'Se realizó hace ${tiempodiferencia2.inHours} horas',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        )
                      else if (tiempodiferencia2.inDays <= 365)
                        Container(
                          alignment: Alignment.topRight,
                          child: Text(
                              'Se realizó hace ${tiempodiferencia2.inDays} días',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontStyle: FontStyle.italic,
                              )),
                        )
                      else if (tiempodiferencia2.inDays >= 365)
                        Container(
                          alignment: Alignment.topRight,
                          child: Text('Se realizó hace más de $anos2 años',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontStyle: FontStyle.italic,
                              )),
                        ),
                      Divider(
                        color: Colors.black,
                      ),
                    ]),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }
}

// class Notificaciones extends StatelessWidget {
//   String nombre = "Diego Merino";
//   String usuario = "diemerinor";

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ListView(
//         children: <Widget>[
//           Container(
//             padding: const EdgeInsets.all(20.0),
//             child: Text(
//               "Notificaciones",
//               style: TextStyle(fontSize: 30),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
