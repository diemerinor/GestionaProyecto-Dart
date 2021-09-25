import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/detalle.dart';
import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

class DetallesContacto extends StatefulWidget {
  String idusuario;
  String idproyecto;
  List list;
  int index;
  DetallesContacto({this.index, this.list, this.idproyecto, this.idusuario});

  @override
  _DetallesContactoState createState() => _DetallesContactoState();
}

class _DetallesContactoState extends State<DetallesContacto> {
  String url2 =
      'http://gestionaproyecto.com/phpproyectotitulo/getDetalleContacto.php';
  List names = List();
  var datauser2;

  var datauser;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    super.dispose();
  }

  Future<List> getTrabajadores() async {
    final response = await http.post(Uri.parse(url2),
        body: {"idusuario": widget.idusuario, "idproyecto": widget.idproyecto});
    datauser = json.decode(response.body);
    cargoseleccionado = datauser[0]['idcargo'];
    print(cargoseleccionado);

    return datauser;
  }

  Future<List> getCargos() async {
    String url3 = 'http://gestionaproyecto.com/phpproyectotitulo/getCargos.php';
    final response = await http.post(Uri.parse(url3), body: {
      "idproyecto": widget.idproyecto,
    });
    datauser2 = json.decode(response.body);
    setState(() {
      names = datauser2;
    });

    return datauser2;
  }

  Future<List> editarCargo() async {
    final response = await http.post(Uri.parse(url5), body: {
      "idusuario": widget.idusuario,
      "idproyecto": widget.idproyecto,
      "cargo": cargoseleccionado
    });
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  String url5 =
      'http://gestionaproyecto.com/phpproyectotitulo/editarCargoUsuario.php';

  @override
  void initState() {
    super.initState();
    getCargos();
    getTrabajadores();
  }

  String cargoseleccionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Información contacto"),
        backgroundColor: colorappbar,
      ),
      backgroundColor: colorfondo,
      body: SingleChildScrollView(
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Card(
                child: new Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  if (widget.list[widget.index]['fotoperfil'] != null)
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                          border: Border.all(color: colorappbar, width: 3),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: new AssetImage(
                                  widget.list[widget.index]['fotoperfil']))),
                    )
                  else
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                          border: Border.all(color: colorappbar, width: 3),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: new AssetImage(
                                  'assets/images/sinfotoperfil.jpg'))),
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
                    padding:
                        const EdgeInsets.only(left: 30, right: 40, top: 10),
                    child: Text(
                      "${widget.list[widget.index]['acercademi']}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.list,
                        color: Colors.black,
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Expanded(
                        child: new DropdownButton<String>(
                          value: cargoseleccionado,
                          hint: Text("Seleccione cargo"),
                          items: names.map((list) {
                            return new DropdownMenuItem<String>(
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: new Text(list['nombrecargo'])),
                              value: list['idcargo'].toString(),
                            );
                          }).toList(),
                          onChanged: (value2) {
                            setState(() {
                              cargoseleccionado = value2;
                              print("se selecciono el valor $value2");
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: ElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: new Text(
                          "Editar cargo",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onPressed: () {
                        editarCargo();
                        //login();
                      },
                    ),
                  ),
                ]),
              ),
            )),
          ),
        ),
      ),
    );
  }
}
