import 'dart:io';

import 'package:flutter/material.dart';

import 'package:qrscan/qrscan.dart' as scanner;

import 'package:qrreader/src/bloc/scans_bloc.dart';
import 'package:qrreader/src/models/scan_model.dart';
import 'package:qrreader/src/pages/direcciones_page.dart';
import 'package:qrreader/src/pages/mapas_page.dart';
import 'package:qrreader/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPagina = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: ScansBloc().borrarTodosScans,
          )
        ],
      ),
      body: _callPage(currentPagina),
      bottomNavigationBar: _crearBottonNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _callPage(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return MapasPages();
      case 1:
        return DireccionesPages();
      default:
        return MapasPages();
    }
  }

  Widget _crearBottonNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentPagina,
      onTap: (index) {
        setState(() {
          currentPagina = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.wifi_tethering),
          title: Text('Direcciones'),
        )
      ],
    );
  }

  _scanQR(BuildContext context) async {
    String futureString = '';

    try {
      futureString = await scanner.scan();
    } catch (e) {
      futureString = e.toString();
    }
    ScanModel nuevoScan = new ScanModel(valor: futureString);
    await ScansBloc().agregarScan(nuevoScan);

    if (Platform.isIOS) {
      Future.delayed(Duration(milliseconds: 750), () {
        utils.abrirScan(context, nuevoScan);
      });
    } else {
      utils.abrirScan(context, nuevoScan);
    }
  }
}
