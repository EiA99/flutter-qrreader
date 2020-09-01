import 'dart:async';

import 'package:qrreader/src/models/scan_model.dart';

class Validations {
  final validarGeo = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink) {
      final geoScans = scans.where((element) => element.tipo == 'geo').toList();
      sink.add(geoScans);
    },
  );

  final validarHttp = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink) {
      final geoScans = scans.where((element) => element.tipo == 'http').toList();
      sink.add(geoScans);
    },
  );
}
