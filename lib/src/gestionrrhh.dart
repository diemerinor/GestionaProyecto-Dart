import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/gestionarproyecto.dart';
import 'package:gestionaproyecto/src/listartrabajadores.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';

class GestionRRHH extends StatefulWidget {
  final String idproyecto;
  final String idusuario;
  GestionRRHH({this.idproyecto, this.idusuario});
  @override
  _GestionRRHHState createState() => _GestionRRHHState();
}

class _GestionRRHHState extends State<GestionRRHH> {
  int indiceproyecto;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Gestión RRHH"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(
                  top: 10, left: 20.0, right: 20.0, bottom: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Buscador",
                ),
              )),
          GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new ListarTrabajadores(
                            idproyecto: widget.idproyecto,
                            idusuario: widget.idusuario,
                          ))),
              child: Column(children: <Widget>[
                Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    margin: EdgeInsets.all(15),
                    elevation: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Listar trabajadores',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ],
                      ),
                    )),
              ])),
          GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GestionarProyecto())),
              child: Column(children: <Widget>[
                Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    margin: EdgeInsets.all(15),
                    elevation: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Agregar trabajador',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ],
                      ),
                    )),
              ]))
        ],
      ),
    );
  }
}


// class GestionRRHH extends StatefulWidget {
//   String nombreusuario = "Diego Merino Rubilar";
//   int _selectedIndex = 1;

//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     Widget build(BuildContext context) {
      
//     }
//   }
// }
