import 'package:geolocator/geolocator.dart';

class LocationService {

  Future<Position> obtenerUbicacion() async {

    // Obtener la ubicación actual y validar que el GPS esté encendido
    bool servicioActivo =
        await Geolocator.isLocationServiceEnabled();

    if (!servicioActivo) {
      throw Exception('Activa el GPS de tu dispositivo');
    }

    LocationPermission permiso =
        await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    if (permiso == LocationPermission.denied ||
        permiso == LocationPermission.deniedForever) {
      throw Exception('No se tienen permisos de ubicación');
    }

    Position posicion = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    return posicion;
  }
}