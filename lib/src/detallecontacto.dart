import 'package:gestionaproyecto/src/detalle.dart';
import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

class DetallesContacto extends StatefulWidget {
  List list;
  int index;
  DetallesContacto({this.index, this.list});

  @override
  _DetallesContactoState createState() => _DetallesContactoState();
}

class _DetallesContactoState extends State<DetallesContacto> {
  String url2 =
      'http://gestionaproyecto.com/phpproyectotitulo/getParticipantes.php';

  // Future<List> getTrabajadores() async {
  //   final response = await http
  //       .post(Uri.parse(url2), body: {"idproyecto": widget.idproyecto});
  //   return json.decode(response.body);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Información contacto"),
      ),
      body: new Container(
          height: 500,
          padding: const EdgeInsets.all(20.0),
          child: new Card(
              child: new Center(
                  child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(
                  top: 30.0,
                ),
              ),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 3),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: new AssetImage(
                            widget.list[widget.index]['fotoperfil']))),
              ),
              new Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                ),
              ),
              Text(
                "${widget.list[widget.index]['nombreusuario']}" +
                    " ${widget.list[widget.index]['apellidos']}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 40, top: 10),
                child: Text(
                  "${widget.list[widget.index]['acercademi']}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.message),
                onPressed: () => print('hi on menu icon'),
              ),
              Divider(),
            ],
          )))),
    );
  }
}