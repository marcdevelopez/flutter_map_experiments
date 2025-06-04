/* 
 * conversion.dart
 * 
 * Utility to convert geographic coordinates from DMS (Degrees, Minutes, Seconds)
 * format to decimal degrees (LatLng).
 * 
 * This enables support for common input formats such as:
 *   - 36°30'41" N
 *   - 4°53'00" W
 * 
 * Purpose:
 * Many online coordinate tools and maps provide DMS-style coordinates.
 * This converter ensures users can input those values directly and still
 * interact with mapping tools like `flutter_map`, which require decimal format.
 * 
 * Usage:
 * Call `dmsToDecimal("36°30'41\" N")` and receive a `double` in return.
 */

double? dmsToDecimal(String input) {
  final dmsRegExp = RegExp(
    r'''(\d{1,3})°(\d{1,2})'(\d{1,2})"\s*([NSEWO])''',
    caseSensitive: false,
  );

  final match = dmsRegExp.firstMatch(input);
  if (match == null) return null;

  final degrees = int.parse(match.group(1)!);
  final minutes = int.parse(match.group(2)!);
  final seconds = int.parse(match.group(3)!);
  final direction = match.group(4)!;

  double decimal = degrees + (minutes / 60) + (seconds / 3600);

  // If the direction is south or west, the value must be negative

  if (direction == 'S' || direction == 'O' || direction == 'W') {
    decimal = -decimal;
  }

  return decimal;
}
