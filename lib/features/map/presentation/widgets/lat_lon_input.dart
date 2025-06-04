import 'package:flutter/material.dart';
import 'package:flutter_map_experiments/shared/utils/conversion.dart';

class LatLonInput extends StatefulWidget {
  final void Function(double lat, double lon) onSubmit;
  // El widget recibirá una función como parámetro y esta será requerida:
  const LatLonInput({super.key, required this.onSubmit});

  @override
  // Especificamos el tipo real del State para mejorar el autocompletado del IDE
  State<LatLonInput> createState() => _LatLonInputState();
}

class _LatLonInputState extends State<LatLonInput> {
  final _latController = TextEditingController();
  final _lonController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Para validar el input

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Campo para Latitud:
          TextFormField(
            controller: _latController,
            decoration: const InputDecoration(labelText: 'Latitude'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Introduce una latitud';
              }
              // Evitamos error al escribir coma en vez de punto:
              final normalized = value.replaceAll(',', '.').trim();
              final parsed =
                  double.tryParse(normalized) ?? dmsToDecimal(normalized);
              if (parsed == null || parsed < -90 || parsed > 90) {
                return 'Latitud no válida (-90 a 90)';
              }
              return null;
            },
          ),
          // Campo para Longitud:
          TextFormField(
            controller: _lonController,
            decoration: const InputDecoration(labelText: 'Longitude'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Introduce una longitud';
              }
              final normalized = value.replaceAll(',', '.').trim();
              final parsed =
                  double.tryParse(normalized) ?? dmsToDecimal(normalized);
              if (parsed == null || parsed < -180 || parsed > 180) {
                return 'Longitud no válida (-180 a 180)';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final latText = _latController.text.replaceAll(',', '.').trim();
                final lonText = _lonController.text.replaceAll(',', '.').trim();

                final lat = double.tryParse(latText) ?? dmsToDecimal(latText);
                final lon = double.tryParse(lonText) ?? dmsToDecimal(lonText);

                if (lat != null && lon != null) {
                  widget.onSubmit(lat, lon);
                }
              }
            },
            child: const Text('Trazar ruta'),
          ),
        ],
      ),
    );
  }
}
