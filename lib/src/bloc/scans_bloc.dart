import 'dart:async';

import 'package:qrreader/src/providers/db_provider.dart';
import 'package:qrreader/src/bloc/validations.dart';

class ScansBloc with Validations {
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStreamGeo => _scansController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validarHttp);

  dispose() {
    _scansController?.close();
  }

  obtenerScans() async {
    _scansController.sink.add(await DBProvider.db.getAllScans());
  }

  agregarScan(ScanModel scanModel) async {
    await DBProvider.db.nuevoScan(scanModel);
    obtenerScans();
  }

  borrarScans(int id) async {
    await DBProvider.db.eliminarScans(id);
    obtenerScans();
  }

  borrarTodosScans() async {
    await DBProvider.db.deleteAll();
    obtenerScans();
  }
}
