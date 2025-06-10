// Import necessary packages.
import 'dart:convert'; // Used to decode the JSON response from the API.
import 'package:http/http.dart' as http; // Used to make HTTP requests.
import 'package:latlong2/latlong.dart'; // Provides the LatLng class for geographic coordinates.

// A service class to handle routing operations.
class RoutingService {
  // A static method to fetch route coordinates from an API.
  // It's 'async' because it performs a network request.
  // It returns a 'Future' that will resolve to a List of LatLng objects.
  static Future<List<LatLng>> getRouteCoordinates(LatLng start, LatLng end) async {
    
    // Construct the API endpoint URL for the OSRM (Open Source Routing Machine) project.
    // Note: The URL is incomplete in the screenshot. It should include both start and end coordinates.
    // A complete URL would look like: '.../driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson'
    final url = 'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson';

    // Send an asynchronous GET request to the specified URL and wait for the response.
    final response = await http.get(Uri.parse(url));

    // Check if the request was successful (HTTP status code 200 OK).
    if (response.statusCode == 200) {
      // Decode the JSON string from the response body into a Dart Map.
      final data = jsonDecode(response.body);

      // Extract the list of coordinates from the nested JSON object.
      // The structure ['routes'][0]['geometry']['coordinates'] is specific to the OSRM API response.
      final route = data['routes'][0]['geometry']['coordinates'] as List;

      // Transform the list of coordinates and return it.
      return route
          // .map() iterates over each 'point' in the 'route' list.
          // A 'point' from OSRM is a list like [longitude, latitude].
          .map((point) => LatLng(point[1], point[0])) // Convert each [lon, lat] pair into a LatLng(lat, lon) object.
          // .toList() converts the result of the map operation into a List.
          .toList();
    } else {
      // If the server returns an error, throw an exception.
      throw Exception('Error loading route');
    }
  }
}
