import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_experiments/features/map/data/services/routing_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_experiments/features/map/data/services/location_service.dart';
import 'package:flutter_map_experiments/features/map/presentation/widgets/lat_lon_input.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // VARIABLES DE ESTADO
  LatLng? currentPosition; // Si aun no se ha cargado puede ser null...
  LatLng? destinationPosition; // Puede no haberse cargado, y ser null (...?)
  final MapController _mapController = MapController();
  List<LatLng> routePoints = [];
  StreamSubscription<Position>? _positionSubscription;
  /* Al abrir la pantalla, se llama a initState() → ejecutamos _loadLocation() 
   * para buscar la ubicación actual. MUY IMPORTANTE PARA PODER VER LA PANTALLA!
  */
  // MÉTODOS AUXILIARES
  // Vamos a esperar una respuesta de la red
  void updateDestination(double lat, double lon) async {
    final destination = LatLng(lat, lon);
    setState(() {
      destinationPosition = destination;
      routePoints = []; // Limpiamos la ruta anterior al buscar una nueva
    });

    if (currentPosition != null) {
      // Ajustamos el zoom para ver ambos puntos
      final bounds = LatLngBounds.fromPoints([currentPosition!, destination]);
      _mapController.fitCamera(
        CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(40)),
      );

      // LÓGICA PARA OBTENER LA RUTA
      try {
        final route = await RoutingService.getRouteCoordinates(
          // Se pausa la ejecución hasta que nos devuelve la lista de coordenadas
          currentPosition!,
          destination,
        );
        setState(() {
          /*
          * Una vez tenemos la ruta, la guardamos en nuestra variable de estado
          * routePoints y llamamos a setState para que la pantalla se redibuje 
          * con la nueva línea.
          */
          routePoints = route;
        });
      } catch (e) {
        // Opcional: Mostrar un error al usuario si la ruta no se puede cargar
        print('Error al obtener la ruta: $e');
      }
    }
  }

  // MÉTODO DE CICLO DE VIDA
  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  // LÓGICA ASINCRONA DE LA CARGA
  /* Esperamos a que devuelva la posicion y cuando la obtiene la guarda en 
  *  currentPosition, mediante setState(). De esta forma redibujará la pantalla.
  */
  // Reemplaza tu método _loadLocation() por este
  Future<void> _loadLocation() async {
    try {
      // 1. Obtenemos la primera posición rápido para mostrar algo en pantalla
      final initialPosition = await LocationService.getCurrentPosition();
      setState(() {
        currentPosition = LatLng(
          initialPosition.latitude,
          initialPosition.longitude,
        );
      });

      // 2. Si todo va bien, empezamos a escuchar los cambios de posición
      _positionSubscription = LocationService.getPositionStream().listen((
        Position newPosition,
      ) {
        // Cada vez que el stream emite una nueva posición, este código se ejecuta
        setState(() {
          currentPosition = LatLng(newPosition.latitude, newPosition.longitude);
          print("Nueva ubicación: $currentPosition"); // Para depuración
        });

        // Opcional pero recomendado: Mueve la cámara del mapa a la nueva posición
        // La camara del mapa tiene un zoom apropiado para poder seguir la ruta
        _mapController.move(currentPosition!, 15.0);
      });
    } catch (e) {
      // Manejar error si no se pudo obtener la ubicación inicial
      print("Error al cargar la ubicación inicial: $e");
      // Aquí podrías mostrar un SnackBar o un diálogo al usuario
    }
  }

  // UI PRINCIPAL (mejor al final para mayor claridad en archivos State)
  @override
  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa con ubicación actual')),
      // Si la posición actual aún no se ha cargado, muestra un loader.
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          // Si ya está cargada muestra columna con mapa e input
          : Column(
              children: [
                Expanded(
                  flex: 3,
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      // Estamos seguros de que currentPosition no es null
                      initialCenter: currentPosition!,
                      initialZoom: 15.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName:
                            'com.example.flutter_map_experiments',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: currentPosition!,
                            width: 50,
                            height: 50,
                            // El marcador para posición actual será de color azul.
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.blue,
                              size: 30,
                            ),
                          ),
                          if (destinationPosition != null)
                            Marker(
                              point: destinationPosition!,
                              width: 50,
                              height: 50,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                        ],
                      ),
                      // Vamos a dibujar la ruta
                      if (routePoints.isNotEmpty)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points:
                                  routePoints, // coordenadas que debe seguir
                              // la línea.
                              strokeWidth: 4,
                              color: Colors.blueAccent,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: LatLonInput(
                      // le pasamos la función definida en _MapScreenState
                      onSubmit: updateDestination,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    // Cancelamos la suscripción al stream para dejar de escuchar las actualizaciones
    _positionSubscription?.cancel;
    super.dispose();
  }
}
