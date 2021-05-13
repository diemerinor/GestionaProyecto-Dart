import 'dart:convert';
import 'dart:ffi';

import 'package:gestionaproyecto/src/app.dart';
import 'package:gestionaproyecto/src/detallecontacto.dart';
import 'package:gestionaproyecto/src/detalleproyecto.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/login.dart';
import 'package:gestionaproyecto/src/misproyectos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// import 'src/app.dart';

void main() {
  runApp(LoginApp());
}

bool loggeado;

//Color colorappbar2 = Colors.green;
Color rojooscuro = Color.fromRGBO(185, 26, 26, 10);
Color colorappbar2 = Color.fromRGBO(17, 97, 73, 4);
Color colorappbar = Colors.green;

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
      loggeado = true;
    } else {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (loggeado == null)
            new Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: colorappbar2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Image(
                          image: new AssetImage('assets/images/logo3.png'))),
                  Text(
                    "Cargando...",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  )
                ],
              ),
            ),
          Expanded(
            child: new FutureBuilder<void>(
                future: loginStatus(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if (snapshot.hasData) {
                    return new Center(
                      child: new CircularProgressIndicator(),
                    );
                  } else {
                    return new Center(
                      child: new CircularProgressIndicator(),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
