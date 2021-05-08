import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:gestionaproyecto/main.dart';
import 'package:flutter/material.dart';
import 'package:gestionaproyecto/src/homescreen.dart';
import 'package:gestionaproyecto/src/recomendados.dart';
import 'package:gestionaproyecto/src/Notificaciones.dart';
import 'package:gestionaproyecto/src/detalleproyecto.dart';
import 'package:gestionaproyecto/src/infoperfil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => print('hi on menu icon'),
          );
        },
      ),
      title: Text('Hi friend'),
      actions: <Widget>[
        IconButton(
          icon: new Icon(Icons.merge_type),
          onPressed: () => print('hi on icon action'),
        ),
      ],
    ));
  }
}

class MyHomePage extends StatefulWidget {
  final String idusuariohome;
  MyHomePage({Key key, this.idusuariohome}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences sharedPreferences;
  int _selectedIndex = 1;

  TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> _widgetOptions = <Widget>[
    Contactos(idusuario: identificadorusuario),
    Homescreen(idusuario: identificadorusuario),
    InfoPerfil(idusuario: identificadorusuario),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  TextEditingController _controller;

  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }
  cerrarsesion() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('token');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginApp()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 242, 242, 10),
      appBar: AppBar(
        backgroundColor: colorappbar,
        elevation: 0,
        title: Text(
          'ConstruPro',
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),

        //
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Image(
                          image: new AssetImage('assets/images/logo3.png'))),
                  Text(
                    'ConstruPro',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                    colorappbar,
                    colorappbar,
                  ],
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter)),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 20,
                  ),
                  Padding(padding: EdgeInsets.only(right: 10)),
                  Text(
                    'Mi perfil',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InfoPerfil(
                              idusuario: identificadorusuario,
                            )));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.settings,
                    size: 20,
                  ),
                  Padding(padding: EdgeInsets.only(right: 10)),
                  Text(
                    'Configuración',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.help,
                    size: 20,
                  ),
                  Padding(padding: EdgeInsets.only(right: 10)),
                  Text(
                    'Ayuda',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.vpn_key,
                    size: 20,
                  ),
                  Padding(padding: EdgeInsets.only(right: 10)),
                  Text(
                    'Cerrar sesión',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              onTap: () {
                cerrarsesion();
              },
            ),
            Expanded(
              child: Text(''),
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Color.fromRGBO(46, 12, 21, 20),
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.people_alt_rounded),
      //       label: 'Contactos',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.account_circle),
      //       label: 'Mi perfil',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   unselectedItemColor: Colors.white70,
      //   selectedItemColor: Color.fromRGBO(219, 10, 20, 100),
      //   onTap: _onItemTapped,
      // ),
    );
  }
}
