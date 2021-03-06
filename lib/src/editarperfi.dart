import 'package:gestionaproyecto/main.dart';
import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'dart:async';

import 'app.dart';

class EditarPerfil extends StatefulWidget {
  final String username2;
  final String idusuario;

  EditarPerfil({Key key, @required this.username2, @required this.idusuario})
      : super(key: key);
  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  TextEditingController controlleremail = new TextEditingController();
  TextEditingController controllernombreusuario = new TextEditingController();
  TextEditingController controllerusuario = new TextEditingController();
  TextEditingController controlleracercademi = new TextEditingController();
  SharedPreferences sharedPreferences;
  //Uri url = "http://192.168.0.9/proyectotitulo/getData.php";
  String url2 =
      'http://gestionaproyecto.com/phpproyectotitulo/getInfoPerfil.php';

  String mensaje = '';
  String rol;

  void initState() {
    super.initState();
    getinfoperfil();
  }

  Future<List> getinfoperfil() async {
    final response = await http.post(Uri.parse(url2), body: {
      "idusuario": identificadorusuario,
    });
    var datauser = json.decode(response.body);
    String nombreusuario = datauser[0]['nombreusuario'];
    String username3 = datauser[0]['apellidos'];
    String correo = datauser[0]['correousuario'];
    String acercademi = datauser[0]['acercademi'];
    controllernombreusuario.text = nombreusuario;
    controllerusuario.text = username3;
    controlleremail.text = correo;
    controlleracercademi.text = acercademi;

    return datauser;
  }

  loginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginApp()),
          (Route<dynamic> route) => false);
    } else {
      int identusuario;
      String valoraux = sharedPreferences.getString("token");
      identusuario = int.parse(valoraux);
      print(identusuario);
    }
  }

  String primermensaje = "Hola";

  @override
  Widget build(BuildContext context) {
    Future<List> editarInfoPersonal() async {
      String url3 =
          'http://gestionaproyecto.com/phpproyectotitulo/EditarInfoPersonal.php';
      final response = await http.post(Uri.parse(url3), body: {
        "idusuario": identificadorusuario,
        "nombre": controllernombreusuario.text,
        "apellidos": controllerusuario.text,
        "correo": controlleremail.text,
        "acercademi": controlleracercademi.text
      });
    }

    return Scaffold(
      backgroundColor: colorfondo,
      // appBar: AppBar(
      //   title: Text("Perfil"),
      //   backgroundColor: Colors.black87,
      // ),
      appBar: AppBar(
        title: new Text("Editar perfil"),
        backgroundColor: colorappbar,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Form(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: new BoxDecoration(
                        gradient: LinearGradient(
                            colors: [colorappbar2, colorappbar2],
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter),
                      ),

                      //color: Colors.lightBlue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (rutafotoperfil != null)
                            Container(
                              height: MediaQuery.of(this.context).size.height *
                                  0.20,
                              margin: EdgeInsets.only(bottom: 30.0, top: 30.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 6),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.fitHeight,
                                        image: new AssetImage(rutafotoperfil))),
                              ),
                            )
                          else
                            Container(
                              height: MediaQuery.of(this.context).size.height *
                                  0.20,
                              margin: EdgeInsets.only(bottom: 30.0, top: 30.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.red, width: 6),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: new AssetImage(
                                            'assets/images/sinfotoperfil.jpg'))),
                              ),
                            ),
                        ],
                      )),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Center(
                    child: Text("Datos Personales",
                        style: TextStyle(fontSize: 20)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(10),
                      elevation: 4,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            new Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Column(children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 5)
                                      ]),
                                  child: TextFormField(
                                    controller: controllernombreusuario,
                                    decoration: InputDecoration(
                                      hintText: 'Nombre usuario',
                                      icon: Icon(
                                        Icons.account_box,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 5)
                                      ]),
                                  child: TextFormField(
                                    controller: controllerusuario,
                                    decoration: InputDecoration(
                                      hintText: 'Apellidos',
                                      icon: Icon(
                                        Icons.account_box,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 5)
                                      ]),
                                  child: TextField(
                                    controller: controlleremail,
                                    decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.mail,
                                          color: Colors.black,
                                        ),
                                        hintText: 'Correo'),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 5)
                                      ]),
                                  child: TextFormField(
                                    maxLines: null,
                                    controller: controlleracercademi,
                                    decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.account_box,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                new RaisedButton(
                                  child: new Text("Editar"),
                                  color: Colors.red,
                                  textColor: Colors.white,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0)),
                                  onPressed: () {
                                    editarInfoPersonal();
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditarPerfil(
                                                idusuario: identificadorusuario,
                                              )),
                                    );
                                  },
                                ),
                                Text(mensaje,
                                    style: TextStyle(
                                        fontSize: 25.0, color: Colors.red)),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Padding(padding: EdgeInsets.only(top: 20)),
                  // Center(
                  //   child: Text("Acerca de m??", style: TextStyle(fontSize: 20)),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(20.0),
                  //   child: Card(
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10)),
                  //       margin: EdgeInsets.all(10),
                  //       elevation: 4,

                  //       // Dentro de esta propiedad usamos ClipRRect
                  //       child: ClipRRect(
                  //         // Los bordes del contenido del card se cortan usando BorderRadius
                  //         borderRadius: BorderRadius.circular(10),

                  //         // EL widget hijo que ser?? recortado segun la propiedad anterior
                  //         child: Column(
                  //           children: <Widget>[
                  //             new Container(
                  //               height:
                  //                   MediaQuery.of(context).size.height * 0.35,
                  //               width: MediaQuery.of(context).size.width * 0.80,
                  //               padding: EdgeInsets.only(top: 23),
                  //               child: ListView(
                  //                   physics:
                  //                       const NeverScrollableScrollPhysics(),
                  //                   children: <Widget>[
                  //                     Container(
                  //                       width:
                  //                           MediaQuery.of(context).size.width /
                  //                               1.2,
                  //                       padding: EdgeInsets.all(20),
                  //                       margin: EdgeInsets.only(top: 20),
                  //                       decoration: BoxDecoration(
                  //                           borderRadius: BorderRadius.all(
                  //                               Radius.circular(50)),
                  //                           color: Colors.white,
                  //                           boxShadow: [
                  //                             BoxShadow(
                  //                                 color: Colors.black12,
                  //                                 blurRadius: 5)
                  //                           ]),
                  //                       child: TextField(
                  //                         controller: controlleremail,
                  //                         decoration: InputDecoration(
                  //                             icon: Icon(
                  //                               Icons.mail,
                  //                               color: Colors.black,
                  //                             ),
                  //                             hintText: 'Correo'),
                  //                       ),
                  //                     ),
                  //                     Divider(),
                  //                     new RaisedButton(
                  //                       child: new Text("Ingresar"),
                  //                       color: Colors.red,
                  //                       textColor: Colors.white,
                  //                       shape: new RoundedRectangleBorder(
                  //                           borderRadius:
                  //                               new BorderRadius.circular(
                  //                                   30.0)),
                  //                       onPressed: () {},
                  //                     ),
                  //                     Text(mensaje,
                  //                         style: TextStyle(
                  //                             fontSize: 25.0,
                  //                             color: Colors.red)),
                  //                   ]),
                  //             ),
                  //           ],
                  //         ),
                  //       )),
                  // ),
                ],
              ),
            ),
          ),
          // children: <Widget>[
          //   Container(
          //       height: MediaQuery.of(context).size.height * 0.35,
          //       decoration: new BoxDecoration(
          //         gradient: LinearGradient(
          //             colors: [
          //               Color.fromRGBO(255, 0, 0, 70),
          //               Color.fromRGBO(255, 0, 0, 20)
          //             ],
          //             begin: FractionalOffset.topCenter,
          //             end: FractionalOffset.bottomCenter),
          //       ),

          //       //color: Colors.lightBlue,
          //       child: ListView(children: <Widget>[
          //         Container(
          //           height: MediaQuery.of(context).size.height * 0.27,
          //           decoration: new BoxDecoration(),
          //           margin: EdgeInsets.only(bottom: 30.0, top: 30.0),
          //           child: Container(
          //             decoration: BoxDecoration(
          //                 shape: BoxShape.circle,
          //                 image: DecorationImage(
          //                     fit: BoxFit.fill,
          //                     image: NetworkImage(
          //                         "https://i.imgur.com/BoN9kdC.png"))),
          //           ),
          //         ),
          //       ])),
          //   Container(
          //       margin: const EdgeInsets.only(top: 10.0),
          //       child: Text(
          //         username + apellidos,
          //         style: TextStyle(fontSize: 25),
          //         textAlign: TextAlign.center,
          //       )),
          //   Column(children: <Widget>[
          //     Padding(
          //       padding: const EdgeInsets.all(10.0),
          //     ),
          //     Text(
          //       'Acerca de mi:',
          //       style: TextStyle(fontSize: 25),
          //     ),
          //     Text(
          //       'Yepa que pasa gente yo soy lolito',
          //       style: TextStyle(fontSize: 25),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.all(10.0),
          //     ),
          //   ]),
          //   Container(
          //     margin: const EdgeInsets.only(top: 10.0),
          //     child: Text(
          //       'Telefono: ' + telefono,
          //       style: TextStyle(fontSize: 25),
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          //   Container(
          //     margin: const EdgeInsets.only(top: 10.0),
          //     child: Text(
          //       'Correo: ' + correousuario,
          //       style: TextStyle(fontSize: 25),
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          //   Container(
          //     margin: const EdgeInsets.only(right: 50, left: 50, top: 20),
          //     width: 80,
          //     child: RaisedButton(
          //         child: Text("Cerrar sesi??n"),
          //         textColor: Colors.white,
          //         color: Colors.redAccent,
          //         onPressed: () {
          //           // sharedPreferences.clear();
          //           // sharedPreferences.commit();
          //           Navigator.of(context).pushAndRemoveUntil(
          //               MaterialPageRoute(
          //                   builder: (BuildContext context) => LoginApp()),
          //               (Route<dynamic> route) => false);
          //         }),
          //   )
          // ],
        ),
      ),
    );
  }
}
