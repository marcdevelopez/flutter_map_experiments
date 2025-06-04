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
    r'''^\s*(\d{1,3})°(?:\s*(\d{1,2})')?(?:\s*(\d{1,2})")?\s*([NSEWO])?\s*$''',
  );
  final decimalWithDirection = RegExp(
    r'''^\s*(\d+(?:\.\d+)?)\s*°?\s*([NSEWO])\s*$''',
  );

  // 1. Caso: Decimal con dirección cardinal
  final decimalMatch = decimalWithDirection.firstMatch(input);
  if (decimalMatch != null) {
    final value = double.parse(decimalMatch.group(1)!);
    final dir = decimalMatch.group(2)!;
    return (dir == 'S' || dir == 'W' || dir == 'O') ? -value : value;
  }

  // 2. Caso: DMS
  final match = dmsRegExp.firstMatch(input);
  if (match == null) return null;

  final degrees = int.parse(match.group(1)!);
  final minutes = match.group(2) != null ? int.parse(match.group(2)!) : 0;
  final seconds = match.group(3) != null ? int.parse(match.group(3)!) : 0;
  final direction = match.group(4);

  double decimal = degrees + (minutes / 60) + (seconds / 3600);
  if (direction == 'S' || direction == 'W' || direction == 'O') {
    decimal = -decimal;
  }

  return decimal;
}
