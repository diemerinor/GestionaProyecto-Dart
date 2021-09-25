import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/buscarcontactos.dart';
import 'package:gestionaproyecto/src/detallecontacto.dart';
import 'package:http/http.dart' as http;
import 'package:expansion_tile_card/expansion_tile_card.dart';

import 'dart:async';
import 'dart:convert';

import '../main.dart';

class AgregarColaborador extends StatefulWidget {
  final String idusuario;
  final String idproyecto;

  const AgregarColaborador({Key key, this.idusuario, this.idproyecto})
      : super(key: key);
  @override
  _AgregarColaboradorState createState() => _AgregarColaboradorState();
}

class _AgregarColaboradorState extends State<AgregarColaborador> {
  String url2 =
      'http://gestionaproyecto.com/phpproyectotitulo/getUsuariosNoParticipantes.php';
  bool botonagregar = false;
  TextEditingController controllerbuscar = new TextEditingController();
  var solicitudes = [];

  Future<List> getContactos() async {
    final response = await http.post(Uri.parse(url2), body: {
      "idusuario": identificadorusuario,
      "idproyecto": widget.idproyecto
    });
    solicitudes = json.decode(response.body);
    print(solicitudes);
    return solicitudes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorappbar,
          title: Text("Agregar Colaborador"),
        ),
        body: Column(
          children: [
            Visibility(
                visible: botonagregar,
                child: Column(
                  children: [
                    TextFormField(
                        controller: controllerbuscar,
                        decoration: InputDecoration(
                          hintText: 'Agregar contacto',
                          icon: Icon(
                            Icons.east,
                            color: Colors.black,
                          ),
                        )),
                    RaisedButton(
                        child: Text(
                          "Buscar",
                          style: TextStyle(fontSize: 20),
                        ),
                        textColor: Colors.white,
                        color: colorappbar,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BuscarContactos(
                                        idusuario: controllerbuscar.text,
                                        identificadorusuario:
                                            identificadorusuario,
                                      )));
                          // sharedPreferences.clear();
                          // sharedPreferences.commit();
                        }),
                  ],
                )),
            Expanded(
              child: new FutureBuilder<List>(
                  future: getContactos(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? new listarcontactos(
                            list: snapshot.data,
                            idusuario: widget.idusuario,
                            idproyecto: widget.idproyecto,
                          )
                        : Center(
                            child: Text(
                            "No existen solicitudes",
                            style: TextStyle(fontSize: 25),
                          ));
                  }),
            )
          ],
        ));
  }
}

class listarcontactos extends StatefulWidget {
  final List list;
  final String idusuario;
  final String idproyecto;

  const listarcontactos({Key key, this.list, this.idusuario, this.idproyecto})
      : super(key: key);
  @override
  _listarcontactosState createState() => _listarcontactosState();
}

class _listarcontactosState extends State<listarcontactos> {
  String cargoseleccionado;
  List cargos = List();
  @override
  void initState() {
    super.initState();
    getCargos();
  }

  String url3 = 'http://gestionaproyecto.com/phpproyectotitulo/getCargos.php';
  Future<List> getCargos() async {
    final response = await http
        .post(Uri.parse(url3), body: {"idproyecto": widget.idproyecto});
    var datauser = json.decode(response.body);
    setState(() {
      cargos = datauser;
    });
    return datauser;
  }

  Future<List> eliminarAmistad(idusuario1) async {
    String url3 =
        'http://gestionaproyecto.com/phpproyectotitulo/RechazarSolicitud.php';
    final response = await http.post(Uri.parse(url3),
        body: {"idusuario": idusuario1, "idusuario2": identificadorusuario});
  }

  Future<List> agregarParticipante(idusuario1) async {
    String url3 =
        'http://gestionaproyecto.com/phpproyectotitulo/AgregarParticipante.php';
    final response = await http.post(Uri.parse(url3), body: {
      "idusuario": idusuario1,
      "idproyecto": widget.idproyecto,
      "idcargo": cargoseleccionado
    });
  }

  bool botonagregar = false;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: widget.list == null ? 0 : widget.list.length,
        itemBuilder: (context, i) {
          int idusuarioid = int.parse(widget.list[i]['idusuario']);

          return Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if ((widget.list[i]['idusuario'] != widget.idusuario))
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ExpansionTileCard(
                          baseColor: colorappbar,
                          expandedColor: colorappbar,
                          title: Row(
                            children: [
                              Text(
                                widget.list[i]['nombreusuario'] +
                                    " " +
                                    widget.list[i]['apellidos'],
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          children: <Widget>[
                            Divider(
                              thickness: 0.4,
                              height: 0.4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                DropdownButton<String>(
                                  dropdownColor: Colors.redAccent,
                                  value: cargoseleccionado,
                                  hint: Text(
                                    "Seleccione cargo",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  items: cargos.map((list) {
                                    return new DropdownMenuItem<String>(
                                      child: new Text(
                                        list['nombrecargo'],
                                        style: TextStyle(color: Colors.white),
                                      ),
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
                                GestureDetector(
                                  onTap: () => {
                                    agregarParticipante(
                                        widget.list[i]['idusuario']),
                                    Navigator.pop(context),
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AgregarColaborador(
                                                idusuario: identificadorusuario,
                                                idproyecto: widget.idproyecto,
                                              )),
                                    )
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Agregar"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
