import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/editarperfi.dart';
import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'dart:async';

class InfoPerfil extends StatefulWidget {
  final String idusuario;

  InfoPerfil({Key key, @required this.idusuario}) : super(key: key);
  @override
  _InfoPerfilState createState() => _InfoPerfilState();
}

class _InfoPerfilState extends State<InfoPerfil> {
  SharedPreferences sharedPreferences;
  String url2 =
      'http://gestionaproyecto.com/phpproyectotitulo/getInfoPerfil.php';

  Future<List> getinfoperfil() async {
    final response = await http.post(Uri.parse(url2), body: {
      "idusuario": widget.idusuario,
    });
    var datauser = json.decode(response.body);
    return datauser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mi perfil",
        ),
        backgroundColor: colorappbar,
        elevation: 0,
      ),
      body: new FutureBuilder<List>(
          future: getinfoperfil(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? new listarinformacion(
                    list: snapshot.data, idusuario: widget.idusuario)
                : new Center(
                    child: new CircularProgressIndicator(),
                  );
          }),
    );
  }
}

class listarinformacion extends StatefulWidget {
  final List list;
  final String idusuario;

  const listarinformacion({Key key, this.list, this.idusuario})
      : super(key: key);
  @override
  _listarinformacionState createState() => _listarinformacionState();
}

class _listarinformacionState extends State<listarinformacion> {
  SharedPreferences sharedPreferences;

  cerrarsesion() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('token');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginApp()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(),
        child: FloatingActionButton(
          child: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditarPerfil(
                        idusuario: widget.idusuario,
                      )),
            );
          },
        ),
      ),
      backgroundColor: colorfondo,
      // appBar: AppBar(
      //   title: Text("Perfil"),
      //   backgroundColor: Colors.black87,
      // ),
      body: ListView.builder(
          itemCount: widget.list == null ? 0 : widget.list.length,
          itemBuilder: (context, i) {
            return Column(
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    decoration: new BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            colorappbar,
                            colorappbar,
                          ],
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter),
                    ),

                    //color: Colors.lightBlue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (widget.list[i]['fotoperfil'] != null)
                          Column(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(this.context).size.height *
                                        0.25,
                                margin:
                                    EdgeInsets.only(bottom: 10.0, top: 20.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 3),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.fitHeight,
                                          image: new AssetImage(
                                              widget.list[i]['fotoperfil']))),
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top: 0.0),
                                  child: Text(
                                    widget.list[i]["nombreusuario"] +
                                        " " +
                                        widget.list[i]['apellidos'],
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )),
                            ],
                          )
                        else
                          Column(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(this.context).size.height *
                                        0.25,
                                margin:
                                    EdgeInsets.only(bottom: 10.0, top: 20.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 6),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: new AssetImage(
                                              'assets/images/sinfotoperfil.jpg'))),
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top: 0.0),
                                  child: Text(
                                    widget.list[i]["nombreusuario"] +
                                        " " +
                                        widget.list[i]['apellidos'],
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )),
                            ],
                          ),
                      ],
                    )),

                //
                Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    padding: EdgeInsets.only(top: 23, left: 10, right: 10),
                    child: Column(children: <Widget>[
                      // Los bordes del contenido del card se cortan usando BorderRadius

                      Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        padding: EdgeInsets.only(left: 10),
                        color: colorappbar,
                        child: Text(
                          'Acerca de mi:',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 10)),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          widget.list[i]['acercademi'],
                          style: TextStyle(fontSize: 22),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ])),

                Column(children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      padding: EdgeInsets.only(top: 23, left: 10, right: 10),
                      child: Column(children: <Widget>[
                        // Los bordes del contenido del card se cortan usando BorderRadius
                        Container(
                          width: MediaQuery.of(context).size.width * 0.90,
                          padding: EdgeInsets.only(left: 10),
                          color: colorappbar,
                          child: Text(
                            'Información de contacto:',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 10)),

                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Telefono: ' + widget.list[i]["telefono"],
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                'Correo: ' + widget.list[i]["correousuario"],
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        /*],
                      ),
                    )*/
                      ]))
                ]),
                Container(
                  margin: const EdgeInsets.only(right: 50, left: 50, top: 20),
                  width: 200,
                  child: RaisedButton(
                      child: Text(
                        "Cerrar sesión",
                        style: TextStyle(fontSize: 20),
                      ),
                      textColor: Colors.white,
                      color: colorappbar,
                      onPressed: () {
                        // sharedPreferences.clear();
                        // sharedPreferences.commit();
                        cerrarsesion();
                      }),
                )
              ],
            );
          }),
    );
  }
}
