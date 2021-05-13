import 'dart:convert';
import 'dart:ffi';

import 'package:gestionaproyecto/src/app.dart';
import 'package:gestionaproyecto/src/detallecontacto.dart';
import 'package:gestionaproyecto/src/detalleproyecto.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/misproyectos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'gestionavance.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  SharedPreferences sharedPreferences;
  TextEditingController controllerusuario = new TextEditingController();
  TextEditingController controllerpass = new TextEditingController();
  String url2 = 'http://gestionaproyecto.com/phpproyectotitulo/login.php';

  Future<List> login() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(url2), body: {
      "nombreusuario": controllerusuario.text,
      "password": controllerpass.text,
    });

    var datauser = json.decode(response.body);

    if (datauser.length == 0) {
      setState(() {
        mensaje = "Usuario o contraseña incorrecta";
      });
    }

    if (datauser.length != 0) {
      identificadorusuario = datauser[0]['idusuario'];
      rutafotoperfil = datauser[0]['fotoperfil'];

      sharedPreferences.setString("token", datauser[0]['idusuario']);
      String idusuariofinal = datauser[0]['idusuario'];
      print("EL usuario que ingreso es" + idusuariofinal);
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    idusuariohome: datauser[0]['idusuario'],
                  )));
    }
    return datauser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(builder: (context, AsyncSnapshot snapshot) {
              return Scaffold(
                body: SingleChildScrollView(
                  child: Form(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: new BoxDecoration(
                          image: new DecorationImage(
                              image: new AssetImage(
                                "assets/images/fondologin4.jpg",
                              ),
                              fit: BoxFit.cover)),
                      child: ListView(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 60.0),
                            child: new Container(
                              height: 145.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: new AssetImage(
                                        'assets/images/logo2.png')),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, right: 30, left: 30),
                            child: new Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: ListView(children: <Widget>[
                                Center(
                                    child: Text(
                                  "Inicia sesión",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: colorappbar2),
                                )),
                                Padding(padding: EdgeInsets.only(bottom: 14)),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 8)
                                      ]),
                                  child: TextFormField(
                                    controller: controllerusuario,
                                    decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.account_box,
                                          color: Colors.black,
                                        ),
                                        hintText:
                                            'Ingrese su correo o telefono'),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(20),
                                  margin: EdgeInsets.only(top: 20),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 8)
                                      ]),
                                  child: TextField(
                                    controller: controllerpass,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.vpn_key,
                                          color: Colors.black,
                                        ),
                                        hintText: 'Ingrese su contraseña'),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text('Olvidé mi contraseña',
                                            style: TextStyle(
                                                color: colorappbar,
                                                fontSize: 17)))),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      new RaisedButton(
                                        child: new Text(
                                          "Ingresar",
                                          style: (TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                        ),
                                        color: colorappbar2,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    20.0)),
                                        onPressed: () {
                                          login();
                                        },
                                      ),
                                      new RaisedButton(
                                        child: new Text(
                                          "Registrarme",
                                          style: (TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                        ),
                                        color: colorappbar2,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    20.0)),
                                        onPressed: () {
                                          login();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
