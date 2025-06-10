import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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
  /* Al abrir la pantalla, se llama a initState() → ejecutamos _loadLocation() 
   * para buscar la ubicación actual. MUY IMPORTANTE PARA PODER VER LA PANTALLA!
  */
  // MÉTODOS AUXILIARES
  void updateDestination(double lat, double lon) {
    final destination = LatLng(lat, lon);
    setState(() {
      destinationPosition = destination;
    });

    if (currentPosition != null) {
      final bounds = LatLngBounds.fromPoints([currentPosition!, destination]);

      _mapController.fitCamera(
        CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(40)),
      );
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
  Future<void> _loadLocation() async {
    final position = await LocationService.getCurrentPosition();
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
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
}
