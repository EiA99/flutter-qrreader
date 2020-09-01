import 'package:flutter/material.dart';

import 'package:qrreader/src/bloc/scans_bloc.dart';
import 'package:qrreader/src/models/scan_model.dart';
import 'package:qrreader/src/utils/utils.dart' as utils;

class MapasPages extends StatelessWidget {
  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    scansBloc.obtenerScans();

    return StreamBuilder(
      stream: scansBloc.scansStreamGeo,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final scans = snapshot.data;
        if (scans.length == 0) {
          return Center(child: Text('No hay información'));
        }
        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, i) => Dismissible(
            key: UniqueKey(),
            background: Container(color: Colors.deepOrange),
            onDismissed: (direction) => scansBloc.borrarScans(scans[i].id),
            child: ListTile(
              leading: Icon(
                Icons.zoom_out_map,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(scans[i].valor),
              subtitle: Text(scans[i].id.toString()),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () => utils.abrirScan(context, scans[i]),
            ),
          ),
        );
      },
    );
  }
}
