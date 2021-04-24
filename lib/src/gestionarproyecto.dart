import 'dart:convert';

import 'package:gestionaproyecto/src/listartrabajadores.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:gestionaproyecto/src/gestionrrhh.dart';
import 'package:http/http.dart' as http;

class GestionarProyecto extends StatefulWidget {
  List list;
  int index;
  @override
  _GestionarProyectoState createState() => _GestionarProyectoState();
}

class _GestionarProyectoState extends State<GestionarProyecto> {
  String url2 = 'http://gestionaproyecto.com/phpproyectotitulo/getProyecto.php';

  Future<List> getTrabajadores() async {
    final response = await http.get(Uri.parse(url2));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: new Text("${widget.list[widget.index]['nombreproyecto']}"),
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
          CarouselSlider(
              items: [
                Container(
                    child: ListView(children: <Widget>[
                  GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GestionRRHH())),
                      child: Column(children: <Widget>[
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            margin: EdgeInsets.all(15),
                            elevation: 10,

                            // Dentro de esta propiedad usamos ClipRRect
                            child: ClipRRect(
                              // Los bordes del contenido del card se cortan usando BorderRadius
                              borderRadius: BorderRadius.circular(16),

                              // EL widget hijo que será recortado segun la propiedad anterior
                              child: Column(
                                children: <Widget>[
                                  // Usamos el widget Image para mostrar una imagen
                                  Image(
                                    // Como queremos traer una imagen desde un url usamos NetworkImage
                                    image: NetworkImage(
                                        'https://www.protek.com.py/sitio/wp-content/uploads/2019/12/obra-en-construcci%C3%B3n-1-1024x576.jpg'),
                                  ),

                                  // Usamos Container para el contenedor de la descripción
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text('Gestión de recursos humanos'),
                                  ),
                                ],
                              ),
                            ))
                      ]))
                ])),

                //2nd Image of Slider
                Container(
                    child: ListView(children: <Widget>[
                  GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GestionarProyecto())),
                      child: Column(children: <Widget>[
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            margin: EdgeInsets.all(15),
                            elevation: 10,

                            // Dentro de esta propiedad usamos ClipRRect
                            child: ClipRRect(
                              // Los bordes del contenido del card se cortan usando BorderRadius
                              borderRadius: BorderRadius.circular(16),

                              // EL widget hijo que será recortado segun la propiedad anterior
                              child: Column(
                                children: <Widget>[
                                  // Usamos el widget Image para mostrar una imagen
                                  Icon(Icons.home),

                                  // Usamos Container para el contenedor de la descripción
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text('Gestión de avance'),
                                  ),
                                ],
                              ),
                            ))
                      ]))
                ])),

                Container(
                    child: ListView(children: <Widget>[
                  GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GestionarProyecto())),
                      child: Column(children: <Widget>[
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            margin: EdgeInsets.all(15),
                            elevation: 10,

                            // Dentro de esta propiedad usamos ClipRRect
                            child: ClipRRect(
                              // Los bordes del contenido del card se cortan usando BorderRadius
                              borderRadius: BorderRadius.circular(16),

                              // EL widget hijo que será recortado segun la propiedad anterior
                              child: Column(
                                children: <Widget>[
                                  // Usamos el widget Image para mostrar una imagen
                                  Image(
                                    // Como queremos traer una imagen desde un url usamos NetworkImage
                                    image: NetworkImage(
                                        'https://www.protek.com.py/sitio/wp-content/uploads/2019/12/obra-en-construcci%C3%B3n-1-1024x576.jpg'),
                                  ),

                                  // Usamos Container para el contenedor de la descripción
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text('Gestión de avance'),
                                  ),
                                ],
                              ),
                            ))
                      ]))
                ])),

                Container(
                    child: ListView(children: <Widget>[
                  GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GestionarProyecto())),
                      child: Column(children: <Widget>[
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            margin: EdgeInsets.all(15),
                            elevation: 10,

                            // Dentro de esta propiedad usamos ClipRRect
                            child: ClipRRect(
                              // Los bordes del contenido del card se cortan usando BorderRadius
                              borderRadius: BorderRadius.circular(16),

                              // EL widget hijo que será recortado segun la propiedad anterior
                              child: Column(
                                children: <Widget>[
                                  // Usamos el widget Image para mostrar una imagen
                                  Image(
                                    // Como queremos traer una imagen desde un url usamos NetworkImage
                                    image: NetworkImage(
                                        'https://www.protek.com.py/sitio/wp-content/uploads/2019/12/obra-en-construcci%C3%B3n-1-1024x576.jpg'),
                                  ),

                                  // Usamos Container para el contenedor de la descripción
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text('Gestión de avance'),
                                  ),
                                ],
                              ),
                            ))
                      ]))
                ])),
              ],
              options: CarouselOptions(
                height: 250.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.8,
              )),
          Divider(),
          Container(
            margin: const EdgeInsets.only(top: 0.0),
            child: Text(
              'Eventos próximos',
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
