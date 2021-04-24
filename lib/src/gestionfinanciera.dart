import 'package:flutter/material.dart';

class GestionFinanciera extends StatefulWidget {
  final String idproyecto;

  GestionFinanciera({Key key, this.idproyecto}) : super(key: key);
  @override
  _GestionFinancieraState createState() => _GestionFinancieraState();
}

class _GestionFinancieraState extends State<GestionFinanciera> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestion Financiera")),
    );
  }
}
