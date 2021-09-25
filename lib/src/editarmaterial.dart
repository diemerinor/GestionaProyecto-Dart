import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/gestionmateriales.dart';

import 'package:flutter/services.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

bool recibido = false;

class EditarMaterial extends StatefulWidget {
  final String idproyecto;
  final String idmaterial;

  const EditarMaterial({Key key, this.idproyecto, this.idmaterial})
      : super(key: key);
  @override
  _EditarMaterialState createState() => _EditarMaterialState();
}

class _EditarMaterialState extends State<EditarMaterial> {
  String url =
      'http://gestionaproyecto.com/phpproyectotitulo/EditarMaterial.php';
  var datauser2;

  TextEditingController controllernombre = new TextEditingController();
  TextEditingController controllerstock = new TextEditingController();
  final dateController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    dateController.dispose();
    super.dispose();
  }

  String url4 =
      'http://gestionaproyecto.com/phpproyectotitulo/getInfoMaterial.php';
  @override
  void initState() {
    super.initState();
    getmaterial();
  }

  String fechafinal;
  Future<List> getmaterial() async {
    print("el id material es " + widget.idmaterial);

    final response = await http.post(Uri.parse(url4), body: {
      "idmaterial": widget.idmaterial,
      "idproyecto": widget.idproyecto
    });
    var datauser = jsonDecode(response.body);
    controllernombre.text = datauser[0]['nombrerecurso'];
    controllerstock.text = datauser[0]['stock'];
    setState(() {
      recibido = true;
    });
    print(datauser);
    //print("la cosita es" + datauser);
    return datauser;
  }

  Future<List> insertmaterial() async {
    final response = await http.post(Uri.parse(url), body: {
      "idmaterial": widget.idmaterial,
      "nombrerecurso": controllernombre.text,
      "stockinicial": controllerstock.text,
    });
  }

  showAlertDialog2(BuildContext context) {
    // set up the buttons

    Widget continueButton = FlatButton(
      child: Text("Continuar"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GestionarMateriales(
                      idproyecto: widget.idproyecto,
                    )));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Se ha editado correctamente"),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continuar"),
      onPressed: () {
        insertmaterial();
        Navigator.pop(context);
        showAlertDialog2(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("¿Está seguro de editar el material?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorappbar,
        title: Text("Editar material"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (recibido == false)
              Center(child: CircularProgressIndicator())
            else if (recibido == true)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.only(bottom: 20)),
                          Text(
                            "Nombre Material (*)",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          TextFormField(
                            controller: controllernombre,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.extension_rounded,
                                  color: Colors.black,
                                ),
                                hintText: ''),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 20)),
                          Text(
                            "Stock Material (*)",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          TextFormField(
                            controller: controllerstock,
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.format_list_numbered,
                                  color: Colors.black,
                                ),
                                hintText: 'Ingrese el nombre'),
                            inputFormatters: [
                              FilteringTextInputFormatter.singleLineFormatter
                            ],
                            keyboardType: TextInputType.number,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Center(
                              child: RaisedButton(
                                child: new Text(
                                  "Editar material",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: colorappbar,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                onPressed: () {
                                  showAlertDialog(context);

                                  //login();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
