import 'package:cityvista/other/enums/location_result.dart';
import 'package:latlong2/latlong.dart';

class CityLocation {
  final LatLng coords;
  final LocationResult result;
  final double zoom;

  CityLocation({
    required this.result,
    required this.coords,
    this.zoom = 12
  });
}