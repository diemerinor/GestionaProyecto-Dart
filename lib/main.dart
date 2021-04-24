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

Color colorappbar = Color.fromRGBO(46, 12, 21, 20);
String identificadorusuario, rutafotoperfil, lognombreus, logapellidos;

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      mensaje = "Usuario o contraseña incorrecta";
    } else {
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
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage(
                        "assets/images/fondologin3.jpg",
                      ),
                      fit: BoxFit.cover)),
              child: ListView(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(top: 107),
                    child: new CircleAvatar(
                      backgroundColor: Colors.yellow,
                    ),
                    width: 245.0,
                    height: 285.0,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                  ),
                  new Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    padding: EdgeInsets.only(top: 23),
                    child: ListView(children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 5)
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
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 5)
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
                          alignment: Alignment.center,
                          child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text('Olvidé mi contraseña',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17)))),
                      new RaisedButton(
                        child: new Text("Ingresar"),
                        color: Colors.yellow,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: () {
                          login();
                        },
                      ),
                      Text(mensaje,
                          style: TextStyle(fontSize: 25.0, color: Colors.red)),
                    ]),
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
