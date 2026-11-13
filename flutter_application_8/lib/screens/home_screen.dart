import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/location_service.dart';
import '../services/camera_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final LocationService _locationService = LocationService();
  final CameraService _cameraService = CameraService();

  Position? ubicacion;
  String? imagen;
  DateTime? horaRegistro;

  bool cargando = false;

  Future<void> registrarEvidencia() async {

    setState(() {
      cargando = true;
      imagen = null;
      ubicacion = null;
      horaRegistro = null;
    });

    try {

      Position posicion =
          await _locationService.obtenerUbicacion();

      // Abrir la cámara después de obtener la ubicación GPS
      String? foto = await _cameraService.tomarFotografia();

      if (foto != null) {
        setState(() {
          ubicacion = posicion;
          imagen = foto;
          horaRegistro = DateTime.now();
        });
      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

    } finally {

      setState(() {
        cargando = false;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora de Campo'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            const Icon(
              Icons.assignment,
              size: 80,
              color: Colors.blue,
            ),

            const SizedBox(height: 15),

            const Text(
              'Registro de Evidencias',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Obtén tu ubicación GPS y toma una fotografía '
              'para registrar tu evidencia de campo.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: cargando ? null : registrarEvidencia,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Registrar Evidencia'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 25),

            if (cargando)
              const Center(
                child: CircularProgressIndicator(),
              ),

            if (imagen != null && ubicacion != null) ...[

              const Text(
                'Evidencia Registrada',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(imagen!),
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 20),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        'Datos de la evidencia',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        'Latitud: ${ubicacion!.latitude}',
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Longitud: ${ubicacion!.longitude}',
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Hora: ${horaRegistro!.hour.toString().padLeft(2, '0')}:'
                        '${horaRegistro!.minute.toString().padLeft(2, '0')}:'
                        '${horaRegistro!.second.toString().padLeft(2, '0')}',
                      ),

                      const SizedBox(height: 5),

                      Text(
                        'Fecha: ${horaRegistro!.day}/'
                        '${horaRegistro!.month}/'
                        '${horaRegistro!.year}',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}