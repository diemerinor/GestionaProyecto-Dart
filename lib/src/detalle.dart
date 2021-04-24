import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Detalle extends StatefulWidget {
  List list;
  int index;
  Detalle({this.index, this.list});

  @override
  _DetalleState createState() => _DetalleState();
}

class _DetalleState extends State<Detalle> {
  void deletetrabajador() {
    String url2 = 'http://gestionaproyecto.com/phpproyectotitulo/getData.php';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("${widget.list[widget.index]['nombreusuario']}"),
      ),
      body: new Container(
          height: 270.0,
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
              new Text(
                widget.list[widget.index]['nombreusuario'],
                style: new TextStyle(fontSize: 20.0),
              ),
              Divider(),
            ],
          )))),
    );
  }
}
