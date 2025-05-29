import 'package:flutter/material.dart';

class LatLonInput extends StatelessWidget {
  const LatLonInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        TextField(
          decoration: InputDecoration(labelText: 'Latitude'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Longitude'),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
