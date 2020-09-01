import 'package:latlong/latlong.dart';

class ScanModel {
  int id;
  String valor;
  String tipo;

  ScanModel({
    this.id,
    this.valor,
    this.tipo,
  }) {
    if (this.valor.contains('http')) {
      this.tipo = 'http';
    } else {
      this.tipo = 'geo';
    }
  }

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        valor: json["valor"],
        tipo: json["tipo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "valor": valor,
        "tipo": tipo,
      };

  LatLng getLatLng() {
    final lalo = valor.substring(4).split(',');
    final latitud = double.parse(lalo[0]);
    final longitud = double.parse(lalo[1]);
    return LatLng(latitud, longitud);
  }
}
