import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:qrreader/src/models/scan_model.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  MapController mapController = new MapController();
  String tipoMapa = 'mapbox.satellite';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              mapController.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15,
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan),
      ],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
          '{tileset_id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken':
            'pk.eyJ1IjoiZWxpYXNyYW1vczE1OSIsImEiOiJja2J6c3I5OXowZ24xMzhwOTVuazRxdzFlIn0.WLcQQ-m1u5F7viF0yj1rcQ',
        'tileset_id': tipoMapa, //streets, dark, light, outdoors, satellite
      },
    );
  }

  _crearMarcadores(ScanModel scan) {
    return MarkerLayerOptions(markers: <Marker>[
      Marker(
        width: 100.0,
        height: 100.0,
        point: scan.getLatLng(),
        builder: (context) => Container(
          child: Icon(
            Icons.location_on,
            size: 45.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    ]);
  }

  Widget _crearBotonFlotante(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        //mapbox.terrain-rgb mapbox.mapbox-streets-v8

        if (tipoMapa == 'mapbox.satellite') {
          tipoMapa = 'mapbox.terrain-rgb';
        } else if (tipoMapa == 'mapbox.terrain-rgb') {
          tipoMapa = 'mapbox.mapbox-streets-v8';
        } else {
          tipoMapa = 'mapbox.satellite';
        }
        setState(() {});
      },
    );
  }
}
