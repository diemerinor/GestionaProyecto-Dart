import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/detalle.dart';
import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

class ListarEventos extends StatefulWidget {
  final String idproyecto;

  ListarEventos({Key key, this.idproyecto}) : super(key: key);
  @override
  _ListarEventosState createState() => _ListarEventosState();
}

class _ListarEventosState extends State<ListarEventos> {
  String url2 = 'http://gestionaproyecto.com/phpproyectotitulo/getEventos.php';

  Future<List> getEventos() async {
    final response = await http
        .post(Uri.parse(url2), body: {"idproyecto": widget.idproyecto});
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text("Eventos próximos"),
          backgroundColor: colorappbar,
        ),
        body: Column(
          children: [
            Expanded(
              child: new FutureBuilder<List>(
                  future: getEventos(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? new listareventoss(
                            list: snapshot.data,
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

class listareventoss extends StatefulWidget {
  final List list;
  final String idproyecto;

  const listareventoss({Key key, this.list, this.idproyecto}) : super(key: key);
  @override
  _listareventossState createState() => _listareventossState();
}

class _listareventossState extends State<listareventoss> {
  @override
  Widget build(BuildContext context) {
    return widget.list == null
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: widget.list == null ? 0 : widget.list.length,
            itemBuilder: (context, i) {
              return new Container(
                child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                          new MaterialPageRoute(
                              builder: (BuildContext context) => new Detalle(
                                    list: widget.list,
                                    index: i,
                                  )),
                        ),
                    child: Column(
                      children: [
                        if (widget.list != null)
                          Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: new Row(children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.75,
                                      child: new Text(
                                        widget.list[i]['titulo'] +
                                            " " +
                                            widget.list[i]['descripcion'],
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Icon(
                                            Icons.edit,
                                            color: Colors.red,
                                          ),
                                          Icon(
                                            Icons.verified_user_outlined,
                                            color: Colors.red,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ])),
                              Divider(),
                            ],
                          )
                        else if (widget.list.length == 1)
                          Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "No hay más \nparticipantes en el proyecto",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  RaisedButton(
                                    child: Text("Invita a tus contactos"),
                                    color: Colors.red,
                                    textColor: Colors.white,
                                    onPressed: () {},
                                  )
                                ]),
                          ),
                      ],
                    )),
              );
            });
  }
}

// class listarev extends StatefulWidget {
//   final List list;
//   final String idproyecto;

//   const listarev({Key key, this.list, this.idproyecto}) : super(key: key);
//   @override
//   _listarevState createState() => _listarevState();
// }

// class _listarevState extends State<listareventos> {
//   @override
//   Widget build(BuildContext context) {
    
//   }
// }
