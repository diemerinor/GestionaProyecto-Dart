import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/detallemovimientos.dart';
import 'package:gestionaproyecto/src/registrargasto.dart';
import 'package:gestionaproyecto/src/registraringreso.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'dart:async';
import 'dart:convert';

String caja;

String nombreproyectoss;
int cajafinal;

class GestionFinanciera extends StatefulWidget {
  final String idproyecto;

  GestionFinanciera({Key key, this.idproyecto}) : super(key: key);
  @override
  _GestionFinancieraState createState() => _GestionFinancieraState();
}

class _GestionFinancieraState extends State<GestionFinanciera> {
  String url2 =
      'http://gestionaproyecto.com/phpproyectotitulo/getMovimientos.php';

  String cajafinal2;

  Future<List> getFinanciera() async {
    final response = await http.post(Uri.parse(url2), body: {
      "idproyecto": widget.idproyecto,
    });

    var datauser = json.decode(response.body);
    int cantmov = datauser.length;
    cajafinal = 0;
    if (datauser != null) {
      nombreproyectoss = datauser[0]['nombreproyecto'];
      //caja = datauser[cantmov]['total'];
      //cajafinal = int.parse(caja);

      for (int i = 0; i < cantmov; i++) {
        var aux1 = datauser[i]['ingreso'];
        int aux2 = int.parse(aux1);
        if (datauser[i]['idtipomovimiento'] == '1') {
          cajafinal = cajafinal + aux2;
        } else if (datauser[i]['idtipomovimiento'] == '2') {
          cajafinal = cajafinal - aux2;
        }
      }

      cantmov = cantmov - 1;

      cajafinal2 = (NumberFormat.simpleCurrency(name: 'USD', decimalDigits: 0)
          .format(cajafinal));
    }
    return datauser;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gestion Financiera",
        ),
        backgroundColor: colorappbar,
      ),
      backgroundColor: colorfondo,
      body: Column(
        children: [
          Expanded(
            child: new FutureBuilder<List>(
                future: getFinanciera(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if (snapshot.hasData) {
                    return new listarinfofinanciera(
                      listainfo: snapshot.data,
                      idproyecto: widget.idproyecto,
                      cajafinal2: cajafinal2,
                      cajafinal: cajafinal,
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

class listarinfofinanciera extends StatefulWidget {
  final List listainfo;
  final String idproyecto;
  final String cajafinal2;
  final int cajafinal;

  const listarinfofinanciera(
      {Key key,
      this.listainfo,
      this.idproyecto,
      this.cajafinal2,
      this.cajafinal})
      : super(key: key);
  @override
  _listarinfofinancieraState createState() => _listarinfofinancieraState();
}

class _listarinfofinancieraState extends State<listarinfofinanciera> {
  @override
  Widget build(BuildContext context) {
    return widget.listainfo == null
        ? Center(child: CircularProgressIndicator())
        : Container(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Text(
                            nombreproyectoss,
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.cajafinal2,
                                style: TextStyle(
                                    color: colorappbar,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Text(
                            "Saldo disponible",
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        color: colorappbar,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            '- Movimientos financieros -',
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                new DetalleMovimientos(
                                                    idproyecto:
                                                        widget.idproyecto,
                                                    saldo: widget.cajafinal2)),
                                      ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Card(
                                              elevation: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child:
                                                    Column(children: <Widget>[
                                                  Icon(Icons.list, size: 60),
                                                  Text(
                                                    'Listar\nmovimientos',
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ]),
                                              ))),
                                    ],
                                  )),
                              GestureDetector(
                                  onTap: () => {
                                        Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new RegistrarIngreso(
                                                    idproyecto:
                                                        widget.idproyecto,
                                                    caja: widget.cajafinal,
                                                  )),
                                        )
                                      },
                                  child: Column(
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Card(
                                              elevation: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child:
                                                    Column(children: <Widget>[
                                                  Icon(Icons.north_east,
                                                      size: 60),
                                                  Text(
                                                    'Registrar\ningreso',
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ]),
                                              ))),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 10)),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Card(
                                          elevation: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(children: <Widget>[
                                              Icon(Icons.bar_chart, size: 60),
                                              Text(
                                                'Balance\ngráfico',
                                                style: TextStyle(fontSize: 20),
                                                textAlign: TextAlign.center,
                                              ),
                                            ]),
                                          ))),
                                ],
                              )),
                              GestureDetector(
                                  onTap: () => {
                                        Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new RegistrarGasto(
                                                    idproyecto:
                                                        widget.idproyecto,
                                                    caja: widget.cajafinal,
                                                  )),
                                        )
                                      },
                                  child: Column(
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Card(
                                              elevation: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child:
                                                    Column(children: <Widget>[
                                                  Icon(Icons.south_east,
                                                      size: 60),
                                                  Text(
                                                    'Registrar\ngasto',
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ]),
                                              ))),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
