import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pnvr/form_inspecion.dart';
import 'package:pnvr/inspecciones_list.dart';
import 'package:pnvr/loginScreen.dart';
import 'package:pnvr/menu.dart';
import 'package:pnvr/moduloexp.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Inspección',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/menu': (context) => MenuScreen(),
        '/expediente': (context) => ExpedienteScreen(),
        '/inspeccion': (context) => InspeccionFormScreen(),
        '/inspecciones-list': (context) => InspeccionesListScreen(),
      },
    );
  }
}
