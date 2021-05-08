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

// import 'src/app.dart';

void main() {
  runApp(LoginApp());
}

Color colorappbar2 = Colors.green;
Color colorappbar = Color.fromRGBO(17, 97, 73, 4);
Color colorfondo = Color.fromRGBO(242, 242, 242, 10);
String identificadorusuario,
    rutafotoperfil,
    lognombreus,
    logapellidos,
    rolusuario;

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(fontFamily: 'Elegante'),
        debugShowCheckedModeBanner: false,
        title: 'Login',
        home: LoginPage(),
        routes: <String, WidgetBuilder>{
          '/app': (BuildContext context) => MyHomePage(),
          '/misproyectos': (BuildContext context) => MisProyectos(),
          '/homescreen': (BuildContext context) => MyHomePage(),
          '/LoginPage': (BuildContext context) => LoginPage(),
          '/DetallesContacto': (BuildContext context) => DetallesContacto(),
        });
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SharedPreferences sharedPreferences;
  String idusuariofinal;
  String url3 =
      'http://gestionaproyecto.com/phpproyectotitulo/getInfoPerfil.php';

  Future<void> loginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('token') != null) {
      idusuariofinal = sharedPreferences.getString('token');
      final response = await http.post(Uri.parse(url3), body: {
        "idusuario": idusuariofinal,
      });
      var datauser = json.decode(response.body);
      identificadorusuario = idusuariofinal;
      rutafotoperfil = datauser[0]['fotoperfil'];
      lognombreus = datauser[0]['nombreusuario'];
      logapellidos = datauser[0]['apellidos'];
      rolusuario = datauser[0]['codigorol'];

      print("hay un usuario conectado y es " + idusuariofinal);
      Navigator.pop(context);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    idusuariohome: idusuariofinal,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new FutureBuilder<void>(
          future: loginStatus(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? new Center(
                    child: new CircularProgressIndicator(),
                  )
                : new Formulariologin();
          }),
    );
  }
}

class Formulariologin extends StatefulWidget {
  @override
  _FormulariologinState createState() => _FormulariologinState();
}

class _FormulariologinState extends State<Formulariologin> {
  SharedPreferences sharedPreferences;
  String idusuariofinal;
  String url2 = 'http://gestionaproyecto.com/phpproyectotitulo/login.php';
  String url3 =
      'http://gestionaproyecto.com/phpproyectotitulo/getInfoPerfil.php';

  TextEditingController controllerusuario = new TextEditingController();
  TextEditingController controllerpass = new TextEditingController();

  String mensaje = '';
  String rol;

  Future<void> loginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('token') != null) {
      idusuariofinal = sharedPreferences.getString('token');
      final response = await http.post(Uri.parse(url3), body: {
        "idusuario": idusuariofinal,
      });
      var datauser = json.decode(response.body);
      identificadorusuario = idusuariofinal;
      rutafotoperfil = datauser[0]['fotoperfil'];
      rolusuario = datauser[0]['codigorol'];

      print("hay un usuario conectado y es " + idusuariofinal);
      Navigator.pop(context);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    idusuariohome: idusuariofinal,
                  )));
    }
  }

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
    return FutureBuilder(builder: (context, AsyncSnapshot snapshot) {
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
                            image: new AssetImage('assets/images/logo2.png')),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15.0, right: 30, left: 30),
                    child: new Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ListView(children: <Widget>[
                        Center(
                            child: Text(
                          "Inicia sesión",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: colorappbar),
                        )),
                        Padding(padding: EdgeInsets.only(bottom: 14)),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 8)
                              ]),
                          child: TextFormField(
                            controller: controllerusuario,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.account_box,
                                  color: Colors.black,
                                ),
                                hintText: 'Ingrese su correo o telefono'),
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
                                BoxShadow(color: Colors.black12, blurRadius: 8)
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
                                        color: colorappbar, fontSize: 17)))),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new RaisedButton(
                                child: new Text(
                                  "Ingresar",
                                  style: (TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                                ),
                                color: colorappbar,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
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
                                color: colorappbar,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                onPressed: () {
                                  login();
                                },
                              ),
                            ],
                          ),
                        ),
                        Text(mensaje,
                            style:
                                TextStyle(fontSize: 25.0, color: Colors.red)),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
