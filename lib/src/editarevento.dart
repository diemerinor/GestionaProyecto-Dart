import 'package:flutter/material.dart';
import 'package:gestionaproyecto/main.dart';
import 'package:gestionaproyecto/src/gestionavance.dart';

import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'dart:async';
import 'dart:convert';

import 'dart:async';

import 'listareventos.dart';

class EditarEvento extends StatefulWidget {
  final String idproyecto;
  final String idevento;

  const EditarEvento({Key key, this.idproyecto, this.idevento})
      : super(key: key);

  @override
  _EditarEventoState createState() => _EditarEventoState();
}

class _EditarEventoState extends State<EditarEvento> {
  String url = 'http://gestionaproyecto.com/phpproyectotitulo/EditarEvento.php';
  var datauser2;
  TextEditingController controllernombre = new TextEditingController();
  TextEditingController controllerdescripcion = new TextEditingController();
  final dateController = TextEditingController();
  final dateController2 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    dateController.dispose();
    super.dispose();
  }

  DateTime fechadeahora = DateTime.now();
  String textofecha;
  DateTime fechareporte;
  TimeOfDay horareporte;
  String horita;
  String fechaevento;
  String fechapubli;
  DateTime aux;
  TimeOfDay aux2 = TimeOfDay.now();

  String fechass;
  String variablephp;
  @override
  void initState() {
    super.initState();
    fechadehoy(true);
    getInfoEvento();
  }

  Future<List> getInfoEvento() async {
    print("el id evento es " + widget.idevento);
    String url4 =
        'http://gestionaproyecto.com/phpproyectotitulo/getInfoEvento.php';
    final response = await http.post(Uri.parse(url4),
        body: {"idevento": widget.idevento, "idproyecto": widget.idproyecto});
    var datauser = jsonDecode(response.body);
    controllernombre.text = datauser[0]['titulo'];
    controllerdescripcion.text = datauser[0]['descripcion'];
    dateController.text = datauser[0]['fechaevento2'];
    dateController2.text = datauser[0]['hora'];
    var aux5 = datauser[0]['fechaevento'];
    aux = DateTime.parse(aux5);
    aux2 = TimeOfDay(hour: aux.hour, minute: aux.minute);

    print(datauser);
    //print("la cosita es" + datauser);
    return datauser;
  }

  void fechadehoy(bool value) {
    bool fechaeshoy = value;
    if (fechaeshoy == true) {
      fechareporte = DateTime.now();
      final DateFormat formatter = DateFormat('dd-MM-yyyy');

      fechafinal = formatter.format(fechareporte);
      textofecha = fechafinal.toString();

      final DateFormat formatter2 = DateFormat('yyyy-MM-dd');
      String fechafinal2 = formatter2.format(fechareporte);
      variablephp = fechafinal2.toString();
    }
  }

  Future<List> editarevento() async {
    DateTime fechahoy = DateTime.now();
    fechapubli = fechahoy.toString();
    var fechaevento2 =
        DateTime(aux.year, aux.month, aux.day, aux2.hour, aux2.minute);
    fechaevento = fechaevento2.toString();
    final response = await http.post(Uri.parse(url), body: {
      "idevento": widget.idevento,
      "idusuario": identificadorusuario,
      "titulo": controllernombre.text,
      "descripcion": controllerdescripcion.text,
      "fechapublicacion": fechapubli,
      "fechaevento": fechaevento,
      "idproyecto": widget.idproyecto
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
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListarEventos(
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
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continuar"),
      onPressed: () {
        editarevento();
        Navigator.pop(context);
        showAlertDialog2(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("¿Está seguro de editar el evento? "),
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

  showAlertDialogerror(BuildContext context) {
    // set up the buttons

    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    AlertDialog alert = AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        child: Column(
          children: [
            Icon(
              Icons.warning,
              size: 40,
              color: colorappbar2,
            ),
            Text(
              "UPS",
              style: TextStyle(
                  color: colorappbar2,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            Text("Debe completar todos los datos"),
          ],
        ),
      ),
      actions: [
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(child: alert);
      },
    );
  }

  showAlertDialogerrorfecha(BuildContext context) {
    // set up the buttons

    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text("Debe introducir una fecha mayor o igual al día de hoy"),
      actions: [
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String fechafinal;
  String horafinal;
  String textohora = "Seleccione hora...";
  String mensaje = '';
  String rol;
  bool fechaeditable = false;

  bool _checkbox = true;
  bool _checkboxListTile = false;
  String seccionseleccionada;
  String unidadseleccionada;

  List idssecciones = List();
  String _selectedTime;
  String _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorfondo,
      appBar: AppBar(
        backgroundColor: colorappbar,
        title: Text("Editar evento"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Form(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(bottom: 20)),
                    Text(
                      "Título evento:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    TextFormField(
                      controller: controllernombre,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.alarm_add_sharp,
                            color: Colors.black,
                          ),
                          hintText: 'Nombre del evento'),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20)),
                    Text(
                      "Descripción evento:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    TextFormField(
                      maxLines: null,
                      controller: controllerdescripcion,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.description,
                            color: Colors.black,
                          ),
                          hintText: 'Información del evento'),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20)),
                    Text(
                      "Fecha evento:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        enabled: true,
                        readOnly: true,
                        controller: dateController,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.date_range,
                              color: Colors.black,
                            ),
                            hintText: textofecha),
                        onTap: () async {
                          var date = await showDatePicker(
                              context: context,
                              initialDate: aux,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100));

                          fechareporte = date;

                          final DateFormat formatter2 =
                              DateFormat('dd-MM-yyyy');
                          String fechafinal2 = formatter2.format(fechareporte);
                          aux = DateTime(fechareporte.year, fechareporte.month,
                              fechareporte.day);
                          setState(() {
                            textofecha = fechafinal2.toString();
                            dateController.text = textofecha;
                          });
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20)),
                    Text(
                      "Hora evento:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        enabled: true,
                        readOnly: true,
                        controller: dateController2,
                        onTap: () async {
                          TimeOfDay hour2 = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              initialEntryMode: TimePickerEntryMode.input,
                              builder: (context, _) {
                                return MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: true),
                                    // If you want 24-Hour format, just change alwaysUse24HourFormat to true
                                    child: _);
                              });

                          aux2 =
                              TimeOfDay(hour: hour2.hour, minute: hour2.minute);
                          //aux = TimeOfDay(hour2.hour, hour2.minute);
                          setState(() {
                            var auxhora = aux2.hour.toString();
                            var auxminute = aux2.minute.toString();
                            textohora = auxhora + ":" + auxminute;
                            dateController2.text = textohora;
                          });
                        },
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.alarm,
                              color: Colors.black,
                            ),
                            hintText: textohora),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: new RaisedButton(
                          child: new Text(
                            "Editar evento",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          color: colorappbar,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                          onPressed: () {
                            DateTime fechaaux = DateTime.now();
                            print(fechaaux);
                            print(fechareporte);
                            print(fechaaux.difference(aux).inMinutes);
                            if (controllerdescripcion.text == null ||
                                controllerdescripcion.text == '' ||
                                controllernombre.text == null ||
                                controllernombre.text == '' ||
                                fechareporte == null) {
                              showAlertDialogerror(context);
                            } else {
                              if (fechaaux.difference(fechareporte).inMinutes <=
                                  0) {
                                print(fechaaux.difference(fechareporte).inDays);
                                showAlertDialog(context);
                              } else {
                                showAlertDialogerrorfecha(context);

                                print(fechaaux.difference(fechareporte).inDays);
                              }
                            }
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
      ),
    );
  }
}
