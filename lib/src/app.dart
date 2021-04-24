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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorappbar,
        // leading: Builder(
        //   builder: (BuildContext context) {
        //     return IconButton(
        //       icon: const Icon(Icons.menu),
        //       onPressed: () => print('hi on menu icon'),
        //     );
        //   },
        // ),
        title: Center(
          child: Text(
            'Gestiona proyecto ',
            textAlign: TextAlign.center,
          ),
        ),
        //
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(46, 12, 21, 20),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded),
            label: 'Contactos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Mi perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.white70,
        selectedItemColor: Color.fromRGBO(219, 10, 20, 100),
        onTap: _onItemTapped,
      ),
    );
  }
}
